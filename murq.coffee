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
jschardet = require 'jschardet'
murq = require './lib/murq.coffee'

console.log '// m1kc URQ //'

if process.argv.length != 3
	console.log 'Usage: murq <filename>'
else
	filename = process.argv[2]
	sourceBuffer = fs.readFileSync(filename)
	sourceEncoding = jschardet.detect(sourceBuffer).encoding
	console.log "Auto-detected encoding: #{sourceEncoding}"
	converter = new iconv.Iconv(sourceEncoding, 'utf8')
	sourceBuffer = converter.convert(sourceBuffer)
	quest = new murq.Quest(sourceBuffer.toString())
	quest.run()
