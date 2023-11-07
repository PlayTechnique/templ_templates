#!/bin/bash -el

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CHART_URL=
REPO_NAME=
CHART_NAME=
CHART_VERSION=

function help() {
  echo "${0} --skaffold"
  echo "This script pulls down the ${REPO_NAME}/${CHART_NAME} helm chart."

  echo "Options:"
  echo "--skaffold [-s] - also write a template skaffold.yaml"
  echo "--help -h - displays help message"
  exit 0
}

WRITE_SKAFFOLD="false"
UNTAR_DESTINATION="${CHART_NAME}-${CHART_VERSION}"


for arg in "$@"; do
  case $arg in
    "--skaffold" | "-s") WRITE_SKAFFOLD="true"; shift;;
    "--help" | "-h" ) help; shift;;
  esac
done

SKAFFOLD=$(cat <<EOS
apiVersion: skaffold/v4beta4
kind: Config
metadata:
  name: ${REPO_NAME}
profiles:
  - name: 
    deploy:
      helm:
        releases:
          - name: ${REPO_NAME}
            chartPath: helm-charts/${UNTAR_DESTINATION}/${CHART_NAME}
            namespace: ${REPO_NAME}
            setValues:

            createNamespace: true
    activation:
      - kubeContext:
EOS
)

mkdir "${THIS_SCRIPT_DIR}/../helm-charts" || true
cd "${THIS_SCRIPT_DIR}/../helm-charts"

helm repo add ${REPO_NAME} ${CHART_URL}
helm repo update

if [[ -d "${UNTAR_DESTINATION}" ]]; then
  echo "${UNTAR_DESTINATION} exists. No need to pull chart"
else
  helm pull ${REPO_NAME}/${CHART_NAME} --untar --untardir ${UNTAR_DESTINATION} --version "${CHART_VERSION}"
fi

if [[ ${WRITE_SKAFFOLD} = "true" ]]; then
  if [[ ! -f skaffold.yaml ]]; then
    echo "${SKAFFOLD}" >> skaffold.yaml
  else
    echo "skaffold.yaml already exists. Cowardly refusing to write skaffold file."
    exit 1
  fi
fi
