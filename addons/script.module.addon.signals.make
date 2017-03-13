SHELL = /bin/bash

GIT_REPO := git@github.com:ruuk/script.module.addon.signals.git
GIT_BRANCH ?= master
.PHONY: all build clean

# Compile the entire program. This should be the default targe
all: build

build:
	git init
	git remote add -f -m $(GIT_BRANCH) -t $(GIT_BRANCH) origin $(GIT_REPO)
	git pull

# Delete all files that war created by running make.
clean:
	rm -rf $(CURDIR)
