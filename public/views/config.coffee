'use strict'

initialize = (run) ->
  angular
    .module 'app.views'
    .run run

STATES_WITH_AUTH = [
]

### @ngInject ###
run = ($rootScope, $, Translation, Authentication, Loading) ->
  Translation.init()
  Authentication.init STATES_WITH_AUTH
  Loading.init()
  return

initialize run
