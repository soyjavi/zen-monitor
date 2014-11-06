"use strict"

ZEN.chart = do ->

  _pie = (container, title, values) ->
    $("[data-zen=#{container}").highcharts
      chart:
        plotBorderWidth: 0
        plotShadow: false
      title:
        text          : title
        align         : 'center'
        verticalAlign : 'middle'
        y             : 26
      tooltip: pointFormat: "<b>{point.percentage:.1f}%</b>"
      plotOptions:
        pie:
          dataLabels:
            enabled: true
            distance: 8
          startAngle: -135
          endAngle: 135
          center: [
            "50%"
            "60%"
          ]
      series: [
        type: "pie"
        innerSize: "50%"
        data: ([key, value] for key, value of values)
      ]

  _value = (container, title, subtitle, value, suffix) ->
    html = ""
    html += "<h1>#{title}</h1>" if title?
    html += "<h2>#{subtitle}</h2>" if subtitle?
    html += "<strong>#{value}</strong>" if value?
    html += "<small>#{suffix}</small>" if suffix?
    $("[data-zen=#{container}]").html html


  # -- return module reliable --------------------------------------------------
  pie   : _pie
  value : _value
