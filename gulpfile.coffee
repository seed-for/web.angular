'use strict'

path = require 'path'
del = require 'del'
run = require 'run-sequence'
merge = (require 'event-stream').merge
series = require 'stream-series'
wiredep = (require 'wiredep').stream
browserSync = require 'browser-sync'

gulp = require 'gulp'
$ = (require 'gulp-load-plugins')
  lazy: true
  rename:
    'gulp-angular-templatecache': 'templateCache'
$.grunt gulp

config = require './config'
ENV = 'development'

# Main

gulp.task 'default', []

gulp.task 'env:staging', -> ENV = 'staging'
gulp.task 'env:production', -> ENV = 'production'

gulp.task 'serve', (done) ->
  run 'compile', 'launch', 'watch', done
gulp.task 'serve:staging', ['env:staging'], (done) ->
  run 'serve', done
gulp.task 'serve:production', ['env:production'], (done) ->
  run 'serve', done
gulp.task 'serve-dist', (done) ->
  run 'build', 'launch-dist', 'watch-dist', done
gulp.task 'serve-dist:staging', ['env:staging'], (done) ->
  run 'serve-dist', done
gulp.task 'serve-dist:production', ['env:production'], (done) ->
  run 'serve-dist', done

gulp.task 'build:staging', ['env:staging'], (done) ->
  run 'build', done
gulp.task 'build:production', ['env:production'], (done) ->
  run 'build', done

gulp.task 'build', (done) ->
  run 'compile', 'optimize', done

gulp.task 'clean', (done) ->
  log 'Cleaning files..'
  del ['.tmp', 'dist'], done

gulp.task 'publish:staging', ['build:staging'], (done) ->
  run 'upload:staging', done
gulp.task 'publish:production', ['build:production'], (done) ->
  run 'upload:production', done

gulp.task 'upload:staging', ['grunt-publish-staging']
gulp.task 'upload:production', ['grunt-publish-production']

# Compile

gulp.task 'compile', (done) ->
  run 'clean', ['jade', 'coffee', 'scss', 'asset'], 'index', done

gulp.task 'jade', -> jade()
gulp.task 'coffee', -> coffee()
gulp.task 'scss', -> scss()
gulp.task 'asset', -> asset()

gulp.task 'index', -> index()

jade = ->
  log 'Compiling jade files..'
  templates = compileJade()
  translates = translate()
  merge templates, translates

coffee = ->
  log 'Compiling coffee files..'
  compileCoffee()

scss = ->
  log 'Compiling scss files..'
  compileScss()

asset = ->
  log 'Copying asset files..'
  assets = gulp.src [
      'public/assets/*.*'
      'bower_components/ng-file-upload/{FileAPI.min.js,FileAPI.flash.swf}'
    ]
    .pipe gulp.dest('.tmp/serving/assets')
  icons = gulp.src 'public/*.{ico,png}'
    .pipe gulp.dest('.tmp/serving')
  merge assets, icons

compileJade = ->
  gulp.src(['public/**/*.jade', '!public/index.jade'])
    .pipe $.plumber()
    .pipe $.sourcemaps.init()
    .pipe $.jade()
    .pipe $.templateCache(module: 'app.views')
    .pipe $.sourcemaps.write()
    .pipe gulp.dest('.tmp/serving/views')

translate = ->
  gulp.src 'po/**/*.po'
    .pipe $.angularGettext.compile(module: 'app.views')
    .pipe gulp.dest('.tmp/serving/views/')

compileCoffee = ->
  filter = $.filter 'core/constants.coffee'

  gulp.src 'public/**/*.coffee'
    .pipe $.plumber()
    .pipe $.sourcemaps.init()
    .pipe filter
    .pipe $.tokenReplace(config.tokens[ENV])
    .pipe filter.restore()
    .pipe $.coffee()
    .pipe $.ngAnnotate()
    .pipe $.sourcemaps.write()
    .pipe gulp.dest('.tmp/serving')

compileScss = ->
  gulp.src 'public/**/*.scss'
    .pipe $.plumber()
    .pipe $.sourcemaps.init()
    .pipe $.sass()
    .pipe $.autoprefixer()
    .pipe $.sourcemaps.write()
    .pipe gulp.dest('.tmp/serving')

