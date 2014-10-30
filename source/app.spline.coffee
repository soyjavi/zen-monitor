"use strict"

ZEN.spline = (container, title, latence, requests, bandwidth) ->
  $("[data-zen=#{container}]").highcharts
    chart:
      type    : 'spline'
      zoomType: 'x'
    title: text: title
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
      data: requests
      tooltip: valueSuffix: '/sec'
      marker: enabled: false
      yAxis: 1
    ,
      type: 'column'
      name: 'bandwidth'
      data: bandwidth
      tooltip: valueSuffix: ' bytes/min'
      marker: enabled: false
      yAxis: 2
    ]

