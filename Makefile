.PHONY: charts/*

ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

prepare:
	docker build --tag readme-generator-for-helm .

charts/*:
	@docker run --rm -it \
		--user $$(id -u):$$(id -g) \
		--volume $(ROOT)/bitnami-config.json:/config.json:ro \
		--volume $(ROOT)/$@/values.yaml:/values.yaml:ro \
		--volume $(ROOT)/$@/README.md:/README.md:rw \
		readme-generator-for-helm \
		readme-generator --config=/config.json --values=/values.yaml --readme=/README.md
