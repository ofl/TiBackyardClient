createWindow = (tab) ->
  Network = require 'js/lib/Network'
  GLOBAL = require 'js/lib/global'

  imageBlob = null


# UI

  window = Titanium.UI.createWindow
    title: 'Login'

  photoButton = Ti.UI.createButton
    systemButton: Titanium.UI.iPhone.SystemButton.CAMERA
  window.setRightNavButton photoButton

  tableView = Ti.UI.createTableView
    editable: true
    rowHeight: 50
  window.add(tableView)

# Functions

  _createRow = (data)->
    row = Ti.UI.createTableViewRow
      id: data.id
    row.add Ti.UI.createImageView
      image: data.url
      left: 1
      height: 48
      width: 48
    row.add Ti.UI.createLabel
      text: data.created_at
      left: 55
      width: 230
    return row

  _onSuccess = (status, hash)->
    console.log hash
    rows = []
    for image in hash.images
      rows.push _createRow(image)
    tableView.setData rows
    return

  _onSuccessDelete = (status, hash)->
    if status isnt 204
      alert 'Can not delete image.'
      _updateTable()
    return

  _onSuccessUploadImage = (status, hash)->
    return

  _onSuccessGetUploadParameters = (status, hash)->
    console.log hash
    network = new Network({success: _onSuccessUploadImage})
    hash.image.upload_parameters.fields['file'] = imageBlob
    network.request 'UPLOAD', hash.image.upload_parameters.url, hash.image.upload_parameters.fields
    return

  _onSuccessSelectImage = (event)->
    network = new Network({success: _onSuccessGetUploadParameters})
    network.request 'POST', "#{GLOBAL.API_URL}/images", {auth_token: GLOBAL.user.auth_token}
    return

  _updateTable = ()->
    network = new Network({success: _onSuccess})
    network.request 'GET', "#{GLOBAL.API_URL}/images", {auth_token: GLOBAL.user.auth_token}
    return

  _openPhotoGallery = ()->
    options =
      mediaTypes:[Ti.Media.MEDIA_TYPE_PHOTO]
      success: (e)=>
        if e.mediaType == Ti.Media.MEDIA_TYPE_PHOTO
          imageBlob = e.media.imageAsResized(96, 96)
          _onSuccessSelectImage()
        return        
      cancel: ()->
        return
      error: (e)->
        if !e.success and e.code is 1
          setTimeout _openPhotoGallery, 10
        else
          alert 'Error opening gallery'
        return
    Ti.Media.openPhotoGallery options
    return

# Eventlisters

  tableView.addEventListener 'delete',(e) ->
    network = new Network({success: _onSuccessDelete})
    network.request 'DELETE', "#{GLOBAL.API_URL}/images/#{e.row.id}", {auth_token: GLOBAL.user.auth_token}
    return

  window.addEventListener 'focus', (e) ->
    _updateTable()
    return

  photoButton.addEventListener 'click', (e) ->
    _openPhotoGallery()
    return

  return window

module.exports = createWindow