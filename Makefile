# Copyright (C) 2023 The FMJ Helm Authors <info@fmj.studio>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

DBG_MAKEFILE ?=
ifeq ($(DBG_MAKEFILE),1)
$(warning ***** starting Makefile for goal(s) "$(MAKECMDGOALS)")
$(warning ***** $(shell date))
else
# If we're not debugging the Makefile, don't echo recipes.
MAKEFLAGS += -s
endif

# -------------------------------------
# Configuration
# -------------------------------------

SHELL := /bin/bash

export ROOT_DIR = $(shell git rev-parse --show-toplevel)
export ROOT_DIR_NAME = $(shell basename "$(ROOT_DIR)")
export PROJ_NAME = $(shell printf "%s-%s" $(ROOT_DIR_NAME) charts)

# ---------------------------
# Sources
# ---------------------------
FIND_FLAGS := -mindepth 1 -maxdepth 1 -type d

CHARTS := $(shell find $(ROOT_DIR)/charts $(FIND_FLAGS))

SOURCES := $(CHARTS)

# Only export variables from here since we do not want to mix the top-level
# Makfile's notion of 'SOURCES' with the different sub-makes
export

# ---------------------------
# Constants
# ---------------------------

# Build output
OUT_DIR := $(ROOT_DIR)/dist
CHARTS_OUT_DIR := $(OUT_DIR)/charts

SCRIPT_DIR := $(ROOT_DIR)/scripts

# Documentation
DOCS_DIR := $(ROOT_DIR)/docs
GIT_CLIFF_CONFIG := $(DOCS_DIR)/cliff.toml

DATE := $(shell date '+%d.%m.%y-%T')

# Development
KIND_CLUSTER_CONFIG := $(ROOT_DIR)/config/kind-config.yaml

# Executables
helm := helm
helmfile := helmfile
kind := kind

EXECUTABLES := $(helm) $(helmfile) $(kind)


# ---------------------------
# User-defined variables
# ---------------------------
PRINT_HELP ?=

CHART ?=
FILES ?=

# ---------------------------
# Custom functions
# ---------------------------

define log
 @case ${2} in \
  gray)    echo -e "\e[90m${1}\e[0m" ;; \
  red)     echo -e "\e[91m${1}\e[0m" ;; \
  green)   echo -e "\e[92m${1}\e[0m" ;; \
  yellow)  echo -e "\e[93m${1}\e[0m" ;; \
  *)       echo -e "\e[97m${1}\e[0m" ;; \
 esac
endef

define log_info
 $(call log, $(1), "gray")
endef

define log_success
 $(call log, $(1), "green")
endef

define log_notice
 $(call log, $(1), "yellow")
endef

define log_attention
 $(call log, $(1), "red")
endef


# -------------------------------------
# Targets
# -------------------------------------

# ---------------------------
#   Development Cluster
# ---------------------------

# Cluster Creation
define DEV_CLUSTER_INFO
# Create a local development Kubernetes cluster using 'kind'. This will also
# create a network within the Docker Engine named 'kind'.
#
# Arguments:
# 	PRINT_HELP: 'y' or 'n'
endef
.PHONY: dev-cluster
ifeq ($(PRINT_HELP),y)
dev-cluster:
	echo "$$DEV_CLUSTER_INFO"
else
dev-cluster: dev-cluster-networks
	$(call log_success, "Creating local 'kind' Kubernetes cluster using configuration in: $(KIND_CLUSTER_CONFIG)!")
	$(kind) create cluster \
		--config $(KIND_CLUSTER_CONFIG) \
		--name $(PROJ_NAME) \
		--wait 15s
endif

# Cluster Cleanup
define DEV_CLEANUP_INFO
# Remove the local development Kubernetes cluster.
#
# Arguments:
# 	PRINT_HELP: 'y' or 'n'
endef
.PHONY: dev-cleanup
ifeq ($(PRINT_HELP),y)
dev-cleanup:
	echo "$$DEV_CLEANUP_INFO"
else
dev-cleanup:
	$(call log_attention, "Removing local 'kind' Kubernetes cluster!")
	$(kind) delete cluster \
		--name $(PROJ_NAME)
endif

# ---------------------------
#   Charts
# ---------------------------
define TEMPLATE_INFO
# Run Helm's template engine on some or all files of a Helm chart. 
# The chart may be picked with the 'CHART' make variable whereas 'FILES'
# controls which files should be templated.
#
# Arguments:
#   PRINT_HELP: 'y' or 'n'
# 	CHART: charts/.. (any subdirectory)
# 	FILES: ... (e.g. configmap.yaml)
endef
.PHONY: template
ifeq ($(PRINT_HELP), y)
template:
	echo "$$TEMPLATE_INFO"
else
template:
	$(call log_info, "Templating files: $(FILES) for chart: $(CHART)")
	$(helm) template $(CHART) \
	ifdef FILES
		-s $(FILES) \
	endif
		--debug
endif


# make clean - Clean up after builds
.PHONY: clean
clean:
	@echo Removing temporary distribution directories..
	@rm -rf $(OUT_DIR)

# ---------------------------
# Dependant recipes
# ---------------------------
.PHONY: tools-check
tools-check:
	$(foreach exe,$(EXECUTABLES), $(if $(shell command -v $(exe) 2> /dev/null), $(info Found $(exe)), $(info Please install $(exe))))

create-dist:
ifeq (,$(findstring collections, $(WHAT)))
	$(call log_notice, "Creating distribution directory for Helm charts at: $(COLLECTIONS_OUT_DIR)")
	@mkdir -p $(CHARTS_OUT_DIR)
endif

