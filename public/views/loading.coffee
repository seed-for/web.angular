'use strict'

initialize = (factory) ->
  angular
    .module 'app.views'
    .factory 'Loading', factory

### @ngInject ###
factory = ($) ->
  init: () ->
    loading = $ '.loading-container'
    loading.hide()

initialize factory
