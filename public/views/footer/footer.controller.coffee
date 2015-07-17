'use strict'

initialize = (controller) ->
  angular
    .module 'app.views'
    .controller 'FooterController', controller

### @ngInject ###
controller = (Translation) ->
  translate = (lang) ->
    Translation.set(lang)

  vm = @
  vm.translate = translate
  return

initialize controller
