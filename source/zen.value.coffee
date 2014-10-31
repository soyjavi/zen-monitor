"use strict"

ZEN.value = (container, title, subtitle, value, suffix) ->
  html = ""
  html += "<h1>#{title}</h1>" if title?
  html += "<h2>#{subtitle}</h2>" if subtitle?
  html += "<strong>#{value}</strong>" if value?
  html += "<small>#{suffix}</small>" if suffix?
  $("[data-zen=#{container}]").html html
