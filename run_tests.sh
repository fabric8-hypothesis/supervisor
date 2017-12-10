#!/bin/bash

set -ex

TEMP=$(date +%s)

docker build -t supervisor-tests:$TEMP -f Dockerfile.tests --build-arg CACHEBUST=$TEMP .

echo "Removing the supervisor-tests:$TEMP image..."
docker rmi supervisor-tests:$TEMP

set +x

if [ $? -eq 0 ]
then
    echo "Docker image deleted successfully."
else
    echo "Error occured while deleting the docker image."
    exit 1
fi

set +e