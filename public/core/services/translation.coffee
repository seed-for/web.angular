'use strict'

initialize = (factory) ->
  angular
    .module 'app.views'
    .factory 'Translation', factory

KEY = 'LANG'
DEFAULT_LANG = 'en'

### @ngInject ###
factory = ($window, Storage, gettextCatalog, moment) ->
  defaultLang = () ->
    lang =
      try
        navigator = $window.navigator
        languages = navigator.languages
        if languages? and languages.length
        then languages[0]
        else navigator.language or
          navigator.userLanguage or
          navigator.browserLanguage
      catch
        DEFAULT_LANG
    Storage.set KEY, lang
    lang

  get = -> Storage.get KEY
  set = (lang) ->
    Storage.set KEY, lang
    gettextCatalog.setCurrentLanguage lang
    moment.locale lang

  init = ->
    lang = get() or defaultLang()
    gettextCatalog.setCurrentLanguage lang
    moment.locale lang

  init: init
  get: get
  set: set

initialize factory
