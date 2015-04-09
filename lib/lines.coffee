RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor',
      'lines:sort': ->
        run sort
      'lines:case-insensitive-sort': ->
        run sortInsensitive
      'lines:reverse': ->
        run reverse
      'lines:unique': ->
        run unique
      'lines:shuffle': ->
        run shuffle

run = (cmd) ->
  editor = atom.workspace.getActiveTextEditor()
  ranges = RangeFinder.rangesFor(editor)
  ranges.forEach (range) ->
    lines = editor.getTextInBufferRange(range).split("\n")
    lines = cmd(lines)
    editor.setTextInBufferRange(range, lines.join("\n"))

sort = (lines) ->
  lines.sort()

sortInsensitive = (lines) ->
  lines.sort (a, b) ->
    r = a.toLowerCase().localeCompare(b.toLowerCase())
    if r == 0
      r = a.localeCompare(b)
    r

reverse = (lines) ->
  lines.reverse()

unique = (lines) ->
  lines.filter (value, index, self) -> self.indexOf(value) == index

shuffle = (lines) ->
  for i in [lines.length-1..1]
    j = Math.floor(Math.random() * (i+1))
    [lines[i], lines[j]] = [lines[j], lines[i]]
  lines
