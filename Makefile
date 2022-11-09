.PHONY: charts/*

ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# readme generator image
#GENERATOR = readme-generator-for-helm
# the pre-compiled one available internally
GENERATOR = docker-hub.2gis.ru/on-premise/readme-generator-for-helm

all:
	@echo 'Building README for catalog-api...'        && make charts/catalog-api        && echo
	@echo 'Building README for gis-platform...'       && make charts/gis-platform       && echo
	@echo 'Building README for keys...'               && make charts/keys               && echo
	@echo 'Building README for mapgl-js-api...'       && make charts/mapgl-js-api       && echo
	@echo 'Building README for navi-async-matrix...'  && make charts/navi-async-matrix  && echo
	@echo 'Building README for navi-back...'          && make charts/navi-back          && echo
	@echo 'Building README for navi-castle...'        && make charts/navi-castle        && echo
	@echo 'Building README for navi-front...'         && make charts/navi-front         && echo
	@echo 'Building README for navi-restrictions...'  && make charts/navi-restrictions  && echo
	@echo 'Building README for navi-router...'        && make charts/navi-router        && echo
	@echo 'Building README for search-api...'         && make charts/search-api         && echo
	@echo 'Building README for stat-receiver...'      && make charts/stat-receiver      && echo
	@echo 'Building README for tiles-api...'          && make charts/tiles-api          && echo
	@echo 'Building README for traffic-proxy'         && make charts/traffic-proxy      && echo

prepare:
	docker build --tag readme-generator-for-helm .

charts/*:
	@docker run --rm -it \
		--user $$(id -u):$$(id -g) \
		--volume $(ROOT)/bitnami-config.json:/config.json:ro \
		--volume $(ROOT)/$@/values.yaml:/values.yaml:ro \
		--volume $(ROOT)/$@/README.md:/README.md:rw \
		$(GENERATOR) \
		readme-generator --config=/config.json --values=/values.yaml --readme=/README.md
