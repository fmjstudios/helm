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
SCRIPT_DIR := $(ROOT_DIR)/scripts
CONFIG_DIR := $(ROOT_DIR)/config
K8S_DIR := $(ROOT_DIR)/k8s

# Documentation
DOCS_DIR := $(ROOT_DIR)/docs
GIT_CLIFF_CONFIG := $(DOCS_DIR)/cliff.toml

DATE := $(shell date '+%d.%m.%y-%T')

# Executables
helm := helm
helmfile := helmfile
kind := kind
npx := npx

EXECUTABLES := $(helm) $(helmfile) $(kind) $(npx)

# Packages
README_GEN_PACKAGE := @bitnami/readme-generator-for-helm

# Internal Helm variables
ifdef CHART
CHART_NAME := $(shell basename $(CHART))
endif

# ---------------------------
# User-defined variables
# ---------------------------
PRINT_HELP ?=

CHART ?=
VALUES ?=
RELEASE_NAME ?= $(shell printf "%s-%s" $(CHART_NAME) test)
FILE ?=

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

# Development environment setup
define DEV_INFO
# Create a local development environment for Helm charts. This is a wrapper
# target which requires the 'dev-cluster' and 'dev-cluster-bootstrap' Make
# targets.
endef
.PHONY: dev
ifeq ($(PRINT_HELP), y)
dev:
	echo "$$DEV_INFO"
else
dev: dev-cluster dev-cluster-bootstrap
endif


# Cluster Creation
define DEV_CLUSTER_INFO
# Create a local development Kubernetes cluster using 'kind'. This will also
# create a network within the Docker Engine named 'kind'.
#
# Arguments:
#   PRINT_HELP: 'y' or 'n'
endef
.PHONY: dev-cluster
ifeq ($(PRINT_HELP),y)
dev-cluster:
	echo "$$DEV_CLUSTER_INFO"
else
dev-cluster:
	$(call log_success, "Creating local 'kind' Kubernetes cluster using configuration in: $(KIND_CLUSTER_CONFIG)!")
	$(kind) create cluster \
		--config $(K8S_DIR)/cluster/kind-config.yaml \
		--name $(PROJ_NAME) \
		--wait 15s
endif

# Cluster Bootstrap
define DEV_CLUSTER_BOOTSTRAP_INFO
# Bootstrap the development cluster for proper testing of Helm charts.
# Creates a Kubernetes secret containing CA information for cert-manager
# and installs Ingress-Nginx.
endef
.PHONY: dev-cluster-bootstrap
ifeq ($(PRINT_HELP), y)
dev-cluster-bootstrap:
	echo "$$DEV_CLUSTER_BOOTSTRAP_INFO"
else
dev-cluster-bootstrap:
	$(call log_success, "Bootstrapping development cluster")
	$(SCRIPT_DIR)/secrets.sh certs
	$(helmfile) apply -f $(K8S_DIR)/helmfile.yaml
endif


# Cluster Cleanup
define DEV_CLEANUP_INFO
# Remove the local development Kubernetes cluster.
#
# Arguments:
#   PRINT_HELP: 'y' or 'n'
endef
.PHONY: dev-cleanup
ifeq ($(PRINT_HELP),y)
dev-cleanup:
	echo "$$DEV_CLEANUP_INFO"
else
dev-cleanup:
	$(call log_attention, "Deleting local 'kind' Kubernetes cluster!")
	$(kind) delete cluster \
		--name $(PROJ_NAME)
endif

# ---------------------------
#   Charts
# ---------------------------
define BUILD_INFO
# Package a Helm Chart and put it into the repository's output directory
# at: ($(OUT_DIR)). The chart may be picked with the 'CHART' Make variable.
#
# Arguments:
#   PRINT_HELP: 'y' or 'n'
#   CHART: charts/.. (any subdirectory)
endef
.PHONY: build
ifeq ($(PRINT_HELP), y)
build:
	echo "$$BUILD_INFO"
else
build: create-dist
	$(call log_success, "Building Helm Chart $(CHART_NAME) into $(OUT_DIR)")
	$(helm) package $(CHART) --destination $(OUT_DIR)
