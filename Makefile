.PHONY: charts/*

ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SUBDIRS := $(wildcard charts/*)

VENV_DIR := .venv
PYTHON := python3
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_DIR)/bin/pip
PRE_COMMIT := $(VENV_DIR)/bin/pre-commit

.PHONY: all prepare $(SUBDIRS) venv install-pre-commit run-pre-commit clean-venv

# readme generator image built in `prepare`
# GENERATOR = readme-generator-for-helm
# the pre-compiled one available internally
GENERATOR_DEFAULT := readme-generator-for-helm:latest
GENERATOR ?= $(GENERATOR_DEFAULT)
GENERATOR_TAG := $(shell docker images -q $(GENERATOR))

all: $(SUBDIRS) run-pre-commit

venv:
	@echo "🔧 Creating python virtual environment (if not exists)..."
	@test -d venv || python3 -m venv $(VENV_DIR)
	@echo "📥 Ensuring pip is installed in venv..."
	@$(VENV_PYTHON) -m ensurepip --upgrade
	@$(VENV_PIP) install --upgrade pip

install-pre-commit: venv
	@echo "📦 Checking for pre-commit installation..."
	@$(PRE_COMMIT) --version >/dev/null 2>&1 || \
	( \
			echo "📥 Installing pre-commit into venv..."; \
			$(VENV_PIP) install --upgrade pip; \
			$(VENV_PIP) install pre-commit; \
	)

run-pre-commit: install-pre-commit
	@echo "🚀 Running pre-commit on all files..."
	@$(PRE_COMMIT) run --all-files --verbose -c .pre-commit-config.yaml

clean-venv:
	@echo "🧹 Removing python virtual environment..."
	@rm -rf $(VENV_DIR)

prepare:
	@[ -z $(GENERATOR_TAG) ] \
	&& [ $(GENERATOR) = $(GENERATOR_DEFAULT) ] \
	&& docker build --tag readme-generator-for-helm $(ROOT)/dockerfiles/readme-generator \
	|| echo "\nUsing $(GENERATOR) with ID $(GENERATOR_TAG)"

charts/*: prepare run-pre-commit
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
