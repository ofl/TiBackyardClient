utils = require 'js/lib/utils'

class Network
  constructor: (option) ->
    _success = option.success || ()-> return
    _error = option.error || (status, errors)-> console.log "#{status}:#{errors.join(',')}"; return
    _progress = option.progress || ()-> return
    _onreadystatechange = option.onreadystatechange || ()-> return

    @indicator = option.indicator || {
      show: ()-> return
      hide: ()-> return
    }

    @xhr = Ti.Network.createHTTPClient()
    @xhr.setTimeout 10000
        
    # status code 200 ~ 399
    @xhr.onload = ()->
      try
        status_code = that.xhr.status
        console.log this.responseText
        if status_code isnt 204
          _success status_code, JSON.parse(this.responseText)
        else
          _success status_code, {}
      catch e
        console.log this.responseText
        _error null, {success: false, errors: ['Json parse error.']}
      finally
        that.indicator.hide()
        that.release()
      return
      
    # status code 400 ~ , network error, timeout.. 
    @xhr.onerror = (e)->
      try
        status_code = that.xhr.status
        if status_code
          json = JSON.parse(this.responseText)
        else
          json = {success: false, errors: ['Network Error.']}
        _error status_code, json
      catch e 
        console.log this.responseText
        _error null, {success: false, errors: ['Json parse error.']}
      finally
        that.indicator.hide()
        that.release()
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
    @xhr.setRequestHeader("content-type", "application/json")
    @xhr.send(JSON.stringify data)
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