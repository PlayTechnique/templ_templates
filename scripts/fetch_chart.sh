#!/bin/bash -el

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SERVICE_NAME=metrics-server

mkdir "${THIS_SCRIPT_DIR}/../${SERVICE_NAME}" || true
cd "${THIS_SCRIPT_DIR}/../${SERVICE_NAME}"

CHART_VERSION=3.10.0

helm repo add ${SERVICE_NAME} https://kubernetes-sigs.github.io/metrics-server/
helm pull ${SERVICE_NAME}/metrics-server --untar --untardir ${SERVICE_NAME}-${CHART_VERSION} --version "${CHART_VERSION}"

