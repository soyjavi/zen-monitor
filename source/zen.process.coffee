"use strict"

$ ->
  ZEN.proxy("GET", "#{ZEN.url}/server/#{ZEN.date}").then (error, response) ->
    total = []
    free = []
    average = []

    avgtotal = 0
    avgfree = 0
    avgload = 0

    for process in response
      process = JSON.parse(process)
      # console.log process.pid, process.arch, process.platform, process.uptime
      date = new Date(process.at)
      utc = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())

      total.push [utc, process.memtotal]
      avgtotal += process.memtotal
      free.push [utc, process.system.freemem]
      avgfree += process.system.freemem
      average.push [utc, process.system.loadavg[0]]
      avgload += process.system.loadavg[0]

    ZEN.value "instance-total", "Memory", "Total", parseInt(avgtotal / response.length), "mb"
    ZEN.value "instance-free", "Memory", "Free", parseInt(avgfree / response.length), "mb"
    ZEN.value "instance-load", "Memory", "Average", parseInt(avgload / response.length), "mb"
    uptime = parseInt process.uptime / 60
    unit = "minutes"
    if uptime >= 60
      uptime = uptime / 60
      unit = "hours"
    if uptime >= 60
      uptime = uptime / 24
      unit = "days"
    ZEN.value "instance-uptime", "Uptime", "Instance", uptime, unit

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
        tooltip: valueSuffix: ' mb'
        yAxis: 0
      ,
        name: 'Free'
        data: free
        tooltip: valueSuffix: ' mb'
        marker: enabled: false
        yAxis: 1

      ,
        name: 'Load Average'
        data: average
        tooltip: valueSuffix: '%'
        marker: enabled: false
        yAxis: 2
      ]
