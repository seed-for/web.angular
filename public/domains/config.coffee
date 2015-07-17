'use strict'

initialize = (run) ->
  angular
    .module 'app.domains'
    .run run

### @ngInject ###
run = (Restangular, Session, API_URL) ->
  Restangular.setBaseUrl API_URL

  Restangular.addFullRequestInterceptor (e, o, w, u, headers) ->
    token = Session.token()

    headers['Authorization'] = 'Bearer ' + token if token

    headers: headers

  Restangular.addResponseInterceptor (data, o, w, u, response, d) ->
    token = response.headers('Auth-Token')

    Session.token(token) if token

    data.data

  Restangular.setErrorInterceptor (response, deferred) ->
    return true unless response.data?.error?

    error = response.data.error
    error.status = response.status

    deferred.reject error

    false
  return

initialize run
