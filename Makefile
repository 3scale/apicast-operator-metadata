MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))
OPERATORCOURIER := $(shell command -v operator-courier 2> /dev/null)

.DEFAULT_GOAL := help
.PHONY : help
help: Makefile
	@sed -n 's/^##//p' $<

## verify-manifest: Test manifests have expected format
verify-manifest:
ifndef OPERATORCOURIER
	$(error "operator-courier is not available please install pip3 install operator-courier")
endif
	rm -rf $(PROJECT_PATH)/.bundle || true
	mkdir -p $(PROJECT_PATH)/.bundle
	operator-courier --verbose flatten manifests/ $(PROJECT_PATH)/.bundle
	operator-courier --verbose verify --ui_validate_io $(PROJECT_PATH)/.bundle
