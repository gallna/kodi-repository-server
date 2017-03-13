SHELL = /bin/bash

VERSION := $(shell curl -sL https://raw.githubusercontent.com/rg3/youtube-dl/master/youtube_dl/version.py | grep version | awk '{ gsub(/'"'"'/, ""); print $$3 }')

.PHONY: all build git patch version clean

# Compile the entire program. This should be the default targe
all: clean build patch version test

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
	$(info Old version $(shell xmllint --xpath 'string(//addon/@version)' addon.xml))
	$(file >addon.xml,$(shell xmllint --format addon.xml |\
		perl -pe 's~(\<addon[^\>]*?version=)".*?"([^\>]*\>)~$$1"$(VERSION)"$$2~'))
	$(info New version $(shell xmllint --xpath 'string(//addon/@version)' addon.xml))

# Delete all files that war created by running make.
clean:
	rm -rf $(CURDIR)/* $(CURDIR)/.git

test:
	@xmllint --format addon.xml
