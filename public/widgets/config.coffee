'use strict'

initialize = (run) ->
  angular
    .module 'app.widgets'
    .run run

### @ngInject ###
run = () ->
  return

initialize run
