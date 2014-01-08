#!/usr/bin/env coffee

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

fs = require 'fs'
iconv = require 'iconv'
murq = require './lib/murq.coffee'

console.log '// m1kc URQ //'

if process.argv.length != 3
	console.log 'Usage: murq <filename>'
else
	filename = process.argv[2]
	converter = new iconv.Iconv('cp1251', 'utf8')
	sourceBuffer = fs.readFileSync(filename)
	source = converter.convert(sourceBuffer)
	quest = new murq.Quest(source.toString())
	quest.run()
