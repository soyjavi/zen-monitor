"use strict"

ZEN.value = (container, title, value, suffix) ->
  $("[data-zen=#{container}]").html """
    <label>#{title}</label>
    <h1>#{value}</h1>
    <small>#{suffix}</small>
  """
