'use strict'

initialize = (filter) ->
  angular
    .module 'app.core'
    .filter 'moment', filter

### @ngInject ###
filter = (moment) ->
  (timestamp, format) ->
    format ?= 'MMMM D, YYYY'
    moment(timestamp).format(format)

initialize filter
