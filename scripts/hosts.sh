#!/usr/bin/env bash
#
# Configure the current Linux machine with custom hostnames for localhost in order to get the correct routing
# in staging and development environments.

# Libraries
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

. "${SCRIPT_DIR}/lib/helpers.sh"
. "${SCRIPT_DIR}/lib/paths.sh"
. "${SCRIPT_DIR}/lib/permissions.sh"
. "${SCRIPT_DIR}/lib/stdout.sh"

# Constants
HOST_CONFIG="/etc/hosts"

CONFIG_START="# HELM MANAGED START"
CONFIG_END="# HELM MANAGED END"

CONFIG=$(
  cat <<EOF

${CONFIG_START}
# This file is managed by FMJdev's Helm - do not modify!

# fmjstudios/helm - FMJ Studios Helm Charts
127.0.0.1               linkwarden.helm.private         # Linkwarden
127.0.0.1               vaultwarden.helm.private        # Vaultwarden
127.0.0.1               uptime-kuma.helm.private        # Uptime-Kuma
127.0.0.1               paperless.helm.private          # Paperless-NGX
127.0.0.1               gotenberg.helm.private          # Gotenberg
127.0.0.1               linkstack.helm.private          # Linkstack
127.0.0.1               ntfy.helm.private               # ntfy
127.0.0.1               cachet.helm.private             # Cachet

${CONFIG_END}
EOF
)
# ----------------------
#   'help' usage function
# ----------------------
function hosts::usage() {
  echo
  echo "Usage: $(basename "${0}") <COMMAND>"
  echo
  echo "add     - Insert the new configuration in ${HOST_CONFIG}"
  echo "remove  - Remove the configuration from ${HOST_CONFIG}"
  echo "help    - Print this usage information"
  echo
}

# ----------------------
#   'add' function
# ----------------------
function hosts::add() {
  log::yellow "Adding custom host configuration to ${HOST_CONFIG}"
  read -rp "Are you sure you want to modify the system host file ${HOST_CONFIG}? (y/N) " choice
  case "${choice}" in
  y | Y)
    log::green "Confirmed modification to ${HOST_CONFIG}. Installing..."
    echo "$CONFIG" | lib::permissions::run_as_root tee -a "${HOST_CONFIG}" >/dev/null
    ;;
  *)
    log::yellow "Cancelled modification to ${HOST_CONFIG}. No changes made."
    return 1
    ;;
  esac
}

# ----------------------
#   'remove' function
# ----------------------
function hosts::remove() {
  log::yellow "Removing custom host configuration from ${HOST_CONFIG}"
  read -rp "Are you sure you want to modify the system host file ${HOST_CONFIG}? (y/N) " choice
  case "${choice}" in
  y | Y)
    log::green "Confirmed modification to ${HOST_CONFIG}. Removing..."
    lib::permissions::run_as_root sed -i "/${CONFIG_START}/,/${CONFIG_END}/d" ${HOST_CONFIG}
    ;;
  *)
    log::yellow "Cancelled modification to ${HOST_CONFIG}. No changes made."
    return 1
    ;;
  esac
}

# --------------------------------
#   MAIN
# --------------------------------
function main() {
  local cmd=${1}

  case "${cmd}" in
  add)
    hosts::add
    return $?
    ;;
  remove)
    hosts::remove
    return $?
    ;;
  *)
    log::red "Unknown command: ${cmd}. See 'help' command for usage information:"
    hosts::usage
    return 1
    ;;
  esac
}

# ------------
# 'main' call
# ------------
main "$@"
