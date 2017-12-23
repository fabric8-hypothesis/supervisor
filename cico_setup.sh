#!/bin/bash -ex

. version.sh

load_jenkins_vars() {
    if [ -e "jenkins-env" ]; then
        cat jenkins-env \
          | grep -E "(DEVSHIFT_TAG_LEN|DEVSHIFT_USERNAME|DEVSHIFT_PASSWORD|JENKINS_URL|GIT_BRANCH|GIT_COMMIT|BUILD_NUMBER|ghprbSourceBranch|ghprbActualCommit|BUILD_URL|ghprbPullId)=" \
          | sed 's/^/export /g' \
          > ~/.jenkins-env
        source ~/.jenkins-env
    fi
}

prep_node_base_image() {
    local image_name
    local default_tag
    local full_image_name
    push_registry=$(make get-registry)
    # login first
    if [ -n "${DEVSHIFT_USERNAME}" -a -n "${DEVSHIFT_PASSWORD}" ]; then
        docker login -u ${DEVSHIFT_USERNAME} -p ${DEVSHIFT_PASSWORD} ${push_registry}
    else
        echo "Could not login, missing credentials for the registry"
        exit 1
    fi
    default_tag=$(make get-image-tag)
    for version in "${VERSIONS[@]}" ; do
        IFS=: read node_version npm_version <<< $version
        image_name=$(make REPOSITORY="nodejs" TAG=${node_version}_npm_${npm_version} get-image-name)
        build_image ${node_version}_npm_${npm_version} Dockerfile.nodejs ${node_version} ${npm_version} $(make get-nodejs-repo)
        tag_push ${image_name} ${image_name}
    done
    build_image ${default_tag} Dockerfile.nodejs ${node_version} ${npm_version} $(make get-nodejs-repo)
    image_name=$(make REPOSITORY="nodejs" get-image-name)
    tag_push ${image_name} ${image_name}
}

prep() {
    yum -y update
    curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
    yum -y install yum-utils device-mapper-persistent-data lvm2 git nodejs
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum -y install docker-ce
    systemctl start docker
}

test_image() {
    make TAG=${1:-latest} NODE_VERSION=$2 NPM_VERSION=$3 docker-build-tests
}

build_image() {
    make TAG=$1 DOCKERFILE=$2 NODE_VERSION=$3 NPM_VERSION=$4 REPOSITORY=$5 docker-build
}

tag_push() {
    local target=$1
    local source=$2
    docker tag ${source} ${target}
    docker push ${target}

    if [ $? -eq 0 ]; then
         echo "CICO: Image ${target} pushed, ready to update deployed app"
    else
        echo "ERROR OCCURED WHILE PUSHING THE IMAGE"
    fi
}

push_images() {
    local TAG
    local image_name
    local push_registry
    # Remember last UT pass node and npm versions for tagging the corresponding image as latest
    local latest_node_version
    local latest_npm_version
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
        # Test image
        TAG=$(make NODE_VERSION=${node_version} NPM_VERSION=${npm_version} get-image-tag)
        image_name=$(make TAG=${TAG} get-image-name)
        test_image ${TAG} ${node_version} ${npm_version}
        # If tests passed only then build, tag and push main image
        if [ $? -eq 0 ]; then
            build_image ${TAG} $(make get-docker-file) ${node_version} ${npm_version} $(make get-repository)
            latest_node_version=$node_version
            latest_npm_version=$npm_version
            tag_push ${image_name} ${image_name}
        else
            echo "Tests failed for tag ${TAG}"
        fi
    done
    # Tag last successful UT pass node and npm versions as latest
    TAG=$(make get-image-tag)
    image_name=$(make TAG=${TAG} get-image-name)
    build_image ${TAG} $(make get-docker-file) ${latest_node_version} ${latest_npm_version} $(make get-repository)
    tag_push ${image_name} ${image_name}
}

load_jenkins_vars
prep
prep_node_base_image
