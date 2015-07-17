'use strict'

initialize = (directive) ->
  angular
    .module 'app.core'
    .directive 'ngxEnter', directive

### @ngInject ###
directive = ->
  link: (scope, element, attrs) ->
    element.bind 'keypress', (event) ->
      if event.which is 13
        scope.$apply ->
          scope.$eval attrs.ngxEnter
        event.preventDefault()

initialize directive
