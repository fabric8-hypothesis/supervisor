#!/bin/bash

. constants.sh
. cico_setup.sh

load_jenkins_vars

TEMP=$(date +%s)

if [ -z $TAG ]
then
TAG=$TEMP
fi

set -ex

push_registry=$(make get-registry)
# login first
if [ -n "${DEVSHIFT_USERNAME}" -a -n "${DEVSHIFT_PASSWORD}" ]; then
    docker login -u ${DEVSHIFT_USERNAME} -p ${DEVSHIFT_PASSWORD} ${push_registry}
else
    echo "Could not login, missing credentials for the registry"
    exit 1
fi

for version in "${VERSIONS[@]}" ; do
    IFS=: read node_version npm_version <<< $version
    tag="$(make NODE_VERSION=${node_version} NPM_VERSION=${npm_version} get-image-tag)"
    TEST_IMAGE_NAME="$(make TAG=$tag get-test-image-name)"     
    docker build -t $TEST_IMAGE_NAME -f Dockerfile.tests --build-arg CACHEBUST=$TEMP --build-arg VERSION=${node_version} --build-arg NPM_VERSION=${npm_version} --build-arg OS_NAME=fedora --build-arg OS_VERSION=25 .
    tag_push ${TEST_IMAGE_NAME} ${TEST_IMAGE_NAME}
done

tag="$(make get-image-tag)"
TEST_IMAGE_NAME="$(make TAG=$tag get-test-image-name)"     
docker build -t $TEST_IMAGE_NAME -f Dockerfile.tests --build-arg CACHEBUST=$TEMP --build-arg VERSION=${node_version} --build-arg NPM_VERSION=${npm_version} --build-arg OS_NAME=fedora --build-arg OS_VERSION=25 .
tag_push ${TEST_IMAGE_NAME} ${TEST_IMAGE_NAME}

set +x

if [ $? -eq 0 ]
then
    echo "Test suite passed. \\o/"
    echo "Purging the recently build supervisor-test image..."
    docker rmi $TEST_IMAGE_NAME
else
    echo "Tests failing."
    exit 1
fi

set +e

#Running the Docker infra test

dock_ver="$(docker info|grep "Server Version"|cut -d':' -f 2 | xargs)"
required_dock_ver="17.08.0"
if [ $(expr ${dock_ver} \>= ${required_dock_ver}) == 1 ]; then
    echo "Required version of docker is installed"
else 
    echo "Docker version test failed"
fi

#Running the OC infra test

oc_ver="$(oc version | grep -i 'oc' | cut -d' ' -f 2)"
required_oc_ver="3.6.0+c4dd4cf"
if [ $(expr ${oc_ver//v} \== ${required_oc_ver}) == 1 ]; then
    echo "Required version of openshift is installed"
else 
    echo "Openshift version test failed"
fi