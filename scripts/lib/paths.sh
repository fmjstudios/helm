# shellcheck shell=bash

# BASH functions to obtain correct paths.

#######################################
# Determine the repository's paths.
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   The given filesystem path.
#######################################

# Return the repository's root path
lib::paths::root() {
	path=$(git rev-parse --show-toplevel)

	echo "${path%/}"
}

# Return the secrets path
lib::paths::secrets() {
	root_path=$(lib::paths::root)

	path="${root_path}/secrets"
	echo "${path%/}"
}

# Return the k8s path
lib::paths::k8s() {
	root_path=$(lib::paths::root)

	path="${root_path}/k8s"
	echo "${path%/}"
}
