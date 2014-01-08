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


class Quest

	constructor: (source) ->
		@source = source.split("\n")

	# TODO: implement operator `&`
	# TODO: p or pln may be called without argument
	run: ->
		i = 0
		while i < @source.length
			s = @source[i]
			s = s.trimRight()
			switch
				when s.length is 0
					### empty line, do nothing ###
				when /;.*/.test(s)
					### it's a comment, do nothing ###
				when /:.*/.test(s)
					### it's a label, do nothing ###
				when /(pln|println) (.*)/i.test(s)
					console.log s.match(/(pln|println) (.*)/i)[2]
				when /(p|print) (.*)/i.test(s)
					process.stdout.write s.match(/(p|print) (.*)/i)[2]
				when /(goto) (.+)/i.test(s)
					target = s.match(/(goto) (.*)/i)[2]
					next = @source.indexOf ":#{target}"
					if next is -1
						throw new Error "Line #{i+1}: Cannot find label: #{target}"
					else
						i = next # will jump to next line after label
				when s is 'end'
					return
				else
					throw new Error "Line #{i+1}: Cannot parse line: #{s}"
			i++


exports.Quest = Quest
