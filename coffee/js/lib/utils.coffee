GLOBAL = require 'js/lib/global'
thisYear = (new Date()).getYear()

exports.formatDate = (date_string)->
  datetime = new Date(Date.parse(date_string))
  time = String.format("%02.0f:%02.0f", datetime.getHours(), datetime.getMinutes()) # ex. 21:00

  day = GLOBAL.WEEK[datetime.getDay()]
  year = datetime.getFullYear()
  month = datetime.getMonth() + 1
  date = datetime.getDate()
  if datetime.getYear() isnt thisYear
    format_str = "#{year}年#{month}月#{date}日 (#{day})"
  else
    format_str = "#{month}月#{date}日 (#{day}) #{time}"    
  return format_str

exports.toRailsDate = (datetime)->
  year = datetime.getFullYear()
  month = datetime.getMonth() + 1
  date = datetime.getDate()
  hour = datetime.getHours()
  minute = datetime.getMinutes()

  return String.format("%02.0f-%02.0f-%02.0fT%02.0f:%02.0f:00+09:00", year, month, date,hour, minute) # ex. 2013-11-21T06:00:00+09:00

exports.parseUrlScheme = (url)->
  str = url.replace("#{GLOBAL.APP_URL_SCHEME}",'')
  str.match(/(.+?)\?(.*)/)
  action = RegExp.$1
  array = RegExp.$2.split '&'
  obj = {action: action}
  for key_value_str in array
    key_value_array = key_value_str.split '='
    if key_value_array.length = 2
      obj[key_value_array[0]] =  decodeURIComponent key_value_array[1]
  return obj

exports.encodeQueryData = (data)->
  ret = []
  for k,v of data
    ret.push(encodeURIComponent(k) + "=" + encodeURIComponent(v))
  return ret.join("&")

exports.createGetReguestUrl = (url, data)->
  if data
    url = url + "?" + exports.encodeQueryData(data)
  return url

exports.saveUserData = ()->
  Ti.App.Properties.setString 'user', JSON.stringify(GLOBAL.user)
  return