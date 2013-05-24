createWindow = (tab) ->
  Network = require 'js/lib/Network'
  GLOBAL = require 'js/lib/global'

# UI

  window = Titanium.UI.createWindow
    title: 'Login'

  tableView = Ti.UI.createTableView
    style: Ti.UI.iPhone.TableViewStyle.GROUPED
    rowHeight: 44  
  window.add(tableView)

  loginRow = Ti.UI.createTableViewRow
    title: 'Login via Facebook'
    color: 'green'

  tableView.setData [loginRow]

# Functions

  _updateRowTitle = ()->
    if Ti.App.Properties.getBool 'is_logged_in'
      loginRow.title = 'Logout'
      loginRow.color = 'red'
    else
      loginRow.title = 'Login via Facebook'
      loginRow.color = 'green'
    return

  _logOut = (status, json)->
    if status
      Ti.App.Properties.setBool 'is_logged_in', false
      _updateRowTitle()
    else
      alert json.errors.join('\n')
    return

# Eventlisters

  loginRow.addEventListener 'click',(e) ->
    if Ti.App.Properties.getBool 'is_logged_in'
      network = new Network({
        success: _logOut
        })
      url = "#{GLOBAL.API_URL}/sessions"
      network.request 'DELETE', url, {auth_token: GLOBAL.user.auth_token}      
    else
      Ti.Platform.openURL("http://#{GLOBAL.HOST}/auth/facebook")
    return

  window.addEventListener 'focus', (e) ->
    _updateRowTitle()
    return

  window.addEventListener 'loggedIn', (e) ->
    _updateRowTitle()
    return

  return window

module.exports = createWindow