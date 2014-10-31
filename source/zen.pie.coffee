"use strict"

ZEN.pie = (container, title, values) ->
  $("[data-zen=#{container}").highcharts
    chart:
      plotBorderWidth: 0
      plotShadow: false
    title:
      text          : title
      align         : 'center'
      verticalAlign : 'middle'
      y             : 20
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
