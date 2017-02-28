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
    curl -sL $1 | xmllint --xpath "/addons/addon[@id='$2']" - | perl -pe "$(printf 's|version="([^"]+)"|version="%s"|g' $3)"
}

function current-version() {
    cat | xmllint --xpath "string(/addons/addon[@id='$1']/@version)" -
}

function next-version() {
    local ver=$(cat | xmllint --xpath 'string(//addon/@version)' -)
    local minor=${ver##*.}
    echo ${ver%.*}.$((minor + 1))~alpha
}

function update-addon() {
    cat | perl -pe "$(printf 's|((?<=addon).*)version="[^"]+"|$1 version="%s"|' $2)"
}

function patch-addon() {
    cat $1/addon.xml | tee $pipe | update-addon $1 $(cat $pipe | next-version $1) > $1/addon.xml
    cat $1/addon.xml | xmllint --xpath 'string(//addon/@version)' -
}


# addon_name addon_version
function add-zip() {
    zip_name=$1-$2.zip
    zip -q -r $zip_name $1

    addon_dst=`dirname $PWD`/html/$1 && mkdir -p $addon_dst
    md5sum $zip_name > $addon_dst/$zip_name.md5 && mv $zip_name $addon_dst
}

mkdir -p build
pushd build #build-dir

pipe=/tmp/srv-input
rm -f $pipe
exec 4<>$pipe

### script.module.youtube.dl
if [[ ! -d $youtube_name ]]; then
  git init $youtube_name
  pushd $youtube_name #youtube-dir
  git remote add -f -m master -t master origin git@github.com:ruuk/script.module.youtube.dl.git
  git remote add -f -m master -t master youtube_dl git@github.com:rg3/youtube-dl.git
  git pull 1>/dev/null && git rm -r lib/youtube_dl 1>/dev/null
  git read-tree --prefix=lib/youtube_dl/ -u youtube_dl/master:youtube_dl 1>/dev/null
  popd #youtube-dir
fi
youtube_ver=$(patch-addon $youtube_name)
# cat $youtube_name/addon.xml | tee $pipe | update-addon $youtube_name $(cat $pipe | next-version $youtube_name)

### plugin.video.fanfilm
if [[ ! -d $fanfilm_name ]]; then
  git clone git@github.com:gallna/plugin.video.fanfilm.git $fanfilm_name
fi
fanfilm_ver=$(patch-addon $fanfilm_name)

# cat $fanfilm_name/addon.xml | tee $pipe | update-addon $fanfilm_name $(cat $pipe | next-version $fanfilm_name)
exec 4<&-

add-zip $youtube_name $youtube_ver
add-zip $fanfilm_name $fanfilm_ver

popd #build-dir
rm -rf build/*

external_url=http://$(curl -s ipinfo.io/ip):888
(
cat <<EOT
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
  `addon $fanfilm_repo $fanfilm_name $fanfilm_ver`
  `addon $youtube_repo $youtube_name $youtube_ver`
  <addon id="repository.gallna" name="gallna repository" version="1.0.0" provider-name="gallna">
    <extension point="xbmc.addon.repository" name="gallna Add-on Repository">
      <info compressed="false">$external_url/addons.xml</info>
      <checksum>$external_url/addons.xml.md5</checksum>
      <datadir zip="true">$external_url</datadir>
    </extension>
  </addon>
</addons>
EOT
) | tee html/addons.xml | md5sum - > html/addons.xml.md5
popd #self-dir
