'use strict'

initialize = (config) ->
  angular
    .module 'app.views'
    .config config

### @ngInject ###
config = ($stateProvider) ->
  $stateProvider
    .state 'index',
      url: '/'
      templateUrl: 'views/index/index.html'

initialize config
