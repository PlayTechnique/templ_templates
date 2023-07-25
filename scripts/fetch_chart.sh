#!/bin/bash -el

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CHART_URL=
SERVICE_NAME=
CHART_VERSION=

function help() {
  echo "${0} --skaffold"
  echo "This script pulls down the ${SERVICE_NAME} helm chart."

  echo "Options:"
  echo "--skaffold [-s] - also write a template skaffold.yaml"
  echo "--help -h - displays help message"
  exit 0
}

SKAFFOLD="false"

for arg in "$@"; do
  case $arg in
    "--skaffold" | "-s") SKAFFOLD="true"; shift;;
    "--help" | "-h" ) help; shift;;
  esac
done

SKAFFOLD=<<EOS
apiVersion: skaffold/v4beta4
kind: Config
metadata:
  name: ${SERVICE_NAME}
profiles:
  - name: 
    deploy:
      helm:
        releases:
          - name: ${SERVICE_NAME}
            chartPath: helm-charts/${SERVICE_NAME}-${CHART_VERSION}
            namespace: ${SERVICE_NAME}
            setValues:

            createNamespace: true
    activation:
      - kubeContext:
EOS

mkdir "${THIS_SCRIPT_DIR}/../${SERVICE_NAME}" || true
cd "${THIS_SCRIPT_DIR}/../${SERVICE_NAME}"

helm repo add ${SERVICE_NAME} ${CHART_URL}
helm repo update
helm pull ${SERVICE_NAME}/${SERVICE_NAME} --untar --untardir ${SERVICE_NAME}-${CHART_VERSION} --version "${CHART_VERSION}"

if [[ ${WRITE_SKAFFOLD} = "true" ]]; then
  if [[ ! -f skaffold.yaml ]]; then
    echo ${SKAFFOLD} >> skaffold.yaml
  else
    echo "skaffold.yaml already exists. Cowardly refusing to write skaffold file."
    exit 1
  fi
fi
