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

# #####################################
# CONFIGURATION
# #####################################

SHELL := /bin/bash


export ROOT_DIR = $(shell git rev-parse --show-toplevel)

# #####################################
# SOURCES
# #####################################
FIND_FLAGS := -mindepth 1 -maxdepth 1 -type d

CHARTS := $(shell find $(ROOT_DIR)/charts $(FIND_FLAGS))

SOURCES := $(CHARTS)

# Only export variables from here since we do not want to mix the top-level
# Makfile's notion of 'SOURCES' with the different sub-makes
export

# BUILD OUTPUT
OUT_DIR := $(ROOT_DIR)/dist
CHARTS_OUT_DIR := $(OUT_DIR)/charts


SCRIPT_DIR := $(ROOT_DIR)/scripts

DOCS_DIR := $(ROOT_DIR)/docs
GIT_CLIFF_CONFIG := $(DOCS_DIR)/cliff.toml

DATE := $(shell date '+%d.%m.%y-%T')

# #####################################
# GENERAL VARIABLES
# #####################################
PRINT_HELP ?=
WHAT ?=

# #####################################
# CUSTOM FUNCTIONS
# #####################################

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


# #####################################
# TARGETS
# #####################################

# make / make all - Build code
define ALL_HELP_INFO
# Build all or some Helm charts.
#
# Arguments:
#   WHAT: The chart names to build. Directly analogous to the directory names
# 	in the charts directory.
endef
.PHONY: all
ifeq ($(PRINT_HELP),1)
all:
	echo "$$ALL_HELP_INFO"
else
all: create-dist
	$(call log_notice, "Building artifact for: $(WHAT)")
	$(MAKE) -C $(WHAT) build
	$(call log_success, "Built artifact for $(WHAT)!")
endif

# make test - Test code
define TEST_HELP_INFO
# Test all or some Ansible collections/roles.
#
# Arguments:
#   WHAT: ...
#   TESTS: ...
endef
.PHONY: test
ifeq ($(PRINT_HELP),1)
test:
	echo "$$TEST_HELP_INFO"
else
test:
	$(call log_notice, "Testing $(WHAT)")
	$(MAKE) -C $(WHAT) test
	$(call log_success, "Test for $(WHAT) succeeded!")
endif

# make changelog - Generate CHANGELOG documents
define CHANGELOG_HELP_INFO
# Generate CHANGELOG documents for all or some Ansible collections/roles.
#
# Arguments:
#   WHAT: ...
endef
.PHONY: changelog
ifeq ($(PRINT_HELP),1)
changelog:
	echo "$$CHANGELOG_HELP_INFO"
else
changelog:
	$(call log_notice, "Generating CHANGELOG's for: $(WHAT)")
	$(MAKE) -C $(WHAT) changelog
	$(call log_success, "CHANGELOG generation for $(WHAT) succeeded!")
endif

# make clean - Clean up after builds
.PHONY: clean
clean:
	@echo Removing temporary distribution directories..
	@rm -rf $(OUT_DIR)

# #####################################
# DEPENDANT RECIPES
# #####################################

create-dist:
ifeq (,$(findstring collections, $(WHAT)))
	$(call log_notice, "Creating distribution directory for Helm charts at: $(COLLECTIONS_OUT_DIR)")
	@mkdir -p $(CHARTS_OUT_DIR)
endif

