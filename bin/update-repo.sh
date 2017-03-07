#!/bin/bash

external_url=http://$(curl -s ipinfo.io/ip):888;
repo_name=repository.gallna
repo_ver=1.0.4

mkdir -p build/$repo_name

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
) > build/$repo_name/addon.xml
