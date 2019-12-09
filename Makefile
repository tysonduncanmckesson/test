# Project configuration
PROJECT = sample-k8s

# General.
SHELL = /bin/bash
TAG ?= $(shell git describe --always)

# Docker.
REGISTRY = gcr.io
ORGANIZATION = adp-01-prod-673a
REPOSITORY = $(ORGANIZATION)/$(PROJECT)
IMAGE = $(REPOSITORY):$(TAG)

# Helm
DEPLOY_EXTRA_OPTS = "--set image.tag=$(TAG)"

default: all

help: # Display help
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST) | sort

## General targets -- Local development
all: install ## Build and install everything

clean: ## Clean local and
	./gradlew clean

init: ## Initialized the local development environment
	@echo "Nothing to do"

test: ## Test
	./gradlew test

dist: ## Build the artifact locally
	./gradlew build -x test

install: docker-build docker-install-local # Default install

uninstall: docker-uninstall-local ## Default uninstall

## Common docker targets
docker: docker-push docker-tag docker-push ## Build, tag, and push docker image

docker-build: ## Build docker image
	docker build -t $(IMAGE) .
	$(MAKE) docker-tag

docker-push: ## Push docker image
	docker push $(REGISTRY)/$(IMAGE)

docker-tag: ## Tag docker image
	docker tag $(IMAGE) $(REGISTRY)/$(IMAGE)

docker-clean: ## Clean docker images
	docker image rm -f $(shell docker image ls --filter reference='$(REPOSITORY)' -q) || true

## Common docker install targets
docker-install: docker-install-local ## Default k8s install

docker-install-local: ## Install in k8s on docker-desktop
	kubectl config use-context "docker-desktop"
	kubectl apply -f k8s/

docker-uninstall-local: ## Uninstall in k8s on docker-desktop
	kubectl config use-context "docker-desktop"
	kubectl delete -f k8s/

docker-install-nonprod: ## Install in k8s on the non-production environment
docker-uninstall-nonprod: ## Uninstall in k8s on the non-production-environment

.PHONY: all clean dist docker docker-build docker-clean docker-install docker-install-local docker-install-nonprod docker-push docker-tag docker-uninstall-local docker-uninstall-nonprod init test uninstall

