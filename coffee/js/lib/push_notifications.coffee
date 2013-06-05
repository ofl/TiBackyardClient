#https://gist.github.com/yagitoshiro/1208144

Network = require 'js/lib/Network'
GLOBAL = require 'js/lib/global'

apns = ()->
  _onSuccess = (status, hash)->
    if status is 204
      console.log 'DeviceToken was registered'
    else
      console.log 'Can not register deviceToken'
    return

  _success = (e)->
    deviceToken = e.deviceToken
    if Ti.App.Properties.getBool 'is_logged_in'
      network = new Network({success: _onSuccess})
      network.request 'PUT', "#{GLOBAL.API_URL}/users/update", {
        auth_token: GLOBAL.user.auth_token
        device_token: e.deviceToken
      }
    return

  _error = (e)->
    console.log e.error
    return

  _callback = (e)->
    Ti.Media.vibrate()
    console.log e.data

    badge = e.data.badge
    if badge > 0
      Ti.UI.iPhone.appBadge = badge
    message = e.data.alert
    if message isnt ''
      alert message
    return


  Ti.Network.registerForPushNotifications
    types: [
      Ti.Network.NOTIFICATION_TYPE_BADGE,
      Ti.Network.NOTIFICATION_TYPE_ALERT,
      Ti.Network.NOTIFICATION_TYPE_SOUND        
    ]
    success: _success
    error: _error
    callback: _callback 

  return

module.exports = apns