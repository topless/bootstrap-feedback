module.exports = (grunt) ->
  require('load-grunt-tasks') grunt

  path = require 'path'

  config =
    connect_port: 8888
    livereload_port: 31415
    app: 'src'
    ext: 'ext'
    dist: 'dist'
    prod: 'prod'
    js: 'js'
    test: 'test'
    coffee: 'coffee'

  grunt.initConfig
    config: config

    bower:
      install:
        options:
          targetDir: config.ext
          layout: (type, component) ->
            if type.search('/') > -1
              path.join type.replace '/', "/#{component}/"
            else
              path.join type, component

    coffee:
      options:
        sourceMap: true
      dist:
        expand: true
        cwd: config.app
        src: ['**/*.coffee']
        dest: config.dist
        ext: '.js'

      test:
        expand: true
        cwd: path.join config.test, config.coffee
        dest: path.join config.test, config.js
        src: ['**/*.coffee']
        ext: '.js'


    less:
      dist:
        options:
          paths: ['<%= config.app %>/style']
        files:
          '<%= config.dist %>/style/main.css': '<%= config.app %>/style/main.less'


    copy:
      dist:
        files: [
          expand: true
          cwd: config.app
          src: ['**/*.html']
          dest: config.dist
        ,
          expand: true
          cwd: "#{config.ext}/font"
          src: ['**/*']
          dest: "#{config.dist}/font"
        ]


    jasmine:
      dist:
        src: '<%= config.dist %>/**/*.js'
        options:
          specs: '<%= config.test %>/<%= config.js %>/*_spec.js'


    watch:
      app:
        options:
          livereload: config.livereload_port
        files: '<%= config.app %>/**/*.{coffee,less,css,js}'
        tasks: ['coffee:dist', 'less:dist']

      static:
        options:
          livereload: config.livereload_port
        files: ['<%= config.app %>/*.html', '<%= config.app %>/**/*.html']
        tasks: ['copy:dist']

      test:
        options:
          livereload: config.livereload_port
        files: '<%= config.test %>/**/*.coffee'
        tasks: ['coffee:test', 'jasmine']


    open:
      dev:
        path: "http://localhost:#{config.connect_port}/"


    connect:
      server:
        options:
          port: config.connect_port
          hostname: '*'
          # base: config.dist

    clean:
      dist: config.dist
      test: path.join config.test, config.js


  grunt.registerTask 'dist', ['clean:dist', 'bower', 'coffee:dist', 'less:dist', 'copy']
  grunt.registerTask 'test', ['dist', 'clean:test', 'coffee:test', 'jasmine']
  grunt.registerTask 'ext', ['clean:ext', 'bower']
  grunt.registerTask 'default', ['dist', 'connect', 'open', 'watch']
