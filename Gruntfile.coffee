config =
  tasks :
    clean :
      dist : [ "dist", "*.{js,map}", "lib/**/*.{map,js}" ]

    coffee :
      options : { sourceMap : false, bare : true, force : true }
      dist :
        expand : true
        src : [ "lib/**/*.coffee", "*.coffee", "!Gruntfile.coffee" ]
        dest : "dist"
        ext : '.js'

    coffeelint :
      app : [ 'lib/**/*.coffee', "*.coffee" ]

    exec :
      mocha_istanbul :
        cmd : 'istanbul report lcov && open' +
          ' ./coverage/lcov-report/index.html'

  load : [
    'grunt-contrib-coffee',
    'grunt-contrib-clean',
    'grunt-coffeelint'
    'grunt-exec'
  ]

  register :
    default : [ "coffeelint", "clean:dist", "coffee:dist" ]
    coverage : [ "exec:mocha_istanbul" ]

doConfig = ( opts ) -> ( grunt ) ->
  opts.tasks.pkg = grunt.file.readJSON "package.json"
  grunt.initConfig opts.tasks
  grunt.loadNpmTasks t for t in opts.load
  for own name, tasks of opts.register
    grunt.registerTask name, tasks

module.exports = doConfig config
