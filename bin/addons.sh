#!/bin/bash

function version() {
    local ver=$(curl -sL $1 | xmllint --xpath "string(/addons/addon[@id='$2']/@version)" -)
    local minor=${ver##*.}
    echo ${ver%.*}.$((minor + 1))
}

function addon() {
    curl -sL $1 | xmllint --xpath "/addons/addon[@id='$2']" - | perl -pe "$(printf 's|version="([^"]+)"|version="%s"|g' $3)"
}

function current-version() {
    cat | xmllint --xpath "string(/addons/addon[@id='$1']/@version)" -
    # xmllint --xpath 'string(//addon/@version)' $1/addon.xml
}

function next-version() {
    local ver=$(cat | xmllint --xpath 'string(//addon/@version)' -)
    local minor=${ver##*.}
    echo ${ver%.*}.$((minor + 1))
}

function patch-addon() {
    local next_ver=$(cat $1/addon.xml | next-version $1)
    perl -p -i -e "$(printf 's|(\<addon.*)(version=".*?")([^\>]*>)|$1 version="%s" $3|' $next_ver)" $1/addon.xml
    echo $next_ver
}

# addon_name addon_version
function add-zip() {
    zip_name=$1-$2.zip
    zip -q -r $zip_name $1

    addon_dst=`dirname $PWD`/html/$1 && mkdir -p $addon_dst
    md5sum $zip_name > $addon_dst/$zip_name.md5 && mv $zip_name $addon_dst
}

pipe=/tmp/srv-input
exec 4<>$pipe
# The location of the zip files should be `/datadir/addon.id/addon.id-x.y.z.zip`
pushd `dirname $0` #self-dir

fanfilm_repo=http://kodi.filmkodi.com/addons.xml
fanfilm_name=plugin.video.fanfilm
youtube_repo=http://mirror.ox.ac.uk/sites/xbmc.org/addons/leia/addons.xml
youtube_name=script.module.youtube.dl
repo_name=repository.gallna
repo_ver=1.0.4

mkdir -p build
if [[ ! -d build/$repo_name ]]; then
  cp -R $repo_name build/
fi
pushd build #build-dir

if [[ -f $repo_name/addon.xml ]]; then
  repo_ver=$(patch-addon $repo_name)
fi

### script.module.youtube.dl
if [[ ! -d $youtube_name ]]; then
  git init $youtube_name
  pushd $youtube_name #youtube-dir
  git remote add -f -m master -t master origin git@github.com:ruuk/script.module.youtube.dl.git
  git remote add -f -m master -t master youtube_dl git@github.com:rg3/youtube-dl.git
  git pull && git rm -r lib/youtube_dl 1>/dev/null
  git read-tree --prefix=lib/youtube_dl/ -u youtube_dl/master:youtube_dl
  popd #youtube-dir
fi
youtube_ver=$(patch-addon $youtube_name)
add-zip $youtube_name $youtube_ver



### plugin.video.fanfilm
if [[ ! -d $fanfilm_name ]]; then
  git clone git@github.com:gallna/plugin.video.fanfilm.git $fanfilm_name
fi
fanfilm_ver=$(patch-addon $fanfilm_name)
echo $fanfilm_ver
add-zip $fanfilm_name $fanfilm_ver



### repository.gallna
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' > $repo_name/addon.xml
external_url=http://$(curl -s ipinfo.io/ip):888
external_url=http://10.10.10.10:888
(
cat <<EOT
<addon id="$repo_name" name="gallna repository" version="$repo_ver" provider-name="gallna">
  <extension point="xbmc.addon.repository" name="gallna Add-on Repository">
    <info compressed="false">$external_url/addons.xml</info>
    <checksum>$external_url/addons.xml.md5</checksum>
    <datadir zip="true">$external_url</datadir>
  </extension>
</addon>
EOT
) | tee -a $repo_name/addon.xml | (
cat <<EOT
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
  `cat`
  `addon $fanfilm_repo $fanfilm_name $fanfilm_ver`
  `addon $youtube_repo $youtube_name $youtube_ver`
</addons>
EOT
) | tee >(md5sum - > addons.xml.md5) > addons.xml

add-zip $repo_name $repo_ver
popd #build-dir
cp build/addons.* html/


### clen-up
# rm -rf build/*
exec 4<&-
rm -f $pipe
popd #self-dir
