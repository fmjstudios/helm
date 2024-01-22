#!/usr/bin/env bash
#
# shellcheck disable=SC1091
# shellcheck disable=SC2162
#
# A script to automate the creation, extension and other management of CHANGELOGs.

# SOURCES
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

. "${SCRIPT_DIR}/lib/stdout.sh"
. "${SCRIPT_DIR}/lib/paths.sh"

# CONSTANTS
ROOT_DIR=$(lib::paths::root)

CONFIG_DIR="${ROOT_DIR}/config"
DOCS_DIR="${ROOT_DIR}/docs"

CHARTS_DIR="${ROOT_DIR}/charts"

# ----------------------
#  lib functions
# ----------------------
function lib::changelog::parse_version() {
  local chart=${1}
  lib::changelog::existence_check "${chart}"

  chart_dir=$(lib::paths::tpl "${CHARTS_DIR}" "${chart}")

  version=$(cat "${chart_dir}/Chart.yaml" | yq '.version')
  echo -n "${version}"
}

function lib::changelog::parse_changelog_header() {
  local chart=${1}
  lib::changelog::existence_check "${chart}"

  chart_dir=$(lib::paths::tpl "${CHARTS_DIR}" "${chart}")

  header=$(cat "${CONFIG_DIR}/changelog-sections.yaml" | yq ".${chart}.header")
  echo -n "${header}"
}

function lib::changelog::parse_changelog_footer() {
  local chart=${1}
  lib::changelog::existence_check "${chart}"

  chart_dir=$(lib::paths::tpl "${CHARTS_DIR}" "${chart}")

  footer=$(cat "${CONFIG_DIR}/changelog-sections.yaml" | yq ".${chart}.footer")
  echo -n "${footer}"
}

function lib::changelog::existence_check() {
  local chart=${1}

  if [[ ! -d $(lib::paths::tpl "${CHARTS_DIR}" "${chart}") ]]; then
    log::red "No source directory found for chart: ${chart}! Cannot create CHANGELOG."
    exit 1
  fi
}

# ----------------------
#   'help' usage function
# ----------------------
function changelog::usage() {
  echo
  echo "Usage: $(basename "${0}") <COMMAND>"
  echo
  echo "create      - Create a new CHANGELOG from the current version"
  echo "prepend     - Prepend the current CHANGELOG with new commits"
  echo "prune       - Remove a CHANGELOG"
  echo "help        - Print this usage information"
  echo
}

# ----------------------
#   'create' function
# ----------------------
function changelog::create() {
  local chart=${1}
  lib::changelog::existence_check "${chart}"

  chart_dir=$(lib::paths::tpl "${CHARTS_DIR}" "${chart}")
  version=$(lib::changelog::parse_version "${chart}")

  header=$(lib::changelog::parse_changelog_header "${chart}")
  footer=$(lib::changelog::parse_changelog_footer "${chart}")

  export GIT_CLIFF__CHANGELOG__HEADER="${header}"
  export GIT_CLIFF__CHANGELOG__FOOTER="${footer}"

  git cliff --config "${DOCS_DIR}/cliff.toml" \
    --include-path "charts/${chart}/**/*" \
    --tag "${version}" \
    --unreleased \
    --output "${chart_dir}/CHANGELOG.md"

}

# ----------------------
#   'prepend' function
# ----------------------
function changelog::prepend() {
  local chart=${1}
  lib::changelog::existence_check "${chart}"

  chart_dir=$(lib::paths::tpl "${CHARTS_DIR}" "${chart}")
  version=$(lib::changelog::parse_version "${chart}")

  header=$(lib::changelog::parse_changelog_header "${chart}")
  footer=$(lib::changelog::parse_changelog_footer "${chart}")

  export GIT_CLIFF__CHANGELOG__HEADER="${header}"
  export GIT_CLIFF__CHANGELOG__FOOTER="${footer}"

  git cliff --config "${DOCS_DIR}/cliff.toml" \
    --include-path "charts/${chart}/**/*" \
    --tag "${version}" \
    --unreleased \
    --prepend "${chart_dir}/CHANGELOG.md"
}

# ----------------------
#   'prune' function
# ----------------------
function changelog::prune() {
  local chart=${1}
  lib::changelog::existence_check "${chart}"

  chart_dir=$(lib::paths::tpl "${CHARTS_DIR}" "${chart}")
  changelog_path="${chart_dir}/CHANGELOG.md"
  if [[ ! -f "${changelog_path}" ]]; then
    log::red "CHANGELOG does not exist. Cannot prune."
    exit 1
  fi

  log::yellow "Removing ${changelog_path}!"
  rm -rf "${changelog_path}"
}

# --------------------------------
#   MAIN
# --------------------------------
function main() {
  local cmd=${1} chart=${2}

  if [[ -z ${chart} ]]; then
    log::red "No chart provided cannot continue."
    changelog::usage
    exit 1
  fi

  case "${cmd}" in
  create)
    changelog::create "${chart}"
    return $?
    ;;
  prepend)
    changelog::prepend "${chart}"
    return $?
    ;;
  prune)
    changelog::prune "${chart}"
    return $?
    ;;
  help)
    changelog::usage "${chart}"
    return $?
    ;;
  *)
    log::red "Unknown command: ${cmd}. See 'help' command for usage information:"
    changelog::usage
    return 1
    ;;
  esac
}

# ------------
# 'main' call
# ------------
main "$@"