endif

define INSTALL_INFO
# Install a Helm Chart onto the currently configured cluster. The chart may
# be picked with the 'CHART' Make variable. By default the default values are
# used but they may be configured with the 'VALUES' Make variable. The variable
# however is restricted to chart-local files.
#
# Arguments:
#   PRINT_HELP: 'y' or 'n'
#   CHART: charts/.. (any subdirectory)
#   VALUES: chart-local path to values (e.g. "ci/test-values.yaml")
endef
.PHONY: install
ifeq ($(PRINT_HELP), y)
install:
	echo "$$INSTALL_INFO"
else
install:
	$(call log_success, "Installing Helm Chart $(CHART_NAME) using values: $(VALUES)")
ifdef VALUES
	$(helm) install $(RELEASE_NAME) $(CHART) --values $(CHART)/$(VALUES)
else
	$(helm) install $(RELEASE_NAME) $(CHART)
endif
endif


define TEMPLATE_INFO
# Run Helm's template engine on some or all files of a Helm Chart.
# The chart may be picked with the 'CHART' Make variable whereas 'FILE'
# controls which file should be templated. Omitting a value for the Make
# variable 'FILE' runs the template engine for all chart contents.
#
# Arguments:
#   PRINT_HELP: 'y' or 'n'
#   CHART: charts/.. (any subdirectory)
#   FILES: ... (e.g. configmap.yaml)
endef
.PHONY: template
ifeq ($(PRINT_HELP), y)
template:
	echo "$$TEMPLATE_INFO"
else
template:
	$(call log_success, "Templating file: $(FILE) for chart: $(CHART)")
ifdef FILES
	$(helm) template $(CHART) -s $(foreach file,$(FILE),templates/$(FILE)) --debug
else
	$(helm) template $(CHART) --debug
endif
endif

define DRY_INSTALL_INFO
# Run a Helm "dry" installation for the specified Helm Chart.
# The chart may be picked with the 'CHART' Make variable. Since Helm
# requires a release name to perform the dry installation the chart name
# will be suffixed with '-test' to satisfy this requirement.
#
# Arguments:
#   PRINT_HELP: 'y' or 'n'
#   CHART: charts/.. (any subdirectory)
#   VALUES: chart-local path to values (e.g. "ci/test-values.yaml")
endef
.PHONY: dry-install
ifeq ($(PRINT_HELP), y)
dry-install:
	echo "$$DRY_INSTALL_INFO"
else
dry-install:
	$(call log_success, "Running Helm dry installation for chart: $(CHART)")
ifdef VALUES
	$(helm) install $(RELEASE_NAME) $(CHART) --values $(CHART)/$(VALUES) --debug --dry-run
else
	$(helm) install $(RELEASE_NAME) $(CHART) --debug --dry-run
endif
endif

define GENERATE_README_INFO
# Run Bitnami's (VMware) README generator for Helm chart on the specified Chart.
# The generator will use the configuration file 'reamde-gen.json' in the 'config'
# subdirectory. The chart may be picked with the 'CHART' Make variable.
endef
.PHONY: readme-gen
ifeq ($(PRINT_HELP), y)
readme-gen:
	echo "$$GENERATE_README_INFO"
else
readme-gen:
	$(call log_success, "Generating README Helm Chart table for chart: $(CHART)")
	$(npx) $(README_GEN_PACKAGE) \
		-c $(CONFIG_DIR)/readme-gen.json \
		-v $(CHART)/values.yaml \
		-r $(CHART)/README.md
endif

# make clean - Clean up after builds
.PHONY: clean
clean:
	@echo Removing temporary distribution directories..
	@rm -rf $(OUT_DIR)

.PHONY: tools-check
tools-check:
	$(foreach exe,$(EXECUTABLES), $(if $(shell command -v $(exe) 2> /dev/null), $(info Found $(exe)), $(info Please install $(exe))))

# ---------------------------
# Dependant recipes
# ---------------------------
.PHONY: create-dist
create-dist:
	$(call log_notice, "Creating distribution directory for Helm charts at: $(OUT_DIR)")
	@mkdir -p $(OUT_DIR)

