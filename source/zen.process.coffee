"use strict"

ZEN.process = do ->

  _get = ->
    do _values
    _interval = setInterval _values, 300000

  _values = ->
    ZEN.proxy("GET", "#{ZEN.url()}/server/#{ZEN.instance.date}").then (error, response) ->
      total = []
      free = []
      average = []

      for process in response
        process = JSON.parse(process)
        date = new Date(process.at)
        utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())

        total.push [utc, process.memtotal]
        free.push [utc, process.system.freemem]
        average.push [utc, process.system.loadavg[0]]

      ZEN.chart.value "instance-total", "Memory", "Total", parseInt(process.memtotal), "mb"
      ZEN.chart.value "instance-free", "Memory", "Free", parseInt(process.system.freemem), "mb"
      ZEN.chart.value "instance-load", "Memory", "Average", process.system.loadavg[0].toFixed(2), "%"

      uptime = parseInt process.uptime / 60
      unit = "minutes"
      if uptime >= 60
        uptime = parseInt uptime / 60
        unit = "hours"
      if uptime >= 60
        uptime = parseInt uptime / 24
        unit = "days"
      ZEN.chart.value "instance-uptime", "Uptime", "Instance", uptime, unit

      $("[data-zen=instance]").highcharts
        chart:
          type    : 'spline'
          zoomType: 'x'
        title: text: "Instance"
        xAxis:
          type: 'datetime'
          title: enabled: false, text: 'Date'
        yAxis: [
          title: enabled: false
          min: 0
          labels:
            format: '{value}mb'
            style: color: Highcharts.getOptions().colors[0]
        ,
          title: enabled: false
          min: 0
          labels:
            format: '{value}mb'
            style: color: Highcharts.getOptions().colors[1]
        ,
          title: enabled: false
          opposite: true
          min: 0
          labels:
            format: '{value}%'
            style: color: Highcharts.getOptions().colors[2]
        ]
        plotOptions:
          spline:
            lineWidth : 1
            states    : hover: lineWidth: 2
            marker    : enabled: false
        series: [
          name: 'Total'
          data: total
          tooltip: valueSuffix: ' mb', valueDecimals: 2
          yAxis: 0
        ,
          name: 'Free'
          data: free
          tooltip: valueSuffix: ' mb', valueDecimals: 2
          marker: enabled: false
          yAxis: 1

        ,
          name: 'Load Average'
          data: average
          tooltip: valueSuffix: '%', valueDecimals: 2
          marker: enabled: false
          yAxis: 2
        ]

  # -- return module reliable --------------------------------------------------
  get: _get
