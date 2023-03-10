.PHONY: charts/*

ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

SUBDIRS := $(wildcard charts/*)

.PHONY: all prepare $(SUBDIRS)

# readme generator image built in `prepare`
# GENERATOR = readme-generator-for-helm
# the pre-compiled one available internally
GENERATOR_DEFAULT := readme-generator-for-helm:latest
GENERATOR ?= $(GENERATOR_DEFAULT)
GENERATOR_TAG := $(shell docker images -q $(GENERATOR))

all: $(SUBDIRS)

prepare:
	@[ -z $(GENERATOR_TAG) ] \
	&& [ $(GENERATOR) = $(GENERATOR_DEFAULT) ] \
	&& docker build --tag readme-generator-for-helm . \
	|| echo "\nUsing $(GENERATOR) with ID $(GENERATOR_TAG)"

charts/*: prepare
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
