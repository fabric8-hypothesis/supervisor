REGISTRY?=registry.devshift.net
ORGANIZATION?=fabric8-hdd
REPOSITORY?=openshift-hdd-supervisor
NODEJS_REPO?=nodejs
DOCKERFILE?=Dockerfile
TAG?=latest
PORT?=9080

.PHONY: all docker-build fast-docker-build test get-image-name docker-build-tests fast-docker-build-tests get-image-tag get-docker-file get-test-image-name get-registry get-nodejs-repo get-repository

all: fast-docker-build

docker-build:
	docker build --no-cache -t $(REGISTRY)/$(ORGANIZATION)/$(REPOSITORY):$(TAG) --build-arg VERSION=$(NODE_VERSION) --build-arg NPM_VERSION=$(NPM_VERSION) --build-arg PORT=$(PORT) -f $(DOCKERFILE) .

docker-build-tests:
	docker build --no-cache -t $(REGISTRY)/$(ORGANIZATION)/$(REPOSITORY)-tests:$(TAG) --build-arg VERSION=$(NODE_VERSION) --build-arg NPM_VERSION=$(NPM_VERSION) --build-arg PORT=$(PORT) -f Dockerfile.tests .

fast-docker-build:
	docker build -t $(REGISTRY)/$(ORGANIZATION)/$(REPOSITORY):$(TAG) -f $(DOCKERFILE) .

fast-docker-build-tests:
	./run_tests.sh

test: fast-docker-build-tests

get-image-name:
	@echo $(REGISTRY)/$(ORGANIZATION)/$(REPOSITORY):$(TAG)

get-test-image-name:
	@echo $(REGISTRY)/$(ORGANIZATION)/$(REPOSITORY)-tests:$(TAG)

get-registry:
	@echo $(REGISTRY)

get-image-tag:
    ifdef NODE_VERSION
        ifdef NPM_VERSION
			@echo $(NODE_VERSION)_npm_$(NPM_VERSION)
        else
			@echo $(TAG)
        endif
    else
		@echo $(TAG)
    endif

get-docker-file:
	@echo $(DOCKERFILE)

get-nodejs-repo:
	@echo $(NODEJS_REPO)

get-repository:
	@echo $(REPOSITORY)