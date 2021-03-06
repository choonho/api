TARGET = core identity repository plugin secret inventory monitoring statistics config
VERSION = v1
DOCKER_NAME = spaceone/api_builder

.PHONY: help
.PHONY: all python doc
.PHONY: clean

define banner
	@echo "========================================================================"
	@echo " $(1)"
	@echo "========================================================================"
endef

define set_build_env
	git submodule init
	git submodule update
	docker build -t ${DOCKER_NAME} .
endef

define build
	$(call set_build_env)
	$(call banner, "Start the build protobuf")
	@for t in $(TARGET); do \
		docker run -i --rm -v ${PWD}:/opt ${DOCKER_NAME} python3 build.py $$t -c$(1) ; \
	done
endef

help:
	@echo "Make Options:"
	@echo " all                 - Generate all : ${TARGET}"
	@echo " python              - Generate python protobuf"
	@echo " doc                 - Generate API document"
	@echo " clean               - Clean up dist directory"

all:
	$(call banner, "Generate all : ${TARGET}")
	$(call build, "all")

doc:
	$(call banner, "Generate API document")
	$(call build, "doc")

python:
	$(call banner, "Generate python protobuf")
	$(call build, "python")

clean:
	$(call banner, "Clean up dist directory")
	sudo rm -rf dist
