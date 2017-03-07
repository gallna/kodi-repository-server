#!/bin/bash
pushd `dirname $0` #self-dir

fanfilm_repo=http://kodi.filmkodi.com/addons.xml
fanfilm_name=plugin.video.fanfilm
youtube_repo=http://mirror.ox.ac.uk/sites/xbmc.org/addons/leia/addons.xml
youtube_name=script.module.youtube.dl
repo_name=repository.gallna
repo_ver=1.0.4

mkdir -p build
pushd build #build-dir

### repository.gallna
if [[ -f $repo_name/addon.xml ]]; then
  mkdir -p $repo_name
  external_url=http://$(curl -s ipinfo.io/ip):888;
(
cat <<EOT
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addon id="$repo_name" name="gallna repository" version="$repo_ver" provider-name="gallna">
  <extension point="xbmc.addon.repository" name="gallna Add-on Repository">
    <info compressed="false">$external_url/addons.xml</info>
    <checksum>$external_url/addons.xml.md5</checksum>
    <datadir zip="true">$external_url</datadir>
  </extension>
</addon>
EOT
) > $repo_name/addon.xml
fi

### script.module.youtube.dl
if [[ ! -d $youtube_name ]]; then
  git init $youtube_name
  pushd $youtube_name #youtube-dir
  git remote add -f -m master -t master origin git@github.com:ruuk/script.module.youtube.dl.git
  git remote add -f -m master -t master youtube_dl git@github.com:rg3/youtube-dl.git
  git pull && git rm -r lib/youtube_dl 1>/dev/null
  git read-tree --prefix=lib/youtube_dl/ -u youtube_dl/master:youtube_dl
  curl -L http://pastebin.com/raw/HupBJ1iz > lib/youtube_dl/extractor/openload.py
  popd #youtube-dir
fi

### plugin.video.fanfilm
if [[ ! -d $fanfilm_name ]]; then
  git clone git@github.com:gallna/plugin.video.fanfilm.git $fanfilm_name
fi

popd #build-dir
popd #self-dir
