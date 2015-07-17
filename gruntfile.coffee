'use strict'

AWS = require 'aws-sdk'

config = require './config'
credentials = new AWS.SharedIniFileCredentials profile: config.aws.profile

S3_OPTIONS =
  accessKeyId: credentials.accessKeyId
  secretAccessKey: credentials.secretAccessKey
  region: config.aws.region
  uploadConcurrency: 5,
  downloadConcurrency: 5

S3_STAGING_OPTIONS =
  bucket: config.aws.buckets.staging
  differential: true
  params:
    'CacheControl': 'max-age=3600, must-revalidate'

S3_PRODUCTION_OPTIONS =
  bucket: config.aws.buckets.production
  differential: true
  params:
    'CacheControl': 'max-age=31536000, must-revalidate'

S3_FILES = [
  action: 'delete'
  cwd: 'dist'
  dest: '/'
,
  action: 'upload'
  expand: true
  cwd: 'dist'
  src: ['**/*', '!index.html']
  dest: '/'
,
  action: 'upload'
  expand: true
  cwd: 'dist'
  src: ['index.html']
  dest: '/'
  params:
    'CacheControl': 'max-age=60, must-revalidate'
]

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    'aws_s3':
      options: S3_OPTIONS
      staging:
        options: S3_STAGING_OPTIONS
        files: S3_FILES
      production:
        options: S3_PRODUCTION_OPTIONS
        files: S3_FILES

  grunt.registerTask 'default', ->
