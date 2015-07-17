'use strict'

TITLE = '{{TITLE}}'
WEB_URL = '{{WEB_URL}}'
API_URL = '{{API_URL}}'
FILES_URL = '{{FILES_URL}}'

DEFAULT_PROFILE_IMAGE = '/assets/profile.png'

PROFILE_PHOTO = (photo) ->
  if photo
    FILES_URL + '/files/' + photo
  else
    DEFAULT_PROFILE_IMAGE
FILE = (file) ->
  if file
    FILES_URL + '/files/' + file
  else
    undefined

angular
  .module 'app.core'
  .constant '_', _
  .constant 'Q', Promise
  .constant '$', $
  .constant 'Storage', simpleStorage
  .constant 'moment', moment
  .constant 'numeral', numeral
  .constant 'TITLE', TITLE
  .constant 'WEB_URL', WEB_URL
  .constant 'API_URL', API_URL
  .constant 'FILES_URL', FILES_URL
  .constant 'PROFILE_PHOTO_URL', (photo) ->
    PROFILE_PHOTO photo
  .constant 'FILE_URL', (file) ->
    FILE file
  .constant 'FILE_URLS', (files) ->
    (FILE file for file in files)
