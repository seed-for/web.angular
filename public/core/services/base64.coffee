'use strict'

initialize = (factory) ->
  angular
    .module 'app.core'
    .factory 'Base64', factory

### @ngInject ###
factory = (base64) ->
  encode: (o) ->
    base64.urlencode JSON.stringify(o)
  decode: (s) ->
    JSON.parse base64.urldecode(s)

initialize factory
