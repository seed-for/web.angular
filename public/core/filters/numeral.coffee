'use strict'

initialize = (filter) ->
  angular
    .module 'app.core'
    .filter 'numeral', filter

### @ngInject ###
filter = (numeral) ->
  (value, format) ->
    format ?= '0.0'
    numeral(value).format(format)

initialize filter
