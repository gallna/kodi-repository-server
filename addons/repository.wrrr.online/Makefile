SHELL = /bin/bash

objects := $(shell dirname */Makefile)

.PHONY: all $(objects)

# Compile the entire program. This should be the default targe
all: $(objects)

$(objects):
	$(MAKE) -C $@ build
