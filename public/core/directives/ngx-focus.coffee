'use strict'

initialize = (directive) ->
  angular
    .module 'app.core'
    .directive 'ngxFocus', directive

### @ngInject ###
directive = ($timeout) ->
  link: (scope, element, attrs) ->
    $timeout ->
      element.focus()

initialize directive