index = ->
  log 'Compiling index file..'
  modules = gulp.src ['.tmp/serving/modules/*.js'], read: false
  scripts = gulp.src ['.tmp/serving/**/*.js', '!.tmp/serving/modules/*.js'], read: false
  styles = gulp.src ['.tmp/serving/**/*.css'], read: false
  sources = series modules, scripts, styles

  gulp.src 'public/index.jade'
    .pipe $.plumber()
    .pipe $.tokenReplace(config.tokens[ENV])
    .pipe wiredep(ignorePath: '../bower_components')
    .pipe $.inject(sources,
      ignorePath: '../.tmp/serving/'
      relative: true
    )
    .pipe $.jade(pretty: true)
    .pipe gulp.dest('.tmp/serving')

# Optimize

gulp.task 'optimize', (done) ->
  log 'Optimizing..'
  run 'optimize-one', 'optimize-two', 'optimize-three', 'optimize-four', done

gulp.task 'optimize-one', ->
  gulp.src '.tmp/serving/assets/*.*'
    .pipe $.rev()
    .pipe gulp.dest('.tmp/building/assets')
    .pipe $.rev.manifest()
    .pipe gulp.dest('.tmp/serving')

gulp.task 'optimize-two', ->
  assets = gulp.src [
      '.tmp/building/assets/*.*'
    ]
    .pipe gulp.dest('dist/assets')
  fonts = gulp.src [
      'bower_components/font-awesome/fonts/*.*'
      'bower_components/slick-carousel/slick/fonts/*.*'
    ]
    .pipe gulp.dest('dist/fonts')
  roots = gulp.src [
      '.tmp/serving/*.{ico,png}'
      'bower_components/fancybox/source/*.{gif,png,jpg}'
    ]
    .pipe gulp.dest('dist')
  merge assets, roots

gulp.task 'optimize-three', ->
  manifest = gulp.src '.tmp/serving/rev-manifest.json'
  gulp.src [
      '.tmp/serving/**/*.{html,css,js}'
      '!.tmp/serving/assets/**/*.*'
    ]
    .pipe $.revReplace(manifest: manifest)
    .pipe gulp.dest('.tmp/building')

gulp.task 'optimize-four', ->
  assets = $.useref.assets()
  gulp.src '.tmp/building/index.html'
    .pipe $.plumber()
    .pipe assets
    .pipe $.if('*.js', $.uglify())
    .pipe $.if('*.css', $.minifyCss())
    .pipe $.rev()
    .pipe assets.restore()
    .pipe $.useref()
    .pipe $.revReplace()
    .pipe gulp.dest('dist')

# Launch and Watch

gulp.task 'launch', ->
  launch ['.tmp/serving', 'bower_components'], '.tmp/serving/index.html'

gulp.task 'launch-dist', ->
  launch 'dist', 'dist/index.html'

gulp.task 'watch', ->
  recompile()
  watch '.tmp/serving/**/*.*'

gulp.task 'watch-dist', ->
  watch 'dist/**/*.*'

launch = (root, fallback) ->
  $.connect.server
    root: root
    port: config.ports.server
    fallback: fallback

watch = (files) ->
  browserSync
    proxy: "localhost:#{config.ports.server}"
    port: config.ports.proxy
    ui:
      port: config.ports.ui
    files: files
    reloadDelay: 200
    notify: false
    ghostMode:
      clicks: false
      scroll: false
      forms: false

recompile = () ->
  _log = (file) ->
    gulp.src file.path, read: false
      .pipe $.print((f) -> "File changed: #{f}")

  $.watch ['public/**/*.jade', '!public/index.jade'], read: false, (file) ->
    _log file
    jade ['public/**/*.jade', '!public/index.jade'], '.tmp/serving/views'
      .on 'finish', index
  $.watch 'po/**/*.po', read: false, (file) ->
    _log file
    translate()
      .on 'finish', index
  $.watch 'public/**/*.coffee', read: false, (file) ->
    _log file
    coffee file.path, path.join('.tmp/serving', path.dirname file.relative)
      .on 'finish', index
  $.watch 'public/**/*.scss', read: false, (file) ->
    _log file
    scss 'public/**/*.scss', '.tmp/serving'
      .on 'finish', index
  $.watch 'public/index.jade', read: false, (file) ->
    _log file
    index()

# Gettext

gulp.task 'gettext', -> gettext()

gettext = ->
  html = gulp.src ['public/**/*.jade']
    .pipe $.plumber()
    .pipe $.jade()

  js = gulp.src ['public/**/*.coffee']
    .pipe $.plumber()
    .pipe $.coffee()

  merge html, js
    .pipe $.angularGettext.extract('template.pot', {})
    .pipe gulp.dest('po/')

# Utils

log = (msg) ->
  $.util.log $.util.colors.underline.yellow(msg)
