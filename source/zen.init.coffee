"use strict"

$ ->

  ZEN.proxy("POST", "http://localhost:1337/api").then (error, response) ->
    console.log "POST", error, response

  $(".gridster ul").gridster
    widget_margins        : [10, 10]
    widget_base_dimensions: [140, 140]
    draggable: handle: 'header'

  $("input[name=date]").val moment().format("YYYY-MM-DD")
  $("header > form > button.connect").on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    ZEN.instance =
      host      : $("input[name=host]").val()
      port      : $("input[name=port]").val()
      password  : $("input[name=password]").val()
      date      : moment($("input[name=date]").val()).format("YYYYMMDD")

    if ZEN.instance.host and ZEN.instance.password and ZEN.instance.date
      $(document.body).removeClass "landing"
      ZEN.process.get()
      ZEN.request.get()
  $("header > form > button.connect").on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
      $(document.body).addClass "landing"
