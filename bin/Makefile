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


SHELL = /bin/bash

# VERSION := $(shell curl -sL https://raw.githubusercontent.com/rg3/youtube-dl/master/youtube_dl/version.py | grep version | awk '{ gsub(/'"'"'/, ""); print $$3 }')

.PHONY: all build git patch version clean

# Compile the entire program. This should be the default targe
all: build patch version

# Build the project and create docker container
build:
	git init
	git remote add -f -m master -t master origin git@github.com:ruuk/script.module.youtube.dl.git
	git remote add -f -m master -t master youtube_dl git@github.com:rg3/youtube-dl.git
	git pull && git rm -r lib/youtube_dl 1>/dev/null
	git read-tree --prefix=lib/youtube_dl/ -u youtube_dl/master:youtube_dl

# Patch project
patch:
	# curl -L http://pastebin.com/raw/HupBJ1iz > lib/youtube_dl/extractor/openload.py

# Patch project version
version:
	$(file >addon.xml,$(shell xmllint --format addon.xml |\
		perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(VERSION)"$$2~'))

# Delete all files that war created by running make.
clean:
	echo rm -rf $(CURDIR)

ver_url=https://raw.githubusercontent.com/rg3/youtube-dl/master/youtube_dl/version.py
VERSION = $(shell curl -sL $(ver_url) | grep version | awk '{ gsub(/'"'"'/, ""); print $$3 }')

next_version=$(VERSION | awk 'BEGIN{FS=OFS="."}{$$NF=($$NF + 1); print}')

define addon_version =
xmllint --format addon.xml | perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(1)"$$2~'
endef
# perl -pei 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(next_version)"$$2~' addon.xml

next_addon_version:
	$(call addon_version,$(VERSION))





.ONESHELL:
SHELL = /usr/bin/perl
.SHELLFLAGS = -e
show :
	# Make sure "@" is not the first character on the first line
	@f = qw(a b c);
	print "@f\n";

.ONESHELL:
SHELL = /bin/bash
foo ::
	echo $(@D) && echo $PWD
	cd ..
	echo $(CURDIR)

define my_important_task =
# script goes here
endef

my-important-task: ; $(value my_important_task)



define next_addon_version =
VERSION=$(xmllint --xpath 'string(//addon/@version)' $(NAME)/addon.xml)
addon_version=$(xmllint --format addon.xml | perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(VERSION)"$$2~')
next_version=$(echo $(addon_version) | awk 'BEGIN{FS=OFS="."}{$$NF=($$NF + 1); print}')
perl -pei 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(next_version)"$$2~' addon.xml
endef

my-important-task: ; $(value my_important_task)
	
