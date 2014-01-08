# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


'use strict'

module.exports = (grunt) ->

	# Project configuration.
	grunt.initConfig
		nodeunit:
			all: [
				'tests/*.coffee'
			]

		checklicense:
			all:
				src: [
					'*.coffee'
					'lib/*.coffee'
					'tests/*.coffee'
					'grunt-custom-tasks/*.coffee'
				]

		checkstrict:
			all:
				src: [
					'*.coffee'
					'lib/*.coffee'
					'tests/*.coffee'
					'grunt-custom-tasks/*.coffee'
				]

		coffeelint:
			all: [
				'*.coffee'
				'lib/*.coffee'
				'tests/*.coffee'
				'grunt-custom-tasks/*.coffee'
			]
			options: JSON.parse require('fs').readFileSync('.coffeelintrc').toString()


	# These plugins provide necessary tasks.
	require('load-grunt-tasks')(grunt)
	grunt.loadTasks './grunt-custom-tasks/'

	# Basic tasks.
	grunt.registerTask 'check', ['checkstrict', 'checklicense', 'coffeelint']
	grunt.registerTask 'test', ['nodeunit', 'jscoverage_report']

	# Default task.
	grunt.registerTask 'default', ['check', 'test']
