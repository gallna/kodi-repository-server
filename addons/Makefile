SHELL = /bin/bash

objects := script.module.youtube.dl script.module.addon.signals repository.wrrr.online plugin.video.fanfilm.dl

.PHONY: $(objects)

$(objects):
	test -d "$@" || mkdir $@
	cd $@ && $(MAKE) -f ../$@.make
