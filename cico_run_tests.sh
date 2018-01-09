
#!/bin/bash

TEST_IMAGE_NAME="$(make get-test-image-name)"

. run_tests.sh

run_tests