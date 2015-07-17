'use strict'

initialize = (factory) ->
  angular
    .module 'app.core'
    .factory 'Focus', factory

### @ngInject ###
factory = ($, $timeout) ->
  (selector) ->
    $timeout ->
      $(selector).focus()

initialize factory
