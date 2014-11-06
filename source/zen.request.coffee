"use strict"

ZEN.request = do ->

  _interval = undefined

  _get = ->
    do _values
    # _interval = setInterval _values, 60000


  _values = ->
    ZEN.proxy("GET", "#{ZEN.url()}/request/#{ZEN.instance.date}").then (error, response) ->
      total =
        latence   : []
        requests  : {}
        bandWidth : {}
        agents    : {}
        browsers  : {}
        devices   : {}
        os        : {}
        url_ok    : {}
        url_error : {}
        url_403   : {}
        methods   : {}
        codes     : {}
        uniques   : {}
        types     : {}

      sum =
        latence   : 0
        requests  : 0
        bandwidth : 0

      for request in response
        request = JSON.parse(request)
        # Latence
        date = new Date(request.at)
        utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())
        total.latence.push [utc, request.ms]
        sum.latence += request.ms
        # Number of requests per second
        ZEN.count total.requests, moment(date).format("YYYY/MM/DD HH:mm:ss")
        # Bytes per minute
        ZEN.count total.bandWidth, moment(date).format("YYYY/MM/DD HH:mm"), (request.size / 1024)
        sum.bandwidth += (request.size / 1024)
        # Endpoints
        if request.code < 300
          ZEN.count total.url_ok, request.url
        if request.code >= 400
          unless request.code is 403
            ZEN.count total.url_error, request.url
          else
            ZEN.count total.url_403, request.url

        # Types
        ZEN.count total.types, request.type.split("/")[1] if request.type?
        # Methods
        ZEN.count total.methods, request.method
        # codes
        ZEN.count total.codes, request.code
        # Agent
        if request.agent
          ua = ZEN.ua.setUA(request.agent).getResult()
          ZEN.count total.browsers, ua.browser.name
          ZEN.count total.devices, ua.device.type
          ZEN.count total.os, ZEN.parseOS ua.os
          #Uniques users
          ZEN.count total.uniques, "#{request.ip}|#{request.agent}}"

      # Agents
      ZEN.chart.pie "browsers", "Browser", total.browsers
      total.devices.laptop = total.devices["undefined"]
      delete total.devices["undefined"]
      ZEN.chart.pie "devices", "DEVICE", total.devices
      ZEN.chart.pie "os", "OS", total.os
      # Responses
      ZEN.chart.pie "url_ok", "SUCCESS", total.url_ok
      ZEN.chart.pie "url_error", "ERROR", total.url_error
      ZEN.chart.pie "methods", "METHODS", total.methods
      ZEN.chart.pie "codes", "CODES", total.codes
      ZEN.chart.pie "url_403", "403", total.url_403
      delete total.types["undefined"]
      ZEN.chart.pie "mime", "MIME-TYPE", total.types

      # Averages
      ZEN.chart.value "request-latence", "Requests", "Latence", parseInt(sum.latence / response.length), "ms"
      ZEN.chart.value "request-requests", "Requests", "Total", response.length
      ZEN.chart.value "request-bandwidth", "Requests", "Bandwidth", parseInt(sum.bandwidth / 1024), "mb"
      ZEN.chart.value "request-users", "Requests", "Users", Object.keys(total.uniques).length, "uniques"

      # Requests
      $("[data-zen=request]").highcharts
        chart:
          type    : 'spline'
          zoomType: 'x'
        title: text: "Requests"
        xAxis:
          type: 'datetime'
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
            format: '{value} kb'
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
        series: [
          type: 'spline'
          name: 'Latence'
          data: total.latence
          tooltip: valueSuffix: ' ms'
          yAxis: 0
        ,
          type: 'spline'
          name: 'Requests'
          data: ZEN.utc total.requests
          tooltip: valueSuffix: '/sec'
          marker: enabled: false
          yAxis: 1
        ,
          type: 'column'
          name: 'bandwidth'
          data: ZEN.utc total.bandWidth
          tooltip: valueSuffix: ' kb/min', valueDecimals: 0
          marker: enabled: false
          yAxis: 2
        ]

  # -- return module reliable --------------------------------------------------
  get: _get
