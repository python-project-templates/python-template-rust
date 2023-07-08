.DEFAULT_GOAL := help
.PHONY: help
# Thanks to Francoise at marmelab.com for this
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	_CP_COMMAND := cp target/debug/librust_template.dylib rust_template/rust_template.abi3.so
else
	_CP_COMMAND := cp target/debug/librust_template.so rust_template/rust_template.abi3.so
endif

.PHONY: develop-py develop-rust develop
develop-py:
	pip install -U build maturin setuptools twine wheel
	pip install -e .[develop]

develop-rust:
	make -C rust develop

develop: develop-rust develop-py  ## Setup project for development

.PHONY: build-py build-rust build
build-py:
	maturin build

build-rust:
	make -C rust build

build-sdist:  ## Build the python sdist
	python -m build --sdist -o wheelhouse

dev: build  ## Lightweight in-place build for iterative dev
	$(_CP_COMMAND)

build: build-rust build-py  ## Build the project

.PHONY: lint-py lint-rust lint
lint-py:
	python -m ruff rust_template

lint-rust:
	make -C rust lint

lint: lint-rust lint-py  ## Run project linters

.PHONY: fix-py fix-rust fix
fix-py:
	python -m ruff rust_template --fix

fix-rust:
	make -C rust fix

fix: fix-rust fix-py  ## Run project autofixers

.PHONY: tests-py tests-rust tests test tests-ci
tests-py:
	python -m pytest -v rust_template/tests --junitxml=junit.xml --cov=rust_template --cov-branch --cov-fail-under=65 --cov-report term-missing --cov-report xml

tests-rust:
	make -C rust tests

tests: tests-rust tests-py  ## Run the tests
test: tests

tests-ci-rust:
	make -C rust tests-ci

tests-ci: tests-ci-rust tests-py

.PHONY: dist publish
dist: build  ## Create python dists
	python -m twine check target/wheels/*
	make -C rust dist

publish: dist  ## Dist assets to pypi
	python -m twine upload target/wheels/* --skip-existing
	make -C rust publish

clean:  ## Clean the repo
	git clean -fdx
