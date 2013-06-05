createWindow = (tab) ->
  Network = require 'js/lib/Network'
  GLOBAL = require 'js/lib/global'

# UI

  window = Titanium.UI.createWindow
    title: 'Push Notification'

  tableView = Ti.UI.createTableView
    style: Ti.UI.iPhone.TableViewStyle.GROUPED
    rowHeight: 44  
  window.add(tableView)

  row = Ti.UI.createTableViewRow
    title: 'Push Notification'

  tableView.setData [row]

# Functions

  _onSuccess = (status, hash)->
    if status isnt 204
      alert 'Can not send Push Notification'
    return


# Eventlisters

  row.addEventListener 'click',(e) ->
    network = new Network({success: _onSuccess})
    network.request 'POST', "#{GLOBAL.API_URL}/users/test_apns", {
      auth_token: GLOBAL.user.auth_token
    }
    return

  return window

module.exports = createWindow