'use strict'

initialize = (run) ->
  angular
    .module 'app.core'
    .run run

### @ngInject ###
run = ($rootScope, Focus, TITLE) ->
  app =
    focus: Focus
    _title_: TITLE
    title: (title) ->
      if title?
        @_title_ = make title
      else
        @_title_

  make = (title) ->
    if title
      title + ' | ' + TITLE
    else
      TITLE

  $rootScope.app = app
  return

initialize run
