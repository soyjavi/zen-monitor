"use strict"

ZEN.storage = do ->

  KEY = "zen"

  _get = ->
    JSON.parse window.localStorage.getItem KEY

  _set = (instance) ->
    window.localStorage.setItem KEY, JSON.stringify instance

  get: _get
  set: _set
