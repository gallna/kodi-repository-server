SHELL = /bin/bash

addon_id := $(shell xmllint --xpath 'string(//addon/@id)' addon.xml)
addon_version := $(shell xmllint --xpath 'string(//addon/@version)' addon.xml)
addon_filename := $(join $(addon_id),-$(addon_version))
addon_dirname := $(addon_id)

current_version := $(addon_version)
version_minor := $(shell echo $(current_version) | perl -pe 's~.*(?:\.(\d+))$$~\1~g')
next_version := $(current_version:.$(version_minor)=.$$(($(version_minor) + 1)))

patch_id = xmllint --format addon.xml | perl -pe 's~(\<addon[^\>]*?id=)".*?"([^\>]*\>)~$$1"$(1)"$$2~'
patch_version = xmllint --format addon.xml | perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(1)"$$2~'
patch_provider = xmllint --format addon.xml | perl -pe 's~(\<addon[^\>]*?provider.name=)".*?"([^\>]*\>)~$$1"$(1)"$$2~'

NAME ?= $(addon_id)
VERSION ?= $(current_version)

addon_dirname ?= $(NAME)
addon_filename := $(join $(NAME),-$(VERSION))

# Compile the entire program. This should be the default targe
next:
	VERSION=$(next_version) $(MAKE) build $(filter-out $@,$(MAKECMDGOALS))

# Build the project
build:
	$(call patch_version,$(VERSION))

# Compile the entire program. This should be the default targe
addon.xml:
	$(call patch_version,$(VERSION))
