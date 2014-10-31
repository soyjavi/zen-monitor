"use strict"

window.ZEN = ZEN =

  url : "http://localhost:1337/monitor/my_P4ssw0rd"
  date: "20141031"
  count : (object, key, value = 1) ->
    object[key] = if object[key] then (object[key] + value) else value

  utc : (object) ->
    values = []
    for key, value of object
      date = new Date(key)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())
      values.push [utc, value]
    values

  ua: new UAParser()

$ ->
  $(".gridster ul").gridster
    widget_margins        : [10, 10]
    widget_base_dimensions: [140, 140]
