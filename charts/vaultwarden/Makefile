include ../../Makefile

# #####################################
# CONFIGURATION
# #####################################

HELM := helm
GIT_CLIFF := git cliff

FIND_FLAGS := -mindepth 1
SOURCES := $(shell find $(CURDIR) $(FIND_FLAGS))

# Version information to be used to find artifacts created by this sub-make and
# for CHANGELOG generation - see target 'changelog'
VERSION := $(shell cat Chart.yaml | yq '.version')

# Artifact reference to manage the files created by this sub-make
ARTIFACT_NAME := $(shell dirname $(CURDIR))
ARTIFACT := fmjstudios-$(ARTIFACT_NAME)-$(VERSION).tar.gz
ARTIFACT_PATH := $(CHARTS_OUT_DIR)/$(ARTIFACT)

# #####################################
# CHANGELOG'S
# #####################################

# Define a custom CHANGELOG header to use with 'git cliff' since we wouldn't want
# repository-level information ending up in the specific collection CHANGELOG
define CHANGELOG_HEADER 
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Ansible_logo.svg/195px-Ansible_logo.svg.png" alt="Ansible Logo" align="right" height="240" width="195"/>

# Ansible Collection: Containers - CHANGELOG\n
\n
endef

# Define a custom CHANGELOG footer to use with 'git cliff' since we wouldn't want
# repository-level information ending up in the specific collection CHANGELOG
define CHANGELOG_FOOTER 
---

* **Namespace**: `fmjstudios`
* **Collection**: `containers`
* **Source**: [](https://github.com/fmjstudios/ansible/tree/main/collections/containers)
* **License**: GPL 2.0
* **Author**: FMJ Studios

<div align="center">

  **[fmj.studio](https://fmj.studio)**

</div>
endef

# #####################################
# TARGETS
# #####################################

# 'build' builds the collection artifact with 'ansible-galaxy' and stores it in
# in the top-level 'dist/collections' directory for organization. see the above
# variable 'ARTIFACT' for naming reference
.PHONY: build
build: clean
	@$(HELM) package $(CURDIR) --destination=$(CHARTS_OUT_DIR)

# 'test' runs Ansible Molecule to test the collection for correctness, idempotence
# and verifying each different support configuration supported by the collection or
# the roles contained - see the molecule/default folder for more information
.PHONY: test
test:
	@echo TESTING (set up Helm chart tests..)


# 'clean' removes a possibly pre-existing artifact from the distribution directory
.PHONY: clean
clean:
	@echo Removing artifact $(ARTIFACT) if it exists..
	@rm -rf $(ARTIFACT_PATH)

# 'changelog' either creates a brand-new CHANGELOG document or prepends an
# existing one using 'git cliff'. overrides are handled via the defines above
# while the main configuration resides in 'docs/cliff.toml' from the repo root
.PHONY: CHANGELOG
.ONESHELL:
changelog:
	@export GIT_CLIFF__CHANGELOG__HEADER="$$CHANGELOG_HEADER"
	@export GIT_CLIFF__CHANGELOG__FOOTER="$$CHANGELOG_FOOTER"
	[[ -f $(CURDIR)/CHANGELOG.md ]] && \
		git cliff --config $(GIT_CLIFF_CONFIG) --unreleased \
		--tag $(VERSION) --include-path="$(SOURCES)" --output CHANGELOG.md \
		--repository $(ROOT_DIR) \
		|| \
		git cliff --config $(GIT_CLIFF_CONFIG) --unreleased \
		--tag $(VERSION) --include-path="$(SOURCES)" --prepend CHANGELOG.md \
		--repository $(ROOT_DIR) 