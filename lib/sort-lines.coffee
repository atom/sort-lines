RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor',
      'sort-lines:sort': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLines(editor)
      'sort-lines:reverse-sort': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLinesReversed(editor)
      'sort-lines:unique': ->
        editor = atom.workspace.getActiveTextEditor()
        uniqueLines(editor)
      'sort-lines:case-insensitive-sort': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLinesInsensitive(editor)

sortLines = (editor) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n")
    textLines.sort (a, b) -> a.localeCompare(b)
    editor.setTextInBufferRange(range, textLines.join("\n"))

sortLinesReversed = (editor) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n")
    textLines.sort (a, b) -> b.localeCompare(a)
    editor.setTextInBufferRange(range, textLines.join("\n"))

uniqueLines = (editor) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n")
    uniqued = textLines.filter (value, index, self) -> self.indexOf(value) == index
    editor.setTextInBufferRange(range, uniqued.join("\n"))

sortLinesInsensitive = (editor) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n")
    textLines.sort (a, b) -> a.toLowerCase().localeCompare(b.toLowerCase())
    editor.setTextInBufferRange(range, textLines.join("\n"))
