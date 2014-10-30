"use strict"

window.ZEN = ZEN = {}
ZEN.url = "http://localhost:1337/audit/my_P4ssw0rd/20141030"
$ ->
  parser = new UAParser()

  ZEN.count = (object, key, value = 1) ->
    object[key] = if object[key] then (object[key] + value) else value

  ZEN.utc = (object) ->
    values = []
    for key, value of object
      date = new Date(key)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())
      values.push [utc, value]
    values


  ZEN.proxy("GET", ZEN.url).then (error, response) ->
    console.log "REQUESTS", response.length
    latence = []
    requests = {}
    bandwitdh = {}
    agents = {}
    browsers = {}
    devices = {}
    os = {}
    urls = {}
    for audit in response
      audit = JSON.parse(audit)

      # Latence
      date = new Date(audit.at)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())
      latence.push [utc, audit.ms]

      # Number of requests per second
      ZEN.count requests, moment(date).format("YYYY/MM/DD HH:mm:ss")
      # Bytes per minute
      ZEN.count bandwitdh, moment(date).format("YYYY/MM/DD HH:mm"), audit.size

      # Endpoints
      ZEN.count urls, audit.url

      # Agent
      if audit.agent
        ua = parser.setUA(audit.agent).getResult()
        ZEN.count browsers, ua.browser.name
        ZEN.count devices, ua.device.type
        ZEN.count os, (if ua.os.version then "#{ua.os.name} #{ua.os.version}" else ua.os.name)

    # Requests
    ZEN.spline "requests", "DAILY Requests", latence, (ZEN.utc requests), (ZEN.utc bandwitdh)

    # Agents
    ZEN.pie "browsers", "Browser", browsers
    ZEN.pie "devices", "Device", devices
    ZEN.pie "os", "OS", os

    ZEN.pie "urls", "URLs", urls

