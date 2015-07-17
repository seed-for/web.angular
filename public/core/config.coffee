'use strict'

initialize = (config) ->
  angular
    .module 'app.core'
    .config config

### @ngInject ###
config = ($compileProvider,
          $httpProvider,
          $locationProvider,
          $urlRouterProvider,
          $urlMatcherFactoryProvider) ->
  $compileProvider
    .aHrefSanitizationWhitelist /^\s*(https?|mailto|bagle):/
  $compileProvider.debugInfoEnabled false
  $httpProvider.useApplyAsync true
  $locationProvider
    .html5Mode true
    .hashPrefix '!'
  $urlRouterProvider.otherwise '/'
  $urlMatcherFactoryProvider.strictMode false

initialize config
