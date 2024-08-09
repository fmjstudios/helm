#!/usr/bin/env bash

CHART_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC2002
APP_VERSION="$(cat "${CHART_DIR}/Chart.yaml" | yq .appVersion)"

KEYCLOAK_CRD_BASE_URL="https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${APP_VERSION}/kubernetes/keycloaks.k8s.keycloak.org-v1.yml"
KEYCLOAKREALMIMPORTS_BASE_URL="https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${APP_VERSION}/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml"

DOWNLOADS=(
  "$KEYCLOAK_CRD_BASE_URL"
  "$KEYCLOAKREALMIMPORTS_BASE_URL"
)

for download in "${DOWNLOADS[@]}"; do
  output=$(basename -- "${download}")
  curl -LJ "${download}" -o "${CHART_DIR}/crds/${output}" -s
done

echo "Downloaded CRDs for Keycloak Operator version ${APP_VERSION}"