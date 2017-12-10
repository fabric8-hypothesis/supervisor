REGISTRY?=registry.centos.org
REPOSITORY?=fabric8-hdd/openshift-hdd-supervisor
DEFAULT_TAG=1.0.0

.PHONY: all docker-build fast-docker-build test get-image-name get-image-repository docker-build-tests fast-docker-build-tests

all: fast-docker-build

docker-build:
	docker build --no-cache -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) .

docker-build-tests: docker-build
	docker build --no-cache -t supervisor-tests -f Dockerfile.tests .

fast-docker-build:
	docker build -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) .

fast-docker-build-tests: fast-docker-build
	docker build -t supervisor-tests -f Dockerfile.tests .

test: fast-docker-build-tests

get-image-name:
	@echo $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG)

get-image-repository:
	@echo $(REPOSITORY)
