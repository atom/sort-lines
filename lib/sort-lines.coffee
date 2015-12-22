RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor:not([mini])',
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
      'sort-lines:length': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLinesLength(editor)
      'sort-lines:reverse-length': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLinesReversedLength(editor)

sortTextLines = (editor, sorter) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n")
    textLines = sorter(textLines)
    editor.setTextInBufferRange(range, textLines.join("\n"))

sortLines = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) -> a.localeCompare(b)

sortLinesReversed = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) -> b.localeCompare(a)

uniqueLines = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.filter (value, index, self) -> self.indexOf(value) == index

sortLinesInsensitive = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) -> a.toLowerCase().localeCompare(b.toLowerCase())

sortLinesLength = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) -> b.length - a.length

sortLinesReversedLength = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) -> a.length - b.length
