SHELL = /bin/bash

addon_id = $(shell xmllint --xpath 'string(//addon/@id)' addons/$(1)/addon.xml)
addon_version = $(shell xmllint --xpath 'string(//addon/@version)' addons/$(1)/addon.xml)
next_version = $(shell xmllint --xpath 'string(//addon/@version)' ./addons/$(1)/addon.xml | awk 'BEGIN{FS=OFS="."}{$$NF=($$NF + 1); print}')

ifdef NAME
ID ?= $(call addon_id,$(NAME))
VERSION ?= $(call addon_version,$(NAME))
endif

addon_filename ?= $(join $(ID),-$(VERSION))
addon_dirname ?= $(ID)

addons = $(shell dirname addons/**/addon.xml)
objects := $(shell basename -a $(addons))

.PHONY: $(objects) subdirs

subdirs: $(objects)

wrrr:
	test -e $(CURDIR)/wrrr || ln -s ~/mnt/wrrr $(CURDIR)/wrrr

push: wrrr
	test -d  $(CURDIR)/wrrr/kodi/html && cp --recursive --update $(CURDIR)/html/* $(CURDIR)/wrrr/kodi/html

$(objects):
ifeq ($(NAME),)
	NAME=$@ $(MAKE) $@
else
	test -d addons/$@/ || $(MAKE) -C addons $@
	NAME=$@ VERSION=$(VERSION) $(MAKE) -C build all
	mkdir -p html/$(addon_dirname)/
	mv build/*.zip html/$(addon_dirname)/
	mv build/*.md5 html/$(addon_dirname)/
	$(MAKE) -C build clean
endif

addons.xml.md5: addons.xml
	md5sum html/addons.xml > html/addons.xml.md5

addons.xml:
	$(file >html/addons.xml,$(addons_xml))

archives = $(shell for dir in html/*/.; do printf "%s\n\n" $$dir/*.zip | sort | tail -1; done)

define addons_xml =
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
	$(shell for zip in $(archives); do unzip -p $$zip '*/addon.xml' | xmllint --c14n11 -; done)
</addons>
endef
