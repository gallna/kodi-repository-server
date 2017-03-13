#!groovy

// def xml = new groovy.xml.StreamingMarkupBuilder().bind {
//     addons {
//         addon(id:'plugin.video.fanfilm', name:'FanFilm - MrKnow', version:"2017.01.26.4") {
//             extension(point="xbmc.python.pluginsource" library="default.py") {
//                 provides('video')
//             }
//         }
//     }
// }
//
// def response = new XmlParser().parseText(xml.toString())
// response.appendNode(
//     new groovy.xml.QName("numberOfResults"),
//     [:],
//     "1"
// )
// response.@numberOfResults = "2"
// println groovy.xml.XmlUtil.serialize(response)

xml1 = """
<addons>
  <addon id="plugin.video.fanfilm.dl" name="FanFilm.dl" provider-name="gallna" version="2017.01.26.5">
  <requires>
    <import addon="xbmc.python" version="2.1.0"></import>
    <import addon="script.module.requests"></import>
    <import addon="script.module.metahandler"></import>
    <import addon="plugin.video.youtube"></import>
    <import addon="script.module.fanfilm.youtube.dl" version="16.1026.1"></import>
    <import addon="script.module.youtube.dl"></import>
    <import addon="script.mrknow.urlresolver"></import>
    <import addon="script.specto.media"></import>
  </requires>
  <extension library="default.py" point="xbmc.python.pluginsource">
    <provides>video</provides>
  </extension>
  <extension library="service.py" point="xbmc.service" start="startup"></extension>
  <extension point="xbmc.addon.metadata">
    <summary lang="en">FanFilm Alpha version</summary>
    <description lang="en">FanFilm </description>
    <disclaimer lang="en">The author does not host or distribute any of the content displayed by this addon. The author does not have any affiliation with the content provider.
		</disclaimer>
    <summary lang="pl">FanFilm wersja Alfa</summary>
    <description lang="pl">FanFilm wersja Alfa - 50% nie działa.</description>
    <disclaimer lang="pl">The author does not host or distribute any of the content displayed by this addon. The author does not have any affiliation with the content provider.
		</disclaimer>
    <forum>https://github.com/mrknow/filmkodi/issues</forum>
    <source>http://filmkodi.com/repository/</source>
    <website>http://filmkodi.com/</website>
    <platform>all</platform>
  </extension>
</addon><addon id="repository.gallna" name="gallna repository" provider-name="gallna" version="1.0.7">
  <extension name="gallna Add-on Repository" point="xbmc.addon.repository">
    <info compressed="false">http://kodi.wrrr.online:888/addons.xml</info>
    <checksum>http://kodi.wrrr.online:888/addons.xml.md5</checksum>
    <datadir zip="true">http://kodi.wrrr.online:888</datadir>
  </extension>
</addon><addon id="script.module.addon.signals" name="Addon Signals" provider-name="Rick Phillips (ruuk)" version="0.0.1">
	<extension library="lib" point="xbmc.python.module"></extension>
	<extension point="xbmc.addon.metadata">
		<summary lang="en">Inter-addon signalling</summary>
		<description lang="en">Provides signal/slot mechanism for inter-addon communication</description>
		<platform>all</platform>
		<license>GNU GENERAL PUBLIC LICENSE Version 2.1, February 1999</license>
		<source>https://github.com/ruuk/script.module.addon.signals</source>
	</extension>
</addon><addon id="script.module.fanfilm.youtube.dl" name="youtube_dl" provider-name="gallna" version="16.1026.1">
  <requires>
    <import addon="xbmc.python" version="2.1.0"></import>
    <import addon="script.module.addon.signals" version="0.0.1"></import>
  </requires>
  <extension library="control.py" point="xbmc.python.script">
    <provides>executable</provides>
  </extension>
  <extension library="lib" point="xbmc.python.module"></extension>
  <extension point="xbmc.addon.metadata">
    <platform>all</platform>
    <summary lang="en">Module providing access to youtube-dl video stream extraction</summary>
    <description lang="en">Module providing access to youtube-dl video stream extraction for hundreds of sites. Version is based on youtube-dl date version: YY.MDD.V where V is the addon specific sub-version. Also provides downloading with the option for background downloading with a queue and queue manager.</description>
    <license>GNU GENERAL PUBLIC LICENSE. Version 2, June 1991</license>
    <forum>http://forum.xbmc.org/showthread.php?tid=200877</forum>
    <source>http://github.com/ruuk/script.module.youtube.dl</source>
  </extension>
</addon>
</addons>
"""

