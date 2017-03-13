ifndef NAME
$(error Select target to build [$(addons)].)
endif

SHELL = /bin/bash
$(info Processing $(NAME))
ADDON_ID ?= $(shell xmllint --xpath 'string(//addon/@id)' $(NAME)/addon.xml)
VERSION ?= $(shell xmllint --xpath 'string(//addon/@version)' $(NAME)/addon.xml)
addon_dirname ?= $(NAME)
addon_filename ?= $(join $(NAME),-$(VERSION))
addons = $(shell dirname ../addons/**/addon.xml)
objects := $(shell basename -a $(addons))

.PHONY: all clean $(objects) %.zip %.zip.md5 %/addon.xml

all: $(NAME).zip.md5

clean:
	rm -rf $(dir */*)
	rm -f *.zip *md5 *xml

$(objects):
	cp -R ../addons/$@/ $(addon_dirname)
	# rsync -ar --exclude=.git --info=progress2 $(realpath ../addons/$@)/ $(addon_dirname)

%.zip: %
	zip -q -r $(addon_filename).zip $(addon_dirname)

%.zip.md5: %.zip
	md5sum $(addon_filename).zip > $(addon_filename).zip.md5
