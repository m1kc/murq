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

readline = require 'readline'
rl = readline.createInterface
	input: process.stdin
	output: process.stdout
rl.pause()


class Quest

	constructor: (source) ->
		@source = source.split("\n")
		@vars = {}
		@inventory = {}

	# TODO: implement operator `&`
	run: (start = 0) ->
		i = start
		while i < @source.length
			s = @source[i]
			s = s.trimRight()
			s = s.replace /\#\$/g, ' '
			s = s.replace /\#\/\$/g, "\n"
			switch
				when s.length is 0
					### empty line, do nothing ###
				when /^;/.test(s)
					### it's a comment, do nothing ###
				when /^:/.test(s)
					### it's a label, do nothing ###
				when /^(pln|println)\b/i.test(s)
					console.log s.split(' ').slice(1).join(' ')
				when /^(p|print)\b/i.test(s)
					process.stdout.write s.split(' ').slice(1).join(' ')
				when /^(goto) (.+)$/i.test(s)
					target = s.match(/^(goto) (.*)$/i)[2]
					next = @source.indexOf ":#{target}"
					if next is -1
						throw new Error "Line #{i+1}: Cannot find label: #{target}"
					else
						i = next # will jump to next line after label
				when /^(end)$/i.test(s)
					return
				when /^(input) (.+)$/i.test(s)
					targetVar = s.match(/^(input) (.+)$/i)[2]
					ask = () =>
						rl.question '>> ', (input) =>
							input = parseInt(input, 10)
							if isNaN(input)
								rl.write "Not a number.\n"
								ask()
							else
								@vars[targetVar] = input
								rl.pause()
								@run i+1
					ask()
					return
				when /^(inv\+) (\d+),\s?(.+)$/i.test(s)
					what = s.match(/^(inv\+) (\d+),\s?(.+)$/i)[3]
					count = parseInt(s.match(/^(inv\+) (\d+),\s?(.+)$/i)[2], 10)
					if @inventory[what]?
						@inventory[what] += count
					else
						@inventory[what] = count
				when /^(inv\+) (.+)$/i.test(s)
					what = s.match(/^(inv\+) (.+)$/i)[2]
					if @inventory[what]?
						@inventory[what] += 1
					else
						@inventory[what] = 1
				when /^(inv\-) (\d+),\s?(.+)$/i.test(s)
					what = s.match(/^(inv\-) (\d+),\s?(.+)$/i)[3]
					count = parseInt(s.match(/^(inv\-) (\d+),\s?(.+)$/i)[2], 10)
					if @inventory[what]?
						@inventory[what] -= count
						if @inventory[what] < 0
							console.log "Warning: player had less than 0 of #{what}, setting to 0"
							@inventory[what] = 0
					else
						console.log "Warning: player does not have #{what}"
				when /^(inv\-) (.+)$/i.test(s)
					what = s.match(/^(inv\-) (.+)$/i)[2]
					if @inventory[what]?
						@inventory[what] -= 1
						if @inventory[what] < 0
							console.log "Warning: player had less than 0 of #{what}, setting to 0"
							@inventory[what] = 0
					else
						console.log "Warning: player does not have #{what}"
				else
					throw new Error "Line #{i+1}: Cannot parse line: #{s}"
			i++


exports.Quest = Quest
