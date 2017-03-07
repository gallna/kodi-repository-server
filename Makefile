SHELL = /bin/bash

addon_id = $(shell xmllint --xpath 'string(//addon/@id)' addons/$(1)/addon.xml)
addon_version = $(shell xmllint --xpath 'string(//addon/@version)' addons/$(1)/addon.xml)
next_version = $(shell xmllint --xpath 'string(//addon/@version)' ./addons/$(1)/addon.xml | awk 'BEGIN{FS=OFS="."}{$$NF=($$NF + 1); print}')

ifdef NAME
ADDONID ?= $(call addon_id,$(NAME))
VERSION ?= $(call addon_version,$(NAME))
endif


addons = $(shell dirname addons/**/addon.xml)
objects := $(shell basename -a $(addons))
addon_filename ?= $(join $(NAME),-$(VERSION))
addon_dirname ?= $(NAME)

.DEFAULT_GOAL := build

zplugin.video.fanfilm:


zrepository.wrrr.online:

zscript.module.youtube.dl:

zscript.module.addon.signals:



# Build the project and create docker container

.PHONY: $(objects) all

# Compile the entire program. This should be the default targe
all:
	@echo $(objects) $(VERSION) $(NAME)

subdirs: $(objects)

$(objects):
ifeq ($(NAME),)
	NAME=$@ $(MAKE) $@
else
	mkdir -p html/$(NAME)/
	NAME=$@ VERSION=$(VERSION) $(MAKE) -C build all
	mv build/*.zip html/$(NAME)/
	mv build/*.md5 html/$(NAME)/
	mv build/addons.* html/
	$(MAKE) -C build clean
endif

addons.xml.md5: addons.xml
	md5sum html/addons.xml > html/addons.xml.md5

addons.xml:
	$(file >html/addon.xml,$(strip $(archives)))

archives = $(shell for dir in html/*/.; do printf "%s\n\n" $$dir/*.zip | sort | tail -1; done)

define addons_xml =
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
	$(shell for zip in $(archives); do unzip -p $$zip '*/addon.xml' | xmllint --c14n11 -; done)
</addons>
endef
