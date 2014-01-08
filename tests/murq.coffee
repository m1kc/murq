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

murq = require '../lib-cov/murq'

@exports =
	'should ignore blank lines': (test) ->
		source = "\n\n\n\n\n\n\n\n     \n     \n"
		test.doesNotThrow ->
			quest = new murq.Quest(source)
			quest.run()
		test.done()

	'should ignore comments': (test) ->
		source = """
			;123
			;97239382
			;8821379187
		"""
		test.doesNotThrow ->
			quest = new murq.Quest(source)
			quest.run()
		test.done()

	'should ignore labels while running': (test) ->
		source = """
			;make install

			:label
			:one more label

			;make my anal
		"""
		test.doesNotThrow ->
			quest = new murq.Quest(source)
			quest.run()
		test.done()

	'should fail on unkown commands': (test) ->
		source = """
			;Fail here
			unkcmd Oh, wow.
		"""
		test.throws ->
			quest = new murq.Quest(source)
			quest.run()
		test.done()

	'should print text when it sees `pln` or `println`, ignoring case': (test) ->
		source = """
			pln Kill
			PLN me
			PRINTLN now
		"""
		output = ''
		_log = console.log
		console.log = (x) -> output += "#{x}\n"

		quest = new murq.Quest(source)
		quest.run()

		console.log = _log
		test.strictEqual output, "Kill\nme\nnow\n"
		test.done()

	'should print text when it sees `p` or `print`, ignoring case': (test) ->
		source = """
			p Kill
			P me
			PRINT now
		"""
		output = ''
		_write = process.stdout.write
		process.stdout.write = (x) -> output += "#{x}"

		quest = new murq.Quest(source)
		quest.run()

		process.stdout.write = _write
		test.strictEqual output, "Killmenow"
		test.done()

	'should fail on unknown labels': (test) ->
		source = """
			goto hell
		"""
		test.throws ->
			quest = new murq.Quest(source)
			quest.run()
		test.done()

	'should follow labels': (test) ->
		source = """
			p 1
			goto lab
			p 2
			:lab
			p 3
		"""
		output = ''
		_write = process.stdout.write
		process.stdout.write = (x) -> output += "#{x}"

		quest = new murq.Quest(source)
		quest.run()

		process.stdout.write = _write
		test.strictEqual output, "13"
		test.done()

	'should end on `end`': (test) ->
		source = """
			p 1
			p 2
			end
			p 3
		"""
		output = ''
		_write = process.stdout.write
		process.stdout.write = (x) -> output += "#{x}"

		quest = new murq.Quest(source)
		quest.run()

		process.stdout.write = _write
		test.strictEqual output, "12"
		test.done()

	'should threat `#$` as space': (test) ->
		source = """
			p Kill
			p #$
			p me
		"""
		output = ''
		_write = process.stdout.write
		process.stdout.write = (x) -> output += "#{x}"

		quest = new murq.Quest(source)
		quest.run()

		process.stdout.write = _write
		test.strictEqual output, 'Kill me'
		test.done()

	'should threat `#/$` as newline': (test) ->
		source = """
			p Kill#/$me
		"""
		output = ''
		_write = process.stdout.write
		process.stdout.write = (x) -> output += x

		quest = new murq.Quest(source)
		quest.run()

		process.stdout.write = _write
		test.strictEqual output, "Kill\nme"
		test.done()

	'should be ok if `p` or `pln` is called without an argument': (test) ->
		source = """
			pln Make
			pln
			p
			pln install
		"""
		output = ''
		_log = console.log
		console.log = (x) -> output += "#{x}\n"

		quest = new murq.Quest(source)
		quest.run()

		console.log = _log
		test.strictEqual output, "Make\n\ninstall\n"
		test.done()

	'should manipulate inventory': (test) ->
		source = """
			inv+ 4, eggs
			inv+ moonshine
			inv+ 2, moonshine
			inv+ 6, eggs
			inv- eggs
			inv- moonshine
			inv- 2, eggs
		"""
		quest = new murq.Quest(source)
		quest.run()
		test.strictEqual quest.inventory.eggs, 7
		test.strictEqual quest.inventory.moonshine, 2
		test.done()
