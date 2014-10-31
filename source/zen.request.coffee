"use strict"

$ ->
  ZEN.proxy("GET", "#{ZEN.url}/request/#{ZEN.date}").then (error, response) ->
    # console.log "REQUESTS", response.length
    latence = []
    requests = {}
    bandWidth = {}
    agents = {}
    browsers = {}
    devices = {}
    os = {}
    urls = {}
    methods = {}
    codes = {}
    uniques = {}

    sum =
      latence   : 0
      requests  : 0
      bandwidth : 0

    for request in response
      request = JSON.parse(request)
      # Latence
      date = new Date(request.at)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())
      latence.push [utc, request.ms]
      sum.latence += request.ms
      # Number of requests per second
      ZEN.count requests, moment(date).format("YYYY/MM/DD HH:mm:ss")
      # Bytes per minute
      ZEN.count bandWidth, moment(date).format("YYYY/MM/DD HH:mm"), request.size
      sum.bandwidth += request.size
      # Endpoints
      ZEN.count urls, request.url
      # Types
      ZEN.count methods, request.method
      # codes
      ZEN.count codes, request.code
      # Agent
      if request.agent
        ua = ZEN.ua.setUA(request.agent).getResult()
        ZEN.count browsers, ua.browser.name
        ZEN.count devices, ua.device.type
        ZEN.count os, (if ua.os.version then "#{ua.os.name} #{ua.os.version}" else ua.os.name)
        #Uniques users
        ZEN.count uniques, "#{request.ip}|#{request.agent}}"

    # Agents
    ZEN.pie "browsers", "Browser", browsers
    ZEN.pie "devices", "Device", devices
    ZEN.pie "os", "OS", os
    ZEN.pie "urls", "URLs", urls
    # Agents
    ZEN.pie "methods", "METHODS", methods
    ZEN.pie "codes", "CODES", codes
    # Averages
    ZEN.value "request-latence", "Requests", "Latence", parseInt(sum.latence / response.length), "ms"
    ZEN.value "request-requests", "Requests", "Total", response.length
    ZEN.value "request-bandwidth", "Requests", "Bandwidth", parseInt(sum.bandwidth / response.length), "kb"
    ZEN.value "request-users", "Requests", "Users", Object.keys(uniques).length, "uniques"
    # Requests
    $("[data-zen=request]").highcharts
      chart:
        type    : 'spline'
        zoomType: 'x'
      title: text: "Requests"
      subtitle: text: ZEN.url
      xAxis:
        type: 'datetime'
        # minRange: 1 * 3600000  # 2 hour
        title: enabled: false, text: 'Date'
      yAxis: [
        title: enabled: false
        min: 0
        labels:
          format: '{value} ms'
          style: color: Highcharts.getOptions().colors[0]
      ,
        title: enabled: false
        opposite: true
        min: 0
        labels:
          format: '{value}/s'
          style: color: Highcharts.getOptions().colors[1]
      ,
        title: enabled: false
        opposite: true
        min: 0
        labels:
          style: color: Highcharts.getOptions().colors[2]
      ]
      legend: enabled: true
      plotOptions:
        spline:
          lineWidth : 1
          states    : hover: lineWidth: 2
          marker    : enabled: false
        column:
          pointPadding: 0.2
          borderWidth: 0
        area:
          lineWidth: 1
          states: hover: lineWidth: 1
          threshold: null
      # tooltip:
      #   # headerFormat: '<b>{series.name}</b><br>',
      #   headerFormat: '<b>http://</b><br>'
      #   pointFormat: '{point.x:%e. %b}: {point.y:.0f}ms'
      series: [
        type: 'spline'
        name: 'Latence'
        # pointInterval: 24 * 3600 * 1000
        data: latence
        tooltip: valueSuffix: ' ms'
        yAxis: 0
      ,
        type: 'spline'
        name: 'Requests'
        # dashStyle: 'shortdot'
        # pointInterval: 24 * 3600 * 1000
        data: ZEN.utc requests
        tooltip: valueSuffix: '/sec'
        marker: enabled: false
        yAxis: 1
      ,
        type: 'column'
        name: 'bandwidth'
        data: ZEN.utc bandWidth
        tooltip: valueSuffix: ' bytes/min'
        marker: enabled: false
        yAxis: 2
      ]
