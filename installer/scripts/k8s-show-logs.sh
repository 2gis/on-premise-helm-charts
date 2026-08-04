#!/bin/bash
set -e

CONTEXT=${HELM_CTX:-$1}
NS=${2? "Не задан k8s namespace"}
RELEASE_NAME=${3? "Не задан release name"}
STATUS=${4? "Не задан статус завершения helmfile"}

clear="\e[0m"
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
cyan="\e[1;36m"

if [[ $STATUS == "failure" ]];then
printf "${red}Deployment errors, show not running $RELEASE_NAME pods:${clear}\n"
kubectl --context $CONTEXT -n $NS get pods --field-selector=status.phase!=Running -l "app.kubernetes.io/instance=$RELEASE_NAME"
printf "${red}Output logs from pods with error status:${clear}\n"
error_pods=$(kubectl --context $CONTEXT -n $NS get pods --field-selector=status.phase!=Running --no-headers -l "app.kubernetes.io/instance=$RELEASE_NAME" | grep -v "Completed" | awk '{print $1}')
if [ -n "${error_pods}" ]; then
  while read -r pod
  do
      printf "${yellow}$pod${clear}\n"
      kubectl --context $CONTEXT -n $NS logs $pod --all-containers=true --tail=50
  done < <(printf '%s\n' "$error_pods")
else
  printf "${yellow}No pods found with errors. Check deployment timeout.${clear}\n"
fi

printf "${red}Last line of log output.${clear}\n"
fi
