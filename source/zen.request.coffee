"use strict"

$ ->
  ZEN.proxy("GET", "#{ZEN.url}/request/#{ZEN.date}").then (error, response) ->
    # console.log "REQUESTS", response.length
    latence = []
    requests = {}
    bandwitdh = {}
    agents = {}
    browsers = {}
    devices = {}
    os = {}
    urls = {}
    for request in response
      request = JSON.parse(request)

      # Latence
      date = new Date(request.at)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())
      latence.push [utc, request.ms]

      # Number of requests per second
      ZEN.count requests, moment(date).format("YYYY/MM/DD HH:mm:ss")
      # Bytes per minute
      ZEN.count bandwitdh, moment(date).format("YYYY/MM/DD HH:mm"), request.size

      # Endpoints
      ZEN.count urls, request.url

      # Agent
      if request.agent
        ua = ZEN.ua.setUA(request.agent).getResult()
        ZEN.count browsers, ua.browser.name
        ZEN.count devices, ua.device.type
        ZEN.count os, (if ua.os.version then "#{ua.os.name} #{ua.os.version}" else ua.os.name)

    # Requests
    ZEN.spline "request", "DAILY Requests", latence, (ZEN.utc requests), (ZEN.utc bandwitdh)

    # Agents
    ZEN.pie "browsers", "Browser", browsers
    ZEN.pie "devices", "Device", devices
    ZEN.pie "os", "OS", os

    ZEN.pie "urls", "URLs", urls
