#!groovy

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
println groovy.xml.XmlUtil.serialize(response)

script.module.addon.signals
Provides signal/slot mechanism for inter-addon communication in Kodi





node {
// git git@github.com:ruuk/script.module.youtube.dl.git
checkout([$class: 'GitSCM',
  branches: [[name: '*/youtube-dl']],
  userRemoteConfigs: [
    [url: 'git@github.com:gallna/script.module.youtube.dl.git']
  ]
  extensions: [
    [$class: 'RelativeTargetDirectory', relativeTargetDir: 'script.module.youtube.dl']
  ]
])

checkout([$class: 'GitSCM',
  branches: [[name: '*/master']],
  userRemoteConfigs: [
    [url: 'git@github.com:rg3/youtube-dl.git']
  ]
  extensions: [
    [$class: 'RelativeTargetDirectory', relativeTargetDir: 'script.module.youtube.dl/lib/youtube-dl '],
    [$class: 'CheckoutOption'],
    [$class: 'CloneOption', depth: 0, noTags: false, reference: 'youtube-dl ', shallow: false]
  ],
  submoduleCfg: [],
  doGenerateSubmoduleConfigurations: false,
])

checkout([$class: 'GitSCM',
  branches: [[name: '*/fanfilm/youtube-dl']],
  userRemoteConfigs: [
    [url: 'git@github.com:gallna/filmkodi.git']
  ]
  extensions: [
    [$class: 'RelativeTargetDirectory', relativeTargetDir: 'plugin.video.fanfilm']
  ],
  submoduleCfg: [],
  doGenerateSubmoduleConfigurations: false,
])

checkout([$class: 'GitSCM',
  userRemoteConfigs: [
    [url: 'git@github.com:ruuk/script.module.addon.signals.git']
  ]
  extensions: [
    [$class: 'RelativeTargetDirectory', relativeTargetDir: 'fanfilm/youtube-dl ']
  ],
  submoduleCfg: [],
  doGenerateSubmoduleConfigurations: false,
])

    dir("live/${env.PROJECT}") {

      // deploy to development
      withEnv(["VERSION=${env.VERSION}", "NAME=${env.PROJECT}"]) {
          // deploy to development
          stage 'Deploy'
          sh "make upgrade"

          // do integration tests using development environment
          stage 'Integration tests'
          sh "make integration-tests"
      }
  }

def xml = new groovy.xml.StreamingMarkupBuilder().bind {
    records {
        car(name:'HSV Maloo', make:'Holden', year:2006) {
            country('Australia')
            record(type:'speed', 'Production Pickup Truck with speed of 271kph')
        }
        car(name:'P50', make:'Peel', year:1962) {
            country('Isle of Man')
            record(type:'size', 'Smallest Street-Legal Car at 99cm wide and 59 kg in weight')
        }
        car(name:'Royale', make:'Bugatti', year:1931) {
            country('France')
            record(type:'price', 'Most Valuable Car at $15 million')
        }
    }
}

currentBuild.result = "SUCCESS"
