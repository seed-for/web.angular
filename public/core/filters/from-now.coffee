'use strict'

initialize = (filter) ->
  angular
    .module 'app.core'
    .filter 'fromNow', filter

### @ngInject ###
filter = (moment) ->
  (timestamp) ->
    moment(timestamp).fromNow()

initialize filter
