"use strict"

window.ZEN = ZEN = do ->

  _count = (object, key, value = 1) ->
    object[key] = if object[key] then (object[key] + value) else value

  _parseOS = (os) ->
    parse = os.name
    parse += " " + os.version.split(".", 2).join(".") if os.version
    parse

  _proxy = (type, method, parameters = {}, background = false) ->
    promise = new Hope.Promise()
    # unless background then do __.Dialog.Loading.show
    $.ajax
      url         : "#{method}"
      type        : type
      data        : parameters
      dataType    : 'json'
      headers     : authorization: "jajajaja"
      success: (response, xhr) ->
        # unless background then do __.Dialog.Loading.hide
        promise.done null, response
      error: (xhr, error) =>
        # unless background then do __.Dialog.Loading.hide
        error = code: error.status, message: error.response
        console.error "__.proxy [ERROR #{error.code}]: #{error.message}"
        promise.done error, null
    promise

  _url = ->
    url = "#{ZEN.instance.host}"
    url += ":#{ZEN.instance.port}" if ZEN.instance.port
    url += "/monitor/#{ZEN.instance.password}"

  _utc = (object) ->
    values = []
    for key, value of object
      date = new Date(key)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())
      values.push [utc, value]
    values

  # -- return module reliable --------------------------------------------------
  version : "0.11.03"
  instance: {}
  url     : _url
  date    : moment().format("YYYYMMDD")
  count   : _count
  parseOS : _parseOS
  proxy   : _proxy
  utc     : _utc
  ua      : new UAParser()
