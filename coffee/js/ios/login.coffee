createWindow = (tab) ->
  Network = require 'js/lib/Network'
  GLOBAL = require 'js/lib/global'
  utils = require 'js/lib/utils'

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

  authTokenRow = Ti.UI.createTableViewRow
    title: 'Get Auth Token'

  tableView.setData [loginRow, authTokenRow]

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

  _onSuccessGetAuthToken = (status, json)->
    if status
      Ti.App.Properties.setBool 'is_logged_in', true
      GLOBAL.user.auth_token = json.auth_token
      utils.saveUserData()
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

  authTokenRow.addEventListener 'click',(e) ->
    network = new Network({
      success: _onSuccessGetAuthToken
      })
    url = "#{GLOBAL.API_URL}/tests/get_auth_token"
    network.request 'GET', url 
    return

  window.addEventListener 'focus', (e) ->
    _updateRowTitle()
    return

  window.addEventListener 'loggedIn', (e) ->
    _updateRowTitle()
    return

  return window

module.exports = createWindow