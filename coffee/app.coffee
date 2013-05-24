GLOBAL = require 'js/lib/global'
utils = require 'js/lib/utils'

tab1 = Ti.UI.createTab  
  icon:'img/039-IM@2x.png',
  title:'Login'
tab2 = Ti.UI.createTab  
  icon:'img/108-Group@2x.png',
  title:'Push'
tab3 = Ti.UI.createTab  
  icon:'img/053-Search@2x.png',
  title:'Purchase'
tab4 = Ti.UI.createTab  
  icon:'img/082-Location@2x.png',
  title:'Upload'
tab5 = Ti.UI.createTab  
  icon:'img/082-Location@2x.png',
  title:'Request'

platform = Titanium.Platform.osname is 'android' && 'android' || 'ios'
tab1.window = (require "js/#{platform}/login")(tab1)
tab2.window = (require "js/#{platform}/push")(tab2)
tab3.window = (require "js/#{platform}/purchase")(tab3)
tab4.window = (require "js/#{platform}/upload")(tab4)
tab5.window = (require "js/#{platform}/request")(tab5)

tabGroup = Titanium.UI.createTabGroup()
tabGroup.addTab tab1
tabGroup.addTab tab2
tabGroup.addTab tab3
tabGroup.addTab tab4
tabGroup.addTab tab5

_beforeOpenAction = (params)->
  switch params.action
    when 'login'
      Ti.App.Properties.setBool 'is_logged_in', true
      GLOBAL.user.auth_token = params.auth_token
      utils.saveUserData()
      tab1.window.fireEvent "loggedIn"
  return

_openedByUrlScheme = ()->
  url = Ti.App.getArguments()['url']
  if url
    console.log url
    GLOBAL.LAST_URL_SCHEME = url
    params = utils.parseUrlScheme(url)
    _beforeOpenAction params
  return

Ti.App.addEventListener 'resumed', _openedByUrlScheme

_openedByUrlScheme()

tabGroup.open()
