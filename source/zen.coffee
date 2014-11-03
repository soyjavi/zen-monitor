"use strict"

window.ZEN = ZEN = do ->

  _count = (object, key, value = 1) ->
    object[key] = if object[key] then (object[key] + value) else value

  _proxy = (type, method, parameters = {}, background = false) ->
    promise = new Hope.Promise()
    # unless background then do __.Dialog.Loading.show
    $.ajax
      url         : "#{method}"
      type        : type
      data        : parameters
      # contentType : "application/x-www-form-urlencoded"
      dataType    : 'json'
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
    url += ":#{ZEN.intance.port}" if ZEN.instance.port
    url += "/monitor/#{ZEN.instance.password}/"

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
  proxy   : _proxy
  utc     : _utc
  ua      : new UAParser()

$ ->
  $(".gridster ul").gridster
    widget_margins        : [10, 10]
    widget_base_dimensions: [140, 140]
    draggable: handle: 'header'

  $("input[name=date]").val moment().format("YYYY-MM-DD")
  $("header > form > button").on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    ZEN.instance =
      host      : $("input[name=host]").val()
      port      : $("input[name=port]").val()
      password  : $("input[name=password]").val()
      date      : moment($("input[name=date]").val()).format("YYYYMMDD")

    if ZEN.instance.host and ZEN.instance.password and ZEN.instance.date
      ZEN.process.get()
      ZEN.request.get()
