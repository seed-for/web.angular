'use strict'

initialize = (controller) ->
  angular
    .module 'app.views'
    .controller 'HeaderController', controller

### @ngInject ###
controller = () ->
  vm = @
  return

initialize controller
