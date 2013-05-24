// Generated by CoffeeScript 1.4.0
(function() {
  var createWindow;

  createWindow = function(tab) {
    var GLOBAL, Network, loginRow, tableView, window, _logOut, _updateRowTitle;
    Network = require('js/lib/Network');
    GLOBAL = require('js/lib/global');
    window = Titanium.UI.createWindow({
      title: 'Login'
    });
    tableView = Ti.UI.createTableView({
      style: Ti.UI.iPhone.TableViewStyle.GROUPED,
      rowHeight: 44
    });
    window.add(tableView);
    loginRow = Ti.UI.createTableViewRow({
      title: 'Login via Facebook',
      color: 'green'
    });
    tableView.setData([loginRow]);
    _updateRowTitle = function() {
      if (Ti.App.Properties.getBool('is_logged_in')) {
        loginRow.title = 'Logout';
        loginRow.color = 'red';
      } else {
        loginRow.title = 'Login via Facebook';
        loginRow.color = 'green';
      }
    };
    _logOut = function(status, json) {
      if (status) {
        Ti.App.Properties.setBool('is_logged_in', false);
        _updateRowTitle();
      } else {
        alert(json.errors.join('\n'));
      }
    };
    loginRow.addEventListener('click', function(e) {
      var network, url;
      if (Ti.App.Properties.getBool('is_logged_in')) {
        network = new Network({
          success: _logOut
        });
        url = "" + GLOBAL.API_URL + "/sessions";
        network.request('DELETE', url, {
          auth_token: GLOBAL.user.auth_token
        });
      } else {
        Ti.Platform.openURL("http://" + GLOBAL.HOST + "/auth/facebook");
      }
    });
    window.addEventListener('focus', function(e) {
      _updateRowTitle();
    });
    window.addEventListener('loggedIn', function(e) {
      _updateRowTitle();
    });
    return window;
  };

  module.exports = createWindow;

}).call(this);
