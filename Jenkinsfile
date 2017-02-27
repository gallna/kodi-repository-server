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
