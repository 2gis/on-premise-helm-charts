.PHONY: charts/*

ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

SUBDIRS := $(wildcard charts/*)

.PHONY: all prepare $(SUBDIRS)

# readme generator image built in `prepare`
# GENERATOR = readme-generator-for-helm
# the pre-compiled one available internally
GENERATOR = docker-hub.2gis.ru/on-premise/readme-generator-for-helm

all: $(SUBDIRS)

prepare:
	docker build --tag readme-generator-for-helm .

charts/*:
	@echo ""
	@echo "Building README for $@..."
	@docker run --rm -it \
		--user $$(id -u):$$(id -g) \
		--volume $(ROOT)/bitnami-config.json:/config.json:ro \
		--volume $(ROOT)/$@/values.yaml:/values.yaml:ro \
		--volume $(ROOT)/$@/README.md:/README.md:rw \
		$(GENERATOR) \
		readme-generator --config=/config.json --values=/values.yaml --readme=/README.md
	@echo ""
