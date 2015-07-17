'use strict'

initialize = (factory) ->
  angular
    .module 'app.core'
    .factory 'Authentication', factory

### @ngInject ###
factory = (_, $rootScope, Session, Base64) ->
  init: (states) ->
    $rootScope.$on '$stateChangeStart', (event, to, params) ->
      should_has_auth = _.some states, (state) ->
        to.name.indexOf(state) is 0
      me = Session.me()

      if should_has_auth and not me?
        event.preventDefault()
        # Do something

initialize factory
