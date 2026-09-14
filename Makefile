IMAGE      := poxenstudio/mybrowser
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
VERSION    := $(subst /,-,$(GIT_BRANCH))
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
BUILDER    := shukubuilder

.PHONY: amd64 arm64 setup-multiarch build-multiarch-local build-multiarch-push

# 仅构建 amd64 镜像到本地（单架构，调试用）
amd64:
	docker build \
		--platform linux/amd64 \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		-f Dockerfile \
		-t $(IMAGE):$(VERSION) \
		.

# 仅构建 arm64 镜像到本地（单架构，调试用）
arm64:
	docker build \
		--platform linux/arm64 \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		-f Dockerfile \
		-t $(IMAGE):arm64v8-$(VERSION) \
		.

# 初始化多架构构建环境（本机/打包机只需运行一次），不要使用snap安装的docker
setup-multiarch:
	docker run --privileged --rm tonistiigi/binfmt --install all
	docker buildx create --use --name $(BUILDER) || docker buildx use $(BUILDER)
	docker buildx inspect $(BUILDER) --bootstrap

# 仅构建多架构镜像到本地缓存（不推送），同时产出 amd64 和 arm64
build-multiarch-local:
	docker buildx build --pull --platform=linux/amd64,linux/arm64 \
		--builder $(BUILDER) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		-f Dockerfile \
		-t $(IMAGE):$(VERSION) --load .

# 构建多架构镜像并推送到registry（生成单个manifest，同时支持amd64和arm64）
build-multiarch-push:
	docker buildx build --pull --platform=linux/amd64,linux/arm64 \
		--builder $(BUILDER) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		-f Dockerfile \
		-t $(IMAGE):$(VERSION) --push .
