#!/usr/bin/env bash
#
# A script to automate the creation, retrieval or editing of files required to locally test Helm charts within the
# 'kind' development cluster.

# SOURCES
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

. "${SCRIPT_DIR}/lib/stdout.sh"

# CONSTANTS
TMP_DIR=/tmp/helm-test

# ----------------------
#   'help' usage function
# ----------------------
function secrets::usage() {
  echo
  echo "Usage: $(basename "${0}") <COMMAND>"
  echo
  echo "certs       - Create a Kubernetes CA secret for cert-manager"
  echo "help        - Print this usage information"
  echo
}

# ----------------------
#   'certs' function
# ----------------------
function secrets::certs() {
  # 'mkcert' sanity check
  log::yellow "Checking if 'mkcert' is installed:"
  mkcert_executable=$(command -v mkcert)
  if [[ -z ${mkcert_executable} ]]; then
    log::red "'mkcert' utility is not installed - cannot fetch TLS certificates!"
    return 1
  else
    log::green "'mkcert' is installed. Looking for CAROOT directory."
  fi

  # 'kubectl' sanity check
  log::yellow "Checking if 'kubectl' is installed:"
  kubectl_executable=$(command -v kubectl)
  if [[ -z ${kubectl_executable} ]]; then
    log::red "'kubectl' utility is not installed - cannot create Kubernetes secrets!"
    return 1
  else
    log::green "'kubectl' is installed."
  fi

  # check if 'mkcert -install' has been run before
  mkcert_ca_root=$(mkcert -CAROOT)
  if [[ ! -d ${mkcert_ca_root} ]]; then
    log::red "'mkcert' CAROOT does not exist - please install mkcert's root CA first!"
    return 1
  else
    log::green "Found mkcert's CAROOT at ${mkcert_ca_root}. Looking for cert and cert key."
  fi

  # check if CA files exist
  ca_root_cert="${mkcert_ca_root}/rootCA.pem"
  ca_root_cert_key="${mkcert_ca_root}/rootCA-key.pem"
  if [[ ! -f ${ca_root_cert} || ! -f ${ca_root_cert_key} ]]; then
    log::red "Couldn't find CA cert and cert key - Be sure the installation completed successfully!"
    return 1
  else
    log::green "Found CA certificate and certificate key file. Creating Kubernetes secret."
  fi

  # create Kubernetes namespace & secret
  kubectl create namespace cert-manager
  kubectl create secret generic mkcert-root-ca \
    --from-file=tls.crt="${ca_root_cert}" \
    --from-file=tls.key="${ca_root_cert_key}" \
    --namespace=cert-manager

  log::green "Created CA certificate secret for cert-manager!"
}

# --------------------------------
#   MAIN
# --------------------------------
function main() {
  local cmd=${1}

  lib::secret::ensure_directories

  case "${cmd}" in
  certs)
    secrets::certs
    return $?
    ;;
  help)
    secrets::usage
    return $?
    ;;
  *)
    log::red "Unknown command: ${cmd}. See 'help' command for usage information:"
    secrets::usage
    return 1
    ;;
  esac
}

# ------------
# 'main' call
# ------------
main "$@"