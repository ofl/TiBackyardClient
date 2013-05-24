createWindow = (tab) ->
  Network = require 'js/lib/Network'
  GLOBAL = require 'js/lib/global'

# UI

  window = Titanium.UI.createWindow
    title: 'Request'

  navActInd = Titanium.UI.createActivityIndicator()
  window.setRightNavButton(navActInd)

  tableView = Ti.UI.createTableView
    style: Ti.UI.iPhone.TableViewStyle.GROUPED
    rowHeight: 44  
  window.add(tableView)

  rows = []

  rows.push Ti.UI.createTableViewRow
    title: 'GET'
    url: "#{GLOBAL.API_URL}/tests"
    data: {auth_token: GLOBAL.user.auth_token}

  rows.push Ti.UI.createTableViewRow
    title: 'POST'
    url: "#{GLOBAL.API_URL}/tests"
    data: {auth_token: GLOBAL.user.auth_token, test: {array:[1,2,3], foo: {bar: 'baz'}}}
    method: 'POST'

  rows.push Ti.UI.createTableViewRow
    title: 'PUT'
    url: "#{GLOBAL.API_URL}/tests/1"
    data: {auth_token: GLOBAL.user.auth_token}
    method: 'PUT'

  rows.push Ti.UI.createTableViewRow
    title: 'DELETE'
    url: "#{GLOBAL.API_URL}/tests/1"
    data: {auth_token: GLOBAL.user.auth_token}
    method: 'DELETE'

  rows.push Ti.UI.createTableViewRow
    title: 'Render Nothing'
    url: "#{GLOBAL.API_URL}/tests/1/edit"
    data: {auth_token: GLOBAL.user.auth_token}

  rows.push Ti.UI.createTableViewRow
    title: 'Forbidden'
    url: "#{GLOBAL.API_URL}/tests"
    data: {}

  rows.push Ti.UI.createTableViewRow
    title: 'Record Not Found'
    url: "#{GLOBAL.API_URL}/tests"
    data: {status: 404, auth_token: GLOBAL.user.auth_token}

  rows.push Ti.UI.createTableViewRow
    title: 'Time out'
    url: "#{GLOBAL.API_URL}/tests"
    data: {status: 408, auth_token: GLOBAL.user.auth_token}

  rows.push Ti.UI.createTableViewRow
    title: 'XML'
    url: "#{GLOBAL.API_URL}/tests"
    data: {status: 415, auth_token: GLOBAL.user.auth_token}

  rows.push Ti.UI.createTableViewRow
    title: 'Internal Server Error'
    url: "#{GLOBAL.API_URL}/tests"
    data: {status: 500, auth_token: GLOBAL.user.auth_token}

  rows.push Ti.UI.createTableViewRow
    title: 'Redirect'
    url: "#{GLOBAL.API_URL}/tests"
    data: {status: 302, auth_token: GLOBAL.user.auth_token}

  rows.push Ti.UI.createTableViewRow
    title: 'Server Not Found'
    url: "http://www.daadadadada.com"

  tableView.setData rows

# Functions

  _onSuccess = (status, hash)->
    console.log "status: #{status}\n method: #{hash.method}\n success: #{hash.success}\n message:  #{hash.message}"
    return

  _onError = (status, hash)->
    console.log "status: #{status}\n method: #{hash.method}\n success: #{hash.success}\n errors:  #{hash.errors}"
    return

# Eventlisters

  tableView.addEventListener 'click',(e) ->
    method = e.row.method || "GET"
    network = new Network({
      success: _onSuccess
      error: _onError
      indicator: navActInd
      })
    network.request method, e.row.url, e.row.data    
    return

  return window

module.exports = createWindow