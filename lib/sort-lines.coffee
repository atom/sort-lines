RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor',
      'sort-lines:sort': ->
        run sort
      'sort-lines:case-insensitive-sort': ->
        run sortInsensitive
      'sort-lines:reverse': ->
        run reverse
      'sort-lines:unique': ->
        run unique
      'sort-lines:shuffle': ->
        run shuffle

run = (cmd) ->
  editor = atom.workspace.getActiveTextEditor()
  ranges = RangeFinder.rangesFor(editor)
  ranges.forEach (range) ->
    lines = editor.getTextInBufferRange(range).split("\n")
    lines = cmd(lines)
    editor.setTextInBufferRange(range, lines.join("\n"))

sort = (lines) ->
  lines.sort() # Not using localeCompare() since it's buggy in V8.

sortInsensitive = (lines) ->
  lines.sort (a, b) ->
    r = a.toLowerCase() - b.toLowerCase()
    if r == 0 then a-b else r

reverse = (lines) ->
  lines.reverse()

unique = (lines) ->
  lines.filter (value, index, self) -> self.indexOf(value) == index

shuffle = (lines) ->
  for i in [lines.length-1..1]
    j = Math.floor(Math.random() * (i+1))
    [lines[i], lines[j]] = [lines[j], lines[i]]
  lines
