createWindow = (tab) ->
  Network = require 'js/lib/Network'
  GLOBAL = require 'js/lib/global'

# UI

  window = Titanium.UI.createWindow
    title: 'Login'

  table = Ti.UI.createTableView
    style: Ti.UI.iPhone.TableViewStyle.GROUPED
    rowHeight: 44  
  window.add(table)

  row = Ti.UI.createTableViewRow
    title: 'Login via Facebook'
    color: 'green'

  table.setData [row]

# Functions

  _updateRowTitle = ()->
    if Ti.App.Properties.getBool 'is_logged_in'
      row.title = 'Logout'
      row.color = 'green'
    else
      row.title = 'Login via Facebook'
      row.color = 'red'
    return

# Eventlisters

  row.addEventListener 'click',(e) ->
    Ti.Platform.openURL("http://#{GLOBAL.HOST}/auth/facebook")
    return

  window.addEventListener 'focus', (e) ->
    _updateRowTitle()
    return

  return window

module.exports = createWindow