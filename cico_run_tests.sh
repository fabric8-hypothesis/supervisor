
#!/bin/bash

. ./cico_setup.sh

TEST_IMAGE_NAME="$(make get-test-image-name)"

. ./run_tests.sh

if [ $? -eq 0 ]
then
    echo "Building the image for supervisor"
    make fast-docker-build
else
    exit 1
fi

push_image