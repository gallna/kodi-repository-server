SHELL = /bin/bash

current_version := $(shell xmllint --xpath 'string(//addon/@version)' addon.xml)
next_version := $(shell echo $(current_version) | awk 'BEGIN{FS=OFS="."}{$$NF=($$NF + 1); print}')
VERSION ?= $(next_version)

.PHONY: all clean build version test

# Compile the entire program. This should be the default targe
all: clean build version test

build:

# Patch project version
version:
	@echo "versions: current: $(current_version) next:$(next_version)"
	$(file >addon.xml,$(shell xmllint --format addon.xml |\
		perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(VERSION)"$$2~'))

# Delete all files that war created by running make.
clean:
