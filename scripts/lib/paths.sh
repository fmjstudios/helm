#!/usr/bin/env bash
#
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

  echo -n "${path%/}"
}

lib::paths::tpl() {
  base=${1} value=${2}

  printf "%s/%s" "${base}" "${value}"
}
