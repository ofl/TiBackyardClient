// Generated by CoffeeScript 1.4.0
(function() {
  var GLOBAL, Network, apns;

  Network = require('js/lib/Network');

  GLOBAL = require('js/lib/global');

  apns = function() {
    var _callback, _error, _onSuccess, _success;
    _onSuccess = function(status, hash) {
      if (status === 204) {
        console.log('DeviceToken was registered');
      } else {
        console.log('Can not register deviceToken');
      }
    };
    _success = function(e) {
      var deviceToken, network;
      deviceToken = e.deviceToken;
      if (Ti.App.Properties.getBool('is_logged_in')) {
        network = new Network({
          success: _onSuccess
        });
        network.request('PUT', "" + GLOBAL.API_URL + "/users/update", {
          auth_token: GLOBAL.user.auth_token,
          device_token: e.deviceToken
        });
      }
    };
    _error = function(e) {
      console.log(e.error);
    };
    _callback = function(e) {
      var badge, message;
      Ti.Media.vibrate();
      console.log(e.data);
      badge = e.data.badge;
      if (badge > 0) {
        Ti.UI.iPhone.appBadge = badge;
      }
      message = e.data.alert;
      if (message !== '') {
        alert(message);
      }
    };
    Ti.Network.registerForPushNotifications({
      types: [Ti.Network.NOTIFICATION_TYPE_BADGE, Ti.Network.NOTIFICATION_TYPE_ALERT, Ti.Network.NOTIFICATION_TYPE_SOUND],
      success: _success,
      error: _error,
      callback: _callback
    });
  };

  module.exports = apns;

}).call(this);