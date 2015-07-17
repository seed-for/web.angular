'use strict'

initialize = (factory) ->
  angular
    .module 'app.core'
    .factory 'Session', factory

KEY = 'SESSION'

### @ngInject ###
factory = ($rootScope, Storage, Q) ->
  session = Storage.get(KEY) or {}

  publish = (me) ->
    $rootScope.$emit 'authentication', me

  get = (key) -> session[key]

  set = (key, value) ->
    session[key] = value
    Storage.set KEY, session

  clear = ->
    session = {}
    Storage.set KEY, session
    publish null

  token: (token) ->
    if token?
      set 'token', token
    else
      get 'token'
  me: (me) ->
    if me?
      set 'me', me
      publish me
    else
      get 'me'
  clear: clear

initialize factory
