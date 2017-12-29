#!/usr/bin/bash -e

set -x
oc whoami
oc project
set +x

function oc_process_apply() {
  echo -e "\n Processing template - $1 ($2)\n"
  if [ -z $2 ]
  then
    oc process -f $1 | oc apply -f -
  else
    oc process -f $1 --param-file=$2 | oc apply -f -
  fi
}

here=`dirname $0`
template="${here}/template.yaml"
envfile="${here}/supervisor.env"


if [ -z $(grep "SUPERVISOR_PORT" $envfile | cut -d'=' -f 2) ];
then
  echo "PORT parameter will be default"
  oc_process_apply "$template"
else
  echo "PORT parameter would be overriden"
  oc_process_apply "$template" "$envfile"
fi