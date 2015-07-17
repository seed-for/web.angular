'use strict'

initialize = (factory) ->
  angular
    .module 'app.core'
    .factory 'State', factory

class State
  constructor: (@state = 'ready') ->
  get: ->
    @state
  set: (state) ->
    @state = state
  is: (state) ->
    @state is state

### @ngInject ###
factory = -> State

initialize factory
