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
http://kodi.wiki/view/Add-on_repositories
http://kodi.filmkodi.com/repository.filmkodi.com/
http://23.251.140.205:888/

Dopoki MrKnow nie naprawi bledow, moja **dzialajaca wersja FanFilm** - przygotowana na potrzeby demonstracji [pull request](https://github.com/mrknow/filmkodi/pull/779) z podmienionym wadliwym komponentem (_youtube_dl_ zamiast  _urlresolver9_).
- repozytorium **Kodi:** [plugin.video.fanfilm.dl](http://kodi.wrrr.online:888/addons.xml)
- repozytorium **git**: [pull request](https://github.com/mrknow/filmkodi/pull/779), [plugin.video.fanfilm](https://github.com/gallna/plugin.video.fanfilm)

Wersja robocza, jednak dziala na moim fire-stick przez ostatni tydzien. Dzisiaj naprawilem irytujacy niedzialajacy cancel button + [Openload](https://github.com/rg3/youtube-dl/issues/10408)

tutaj
komponentem   wyeksponowanymi zmianami, jako ze repozytorium git i kodi plugin roznia sie, dostepne tutaj:
- repozytorium **Kodi:** [plugin.video.fanfilm.dl](http://kodi.wrrr.online:888/addons.xml)
- repozytorium **git**: [pull request](https://github.com/mrknow/filmkodi/pull/779), [plugin.video.fanfilm](https://github.com/gallna/plugin.video.fanfilm)

-
Proponowana _youtube_dl_ wersja **FanFilm** z wyeksponowanymi zmianami, jako ze repozytorium git i kodi plugin roznia sie, dostepne tutaj:


Daj znac jesli akceptujesz moje zmiany.
Daj znac, jesli zmiany odpowiadaj
gdzie wyraznie widac wszystkie wprowadzone zmiany.


Jako, ze repozytorium git i kodi roznia sie, **FanFilm** modul wrzucilem do [innego repo](https://github.com/gallna/plugin.video.fanfilm) - gdzie wyraznie widac wszystkie wprowadzone zmiany.

Dzialajacy Kodi plugin z _youtube_dl_ zamiast _urlresolver9_ dostepny pod nazwa:
[plugin.video.fanfilm.dl](http://kodi.wrrr.online:888/addons.xml)
