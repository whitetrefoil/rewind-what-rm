gruntConfig = (grunt) ->
  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean:
      lib: ['lib']
      doc: ['doc']

    coffee:
      build:
        files: [
          expand: true
          cwd: 'src'
          src: ['**/*.{coffee,litcoffee}']
          dest: 'lib/'
          extDot: 'last'
          ext: '.js'
        ]

  grunt.registerTask 'build', 'Compile & optimize the codes',
      ['clean:build', 'coffee:build']

  grunt.registerTask 'default', 'UT (when has) & build',
      ['build']


module.exports = gruntConfig
