utils = require 'js/lib/utils'

class Network
  constructor: (option) ->
    _success = option.success || ()-> return
    # _error = option.error || (status, errors)-> console.log "#{status}:#{errors.join(',')}"; return
    _error = option.error || (status, errors)-> console.log "#{status}:#{errors}"; return
    _progress = option.progress || ()-> return
    _onreadystatechange = option.onreadystatechange || ()-> return

    @indicator = option.indicator || {
      show: ()-> return
      hide: ()-> return
    }

    _responseToObject = (that)->
      data = null
      contentType = that.xhr.getResponseHeader('Content-Type')
      if contentType.indexOf('application/json') is 0
        data = JSON.parse(this.responseText)
      else if contentType.indexOf('application/xml') is 0
        data = {xml: this.responseXML}
      else if contentType.indexOf('text') is 0
        data =  {text: this.responseText}
      else
        data =  {data: this.responseData}
      return data

    @xhr = Ti.Network.createHTTPClient()
    @xhr.setTimeout 10000
        
    # status code 200 ~ 399
    @xhr.onload = ()->
      try
        status_code = that.xhr.status
        if status_code isnt 204
          _success status_code, _responseToObject.call(this, that)
        else
          _success status_code, {}
      catch err
        console.log err
        _error null, {success: false, errors: [err.message]}
      finally
        that.indicator.hide()
        that.release()
      return
      
    # status code 400 ~ , network error, timeout.. 
    @xhr.onerror = (e)->
      console.log e.error
      if e.error is 'HTTP error'
        try
          _error that.xhr.status, _responseToObject.call(this, that)
        catch err
          console.log err
          _error null, {success: false, errors: [err.message]}
        finally
          that.indicator.hide()
          that.release()
      else
        _error null, {success: false, errors: [e.error]}
      return
      
    @xhr.ondatastream = (e)-> 
      _progress.call this, e
      return
      
    @xhr.onreadystatechange = (e)-> 
      _onreadystatechange.call this, e
      return

    that = this    
    return
  
  requestGet: (url, data)->
    @xhr.open 'GET', utils.createGetReguestUrl(url, data)
    @xhr.send()
    return

  requestPost: (url, data, method)->
    @xhr.open 'POST', url
    if method isnt 'POST'
      @xhr.setRequestHeader("X-Http-Method-Override", method)
    @xhr.setRequestHeader("Content-Type", "application/json")
    @xhr.send(JSON.stringify data)
    return

  requestUpload: (url, data)->
    @xhr.open 'POST', url
    @xhr.send(data)
    return
  
  requestDownload: (url, path)->
    @xhr.setTimeout 30000
    file = Titanium.Filesystem.getFile path
    if !file.exists()
      @xhr.open 'GET', url, false
      @xhr.setFile path
      @xhr.send()
    return

  request: (method, url, data)->
    if !Ti.Network.online
      @release()
      alert 'Network is not connected.'
      return
    @indicator.show()

    switch method
      when 'POST', 'PUT', 'DELETE'
        @requestPost url, data, method
      when 'UPLOAD'
        @requestUpload url, data
      when 'DOWNLOAD'
        @requestDownload url, path
      else
        @requestGet url, data
    return

  release: ()->
    @xhr.onload = null
    @xhr.onerror = null
    @xhr.ondatastream = null
    @xhr.onreadystatechange = null
    @xhr = null
    return
  
  disconnect: ()->
    @xhr.abort()
    @release()
    @indicator.hide()
    return

module.exports = Network