# Kodi repo server

The location of the zip files should be `/addon.id/addon.id-x.y.z.zip`

```bash
sudo apt install libxml2-utils zip
./addons.sh
docker-compose up -d
echo http://$(curl -s ipinfo.io/ip):888/addons.xml
```

## Update procedure
```bash
# update procedure
cd addons/script.module.youtube.dl && make -f ../script.module.youtube.dl.make
cd addons/repository.wrrr.online.make && make -f ../repository.wrrr.online.make

make script.module.youtube.dl repository.wrrr.online addons.xml.md5

# push to server
mount ~/mnt/wrrr && make push && umount ~/mnt/wrrr
```

## kodi.filmkodi.com

https://github.com/mrknow/filmkodi
http://kodi.filmkodi.com/addons.xml

```bash
git init
git remote add -f filmkodi git@github.com:mrknow/filmkodi.git
git read-tree -m -u filmkodi/master:plugin.video.fanfilm
git filter-branch --subdirectory-filter plugin.video.fanfilm -- --all
git commit -m 'merging in filmkodi plugin.video.fanfilm'

filter-branch subdirectory-filter plugin.video.fanfilm
```

## script.module.youtube.dl

https://github.com/rg3/youtube-dl
https://github.com/ruuk/script.module.youtube.dl
https://raw.githubusercontent.com/ruuk/script.module.youtube.dl/master/addon.xml

```bash
git remote add -f -m master -t master origin git@github.com:ruuk/script.module.youtube.dl.git
git remote add -f -m master -t master youtube_dl git@github.com:rg3/youtube-dl.git
git pull && git rm -r lib/youtube_dl

## subtree
git read-tree --prefix=lib/youtube_dl/ -u youtube_dl/master:youtube_dl
## submodule
git submodule add git@github.com:rg3/youtube-dl.git lib/youtube_dl
cd lib/youtube_dl && git filter-branch --subdirectory-filter youtube_dl -- --all

git commit -m 'replaced hardcoded youtube_dl module with original one'
```
