SHELL = /bin/bash

ifdef NAME
ADDONID ?= $(call addon_id,$(NAME))
VERSION ?= $(call addon_version,$(NAME))
endif

addon_id = xmllint --xpath 'string(//addon/@id)' $(1)/addon.xml
addon_version = xmllint --xpath 'string(//addon/@version)' $(1)/addon.xml
patch_id = xmllint --format $(1)/addon.xml | perl -pe 's~(\<addon[^\>]*?id=)".*?"([^\>]*\>)~$$1"$(2)"$$2~' > addon.xml
patch_version = xmllint --format $(1)/addon.xml | perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(2)"$$2~' > addon.xml
patch_provider = xmllint --format $(1)/addon.xml | perl -pe 's~(\<addon[^\>]*?provider.name=)".*?"([^\>]*\>)~$$1"$(2)"$$2~' > $(1)addon.xml
addon_file = $(join $(1),-$(call addon_version,$(1)))
addon_src = $(realpath ../addons/$(1))

addons = $(shell dirname ../addons/**/addon.xml)
objects := $(shell basename -a $(addons))

.PHONY: all clean $(objects) %.zip %.zip.md5 %/addon.xml addons.xml addons.xml.md5

# Compile the entire program. This should be the default targe
all: $(NAME)/addon.xml $(NAME).zip.md5 adons.xml

clean:
	rm -rf $(dir */*)
	rm -f *.zip *md5 *xml

$(objects):
	cp -R $(call addon_src,$@) $@

%.zip: %
	zip -q -r $@ $<

%.zip.md5: %.zip
	md5sum $< > $@

%/addon.xml: %
ifeq ($(NAME),)
ifeq ($(VERSION),)
	NAME=$< $(MAKE) $@
else
	$(call patch_version,$<,$(VERSION))
endif
else
	$(call patch_id,$<,$(NAME))
	$(call patch_version,$<,$(VERSION))
endif

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
