# globa variable
GLOBAL = {}

api_version = 1

if Ti.Platform.model is 'Simulator'
  host = 'localhost:3000'
else
  host = '192.168.11.5:3000'

GLOBAL.HOST = host
GLOBAL.API_URL = "http://#{host}/api/v#{api_version}"
GLOBAL.APP_URL_SCHEME = "tibackyardclient://"
GLOBAL.LAST_URL_SCHEME = null

if Ti.App.Properties.hasProperty 'user'
  GLOBAL.user = JSON.parse Ti.App.Properties.getString 'user'
else
  GLOBAL.user = {
    id: null
    name: null
    email: null
    auth_token: null
    device_token: Ti.Platform.getId()
  }

module.exports = GLOBAL