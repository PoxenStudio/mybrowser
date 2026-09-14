MAGE      := poxenstudio/mybrowser
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
VERSION := $(subst /,-,$(GIT_BRANCH))
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

.PHONY: amd64 arm64

amd64:
	docker build \
		--platform linux/amd64 \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		-f Dockerfile \
		-t $(IMAGE):$(VERSION) \
		.

arm64:
	docker build \
		--platform linux/arm64 \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		-f Dockerfile.aarch64 \
		-t $(IMAGE):arm64v8-$(VERSION) \
		.
