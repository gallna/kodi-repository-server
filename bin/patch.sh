

#!/bin/bash

function current-version() {
    cat | xmllint --xpath 'string(//addon/@version)' -
}

function next-version() {
    local ver=$(cat | current-version)
    local minor=${ver##*.}
    echo ${ver%.*}.$((minor + 1))
}

# id version provider-name
function patch-addon() {
    cat | perl -p -e "$(printf 's|(\<addon.*)(id=".*?")([^\>]*>)|$1 id="%s" $3|' $1)" |\
        perl -p -e "$(printf 's|(\<addon.*)(version=".*?")([^\>]*>)|$1 version="%s" $3|' $2)" |\
        perl -p -e "$(printf 's|(\<addon.*)(provider-name=".*?")([^\>]*>)|$1 provider-name="%s" $3|' $3)"
}

# $id $version
function add-zip() {
    zip_name=$1-$2.zip
    zip -q -r $zip_name $1
    md5sum $zip_name > $zip_name.md5
}

pushd `dirname $0` #self-dir

mkdir -p build
addons_tmp=$(mktemp)
pushd build #build-dir

for addon_xml in */addon.xml; do
  name=$(basename `dirname $addon_xml`)
  ver=$(cat $addon_xml | current-version)
  # ver=$(cat $addon_xml.patch | next-version)

  if [[ -f $addon_xml.patch ]]; then
    test -f $addon_xml.orig || cp -u $addon_xml $addon_xml.orig
    ver=$(cat $addon_xml.patch | current-version)
    xmllint --format $addon_xml.patch | patch-addon $name $ver > $addon_xml
  fi

  printf "\n\n\n%30s$name:$ver%30s\n\n\n" | tr "  " "."

  add-zip $name $ver
  xmllint --c14n11 $addon_xml >> $addons_tmp

  mkdir -p ../html/$name
  mv $name*.zip ../html/$name/
  mv $name*.zip.md5 ../html/$name/
done

(
cat <<EOT
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<addons>
  `cat $addons_tmp`
</addons>
EOT
) | tee >(md5sum - > ../html/addons.xml.md5) > ../html/addons.xml

popd #build-dir
popd #self-dir