xml2 = """
<addon id="script.module.youtube.dl" name="youtube-dl Control" version="16.1026.0" provider-name="Rick Phillips (ruuk)">
    <requires>
        <import addon="xbmc.python" version="2.1.0" />
        <import addon="script.module.addon.signals" version="0.0.1"/>
    </requires>
    <extension point="xbmc.python.script" library="control.py">
        <provides>executable</provides>
    </extension>
    <extension point="xbmc.python.module" library="lib" />
    <extension point="xbmc.addon.metadata">
        <platform>all</platform>
        <summary lang="en">Module providing access to youtube-dl video stream extraction</summary>
        <description lang="en">Module providing access to youtube-dl video stream extraction for hundreds of sites. Version is based on youtube-dl date version: YY.MDD.V where V is the addon specific sub-version. Also provides downloading with the option for background downloading with a queue and queue manager.</description>
        <license>GNU GENERAL PUBLIC LICENSE. Version 2, June 1991</license>
        <forum>http://forum.xbmc.org/showthread.php?tid=200877</forum>
        <source>http://github.com/ruuk/script.module.youtube.dl</source>
    </extension>
</addon>
"""
def updateRepoXml(String id, String version) {
  def response = new XmlSlurper().parseText(xml1)
  def addon = response.addon.find {
      it['@id'].toString().contains(id)
  }
  println 'Current ' + id + ' version: ' +  addon['@version'].toString()
  addon['@version'] = version
  println groovy.xml.XmlUtil.serialize(response)
}

def updateAddonXml(String version) {
  def response = new XmlSlurper().parseText(xml2)
  println 'Current version: ' + response['@version'].toString()
  println 'Addon id: ' + response['@id'].toString()
  response['@version'] = version
  println groovy.xml.XmlUtil.serialize(response)
}

def id ='plugin.video.fanfilm.dl'
def version = 'v7.7.7.7'

updateRepoXml(id, version)
updateAddonXml(version)





// id = 'script.module.youtube.dl'
// response = new XmlSlurper().parseText(xml2)
// println response['@version'].toString()
// response['@version'] = version
// println groovy.xml.XmlUtil.serialize(response)

// def newNode = response.addon["@id"].text()
// println newNode.toString()
//
// response.addon['@version'].each {
//     println it.toString()
// }
//
// response.addon.each {
//     println it['@id'].toString()
// }



xml2 = """
<response version-api="2.0">
    <value>
        <books>
            <book id="2">
                <title>Don Xijote</title>
                <author id="1">Manuel De Cervantes</author>
            </book>
        </books>
    </value>
</response>
"""
// def response2 = new XmlSlurper().parseText(xml2)
// def newNode2 = response2.value.books.book[0].text()
// println newNode2.toString()


// a = addon.value
// response.value.addon[0].@version = "2"
/* Use the same syntax as groovy.xml.MarkupBuilder */
// response.addon[0].replaceNode{
//     book(id:"3")
// }

// println groovy.xml.XmlUtil.serialize(newNode)
//
// response.addon.@version = "2"
//
// assert response.addon.@version == "2"
// assert response.addon.@version == "2"
//
// def xml = new XmlParser().parse(xmlFile)
// xml.foo[0].each {
//     it.@id = "test2"
//     it.value = "test2"
// }

// -----------------------------------------------------------------------------

def xml = new groovy.xml.StreamingMarkupBuilder().bind {
    addons {
        addon(id:'plugin.video.fanfilm', name:'FanFilm - MrKnow', version:"2017.01.26.4") {
            extension(point="xbmc.python.pluginsource" library="default.py") {
                provides('video')
            }
        }
    }
}

def response = new XmlParser().parseText(xml.toString())
response.appendNode(
    new groovy.xml.QName("numberOfResults"),
    [:],
    "1"
)
response.@numberOfResults = "2"
// println groovy.xml.XmlUtil.serialize(response)
