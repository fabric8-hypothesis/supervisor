#!/bin/bash

set -ex

. cico_setup.sh

build_image

IMAGE_NAME=$(make get-image-name) npm test

push_image
