#!/bin/bash

TEMP=$(date +%s)

if [ -z $TAG ]
then
TAG=$TEMP
fi

if [ -z $TEST_IMAGE_NAME ]
then
TEST_IMAGE_NAME="$(make get-test-image-name)"
fi

set -ex

docker build -t $TEST_IMAGE_NAME -f Dockerfile.tests --build-arg CACHEBUST=$TEMP .

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