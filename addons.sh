#!/bin/bash

pushd `dirname $0` #self-dir
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

# addon_name addon_version
function add-zip() {
    zip_name=$1-$2.zip
    addon_src=build/$1
    cd $addon_src && zip -r $zip_name . && cd -

    addon_dst=html/$1 && mkdir -p $addon_dst
    md5sum $addon_src/$zip_name > $addon_dst/$zip_name.md5
    mv $addon_src/$zip_name $addon_dst
}

mkdir -p build
pushd build #build-dir

### script.module.youtube.dl
git init $youtube_name
pushd $youtube_name #youtube-dir
git remote add -f -m master -t master origin git@github.com:ruuk/script.module.youtube.dl.git
git remote add -f -m master -t master youtube_dl git@github.com:rg3/youtube-dl.git
git pull 1>/dev/null && git rm -r lib/youtube_dl 1>/dev/null
git read-tree --prefix=lib/youtube_dl/ -u youtube_dl/master:youtube_dl 1>/dev/null
popd #youtube-dir

### plugin.video.fanfilm
git clone git@github.com:gallna/plugin.video.fanfilm.git $fanfilm_name

popd #build-dir
add-zip $youtube_name $(version $youtube_repo $youtube_name)
add-zip $fanfilm_name $(version $fanfilm_repo $fanfilm_name)
rm -rf build/*

external_url=http://$(curl -s ipinfo.io/ip):888
(
cat <<XML;
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
  <addon id="repository.gallna" name="gallna repository" version="1.0.0" provider-name="gallna">
    <extension point="xbmc.addon.repository" name="gallna Add-on Repository">
      <info compressed="false">$external_url/addons.xml</info>
      <checksum>$external_url/addons.xml.md5</checksum>
      <datadir zip="true">$external_url</datadir>
    </extension>
  </addon>
  `addon $fanfilm_repo $fanfilm_name`
  `addon $youtube_repo $youtube_name`
</addons>
XML
) > html/addons.xml
md5sum html/addons.xml > html/addons.xml.md5

popd #self-dir
