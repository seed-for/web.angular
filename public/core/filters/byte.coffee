'use strict'

initialize = (filter) ->
  angular
    .module 'app.core'
    .filter 'byte', filter

### @ngInject ###
filter = (numeral) ->
  (value) ->
    if value <= 1024
      value + 'B'
    else if value <= 1024 * 1024
      numeral(value / 1024).format('0.0') + 'KB'
    else if value <= 1024 * 1024 * 1024
      numeral(value / (1024 * 1024)).format('0.0') + 'MB'
    else
      numeral(value / (1024 * 1024 * 1024)).format('0.0') + 'GB'

initialize filter
