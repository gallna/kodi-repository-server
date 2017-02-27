#!/bin/bash

selfdir=`dirname $0`
# The location of the zip files should be `/datadir/addon.id/addon.id-x.y.z.zip`
fanfilm_repo=http://kodi.filmkodi.com/addons.xml
fanfilm_name=plugin.video.fanfilm
youtube_repo=http://mirror.ox.ac.uk/sites/xbmc.org/addons/leia/addons.xml
youtube_name=script.module.youtube.dl

function version() {
    local ver=$(curl -sL $1 | xmllint --xpath "string(/addons/addon[@id='$2']/@version)" -)
    local minor=${ver##*.}
    echo ${ver%.*}.$((minor + 1))~alpha
}

function addon() {
    curl -sL $1 | xmllint --xpath "/addons/addon[@id='$2']" - | perl -pe "$(printf 's|version="([^"]+)"|version="%s"|g' $(version $1 $2))"
}

### script.module.youtube.dl
git clone git@github.com:ruuk/script.module.youtube.dl.git $selfdir/$youtube_name

pushd $selfdir/$youtube_name
git remote add -f -m master -t master youtube_dl git@github.com:rg3/youtube-dl.git
git rm -r lib/youtube_dl
git read-tree --prefix=lib/youtube_dl/ -u youtube_dl/master:youtube_dl
popd

zip_name=$youtube_name-$(version $youtube_repo $youtube_name).zip
zip -r $zip_name $selfdir/$youtube_name
mkdir -p $selfdir/html/$youtube_name && mv $zip_name $selfdir/html/$youtube_name

### plugin.video.fanfilm
git clone git@github.com:gallna/plugin.video.fanfilm.git $selfdir/$fanfilm_name

zip_name=$fanfilm_name-$(version $fanfilm_repo $fanfilm_name).zip
zip -r $zip_name $selfdir/$fanfilm_name
mkdir -p $selfdir/html/$fanfilm_name && mv $zip_name $selfdir/html/$fanfilm_name

(
cat <<XML;
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
  `addon $fanfilm_repo $fanfilm_name`
  `addon $youtube_repo $youtube_name`
</addons>
XML
) > $selfdir/html/addons.xml
