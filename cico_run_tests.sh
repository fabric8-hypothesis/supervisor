
#!/bin/bash

. cico_setup.sh

TAG="test"
TEST_IMAGE_NAME="$(make get-image-name):$TAG"

./run_tests.sh

if [ $? -eq 0 ]
then
    echo "Building the image for supervisor"
    make fast-docker-build
else
    exit 1
fi

push_image