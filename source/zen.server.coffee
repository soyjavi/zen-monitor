"use strict"

$ ->

  ZEN.proxy("GET", "#{ZEN.url}/server/#{ZEN.date}").then (error, response) ->

    memtotal = []
    freemem = []
    loadavg = []


    for process in response
      process = JSON.parse(process)
      # console.log process.pid, process.arch, process.platform, process.uptime
      date = new Date(process.at)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())

      console.log process.system
      memtotal.push [utc, process.memtotal]
      freemem.push [utc, process.system.freemem]
      loadavg.push [utc, process.system.loadavg[0]]


    $("[data-zen=server]").highcharts
      chart:
        type    : 'spline'
        zoomType: 'x'
      title: text: "INSTANCE"
      subtitle: text: ZEN.url
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
        opposite: true
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
      series: [
        type: 'spline'
        name: 'Memory Total'
        data: memtotal
        tooltip: valueSuffix: ' mb'
        yAxis: 0
      ,
        type: 'spline'
        name: 'Free Memory'
        data: freemem
        tooltip: valueSuffix: ' mb'
        marker: enabled: false
        yAxis: 1

      ,
        type: 'spline'
        name: 'Load Average'
        data: loadavg
        tooltip: valueSuffix: '%'
        marker: enabled: false
        yAxis: 2
      ]
