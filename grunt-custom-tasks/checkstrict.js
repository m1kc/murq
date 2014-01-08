/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */


'use strict';

module.exports = function(grunt) {
	// Please see the Grunt documentation for more information regarding task
	// creation: http://gruntjs.com/creating-tasks
	grunt.registerMultiTask('checkstrict', 'Check if every file is in strict mode.', function() {
		var done = this.async();
		var fs = require('fs');
		var async = require('async');
		async.map(
			this.files,
			function (item, callback) {
				fs.readFile(item.src[0], function (error, data) {
					if (!!error)
					{
						callback(error, null);
					}
					else
					{
						callback(null, [item.src[0], ( /['"]use strict['"]\s*[;\n]/ ).test(data.toString())]);
					}
				});
			},
			function (error, results) {
				async.filter(
					results,
					function (item, callback) {
						callback(!item[1]);
					},
					function(results) {
						if (results.length === 0)
						{
							grunt.log.ok('All files are strict.');
						}
						else
						{
							for (var i in results)
							{
								grunt.log.warn(results[i][0]+' is not strict.');
							}
						}
						done();
					}
				);
			}
		);
	});
};
