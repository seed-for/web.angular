'use strict'

TITLE = 'TITLE'
DESCRIPTION = 'DESCRIPTION'
DOMAIN = 'SEED.IO'
GA_CODE = 'GA'
AWS_PROFILE = 'SEED'
AWS_REGION = 'REGION'
S3_BUCKET_STAGING = 'SEED-STAGING'
S3_BUCKET_PRODUCTION = 'SEED-PRODUCTION'
LOGO = 'LOGO.PNG'

IP = process.env.IP || 'localhost'

module.exports =
  ports:
    server: 7999
    proxy: 8000
    ui: 8001
  tokens:
    development:
      global:
        TITLE: TITLE
        DESCRIPTION: DESCRIPTION
        WEB_URL: "http://#{IP}:8000"
        LOGO_URL: "http://#{IP}:8000/#{LOGO}"
        API_URL: "http://#{IP}:9000"
        FILES_URL: "http://#{IP}:9000"
        USE_GA: false
        GA_CODE: ''
    staging:
      global:
        TITLE: TITLE
        DESCRIPTION: DESCRIPTION
        WEB_URL: "https://staging.#{DOMAIN}"
        LOGO_URL: "https://staging.#{DOMAIN}/#{LOGO}"
        API_URL: "https://staging.api.#{DOMAIN}"
        FILES_URL: "https://staging.files.#{DOMAIN}"
        USE_GA: false
        GA_CODE: ''
    production:
      global:
        TITLE: TITLE
        DESCRIPTION: DESCRIPTION
        WEB_URL: "https://#{DOMAIN}"
        LOGO_URL: "https://#{DOMAIN}/#{LOGO}"
        API_URL: "https://api.#{DOMAIN}"
        FILES_URL: "https://files.#{DOMAIN}"
        USE_GA: true
        GA_CODE: GA_CODE
  aws:
    profile: AWS_PROFILE
    region: AWS_REGION
    buckets:
      staging: S3_BUCKET_STAGING
      production: S3_BUCKET_PRODUCTION
