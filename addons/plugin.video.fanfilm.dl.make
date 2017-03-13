SHELL = /bin/bash

GIT_REPO := git@github.com:gallna/plugin.video.fanfilm.git
GIT_BRANCH ?= fanfilm/youtube-dl
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
