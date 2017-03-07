SHELL = /bin/bash

addon_id = $(shell xmllint --xpath 'string(//addon/@id)' $(1)/addon.xml)
addon_version = $(shell xmllint --xpath 'string(//addon/@version)' $(1)/addon.xml)

ifdef NAME
ADDONID ?= $(call addon_id,$(NAME))
VERSION ?= $(call addon_version,$(NAME))
endif

addon_dirname ?= $(NAME)
addon_filename ?= $(join $(NAME),-$(VERSION))

addons = $(shell dirname ../addons/**/addon.xml)
objects := $(shell basename -a $(addons))

.PHONY: all clean $(objects) %.zip %.zip.md5 %/addon.xml addons.xml addons.xml.md5

# Compile the entire program. This should be the default targe
all: addon.xml $(NAME).zip.md5 addons.xml

clean:
	rm -rf $(dir */*)
	rm -f *.zip *md5 *xml

$(objects):
	cp -R  $(realpath ../addons/$@) $(addon_dirname)

%.zip: %
	zip -q -r $(addon_filename).zip $(addon_dirname)

%.zip.md5: %.zip
	md5sum $(addon_filename).zip > $(addon_filename).zip.md5

addon_version=$(shell xmllint --format $(NAME)/addon.xml | perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(VERSION)"$$2~')

addon.xml: $(NAME)
	$(file >$@.in,$(addon_version))

addon.provider:
	xmllint --format $(NAME)/addon.xml | perl -pe 's~(\<addon[^\>]*?id=)".*?"([^\>]*\>)~$$1"$(ID)"$$2~' > $(NAME)/addon.xml

addon.id:
	xmllint --format $(NAME)/addon.xml | perl -pe 's~(\<addon[^\>]*?provider.name=)".*?"([^\>]*\>)~$$1"$(PROVIDER)"$$2~' > $(NAME)/addon.xml

addons.xml:
	@echo '$(strip $(addons_xml))' | xmllint --format - > addons.xml

addons.xml.md5: addons.xml
	md5sum addons.xml > addons.xml.md5

define addons_xml =
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
	$(shell for dir in */addon.xml; do cat $$dir | xmllint --c14n11 -; done)
</addons>
endef
