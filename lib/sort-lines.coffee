RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.workspaceView.command 'sort-lines:sort', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      sortLines(editor)

    atom.workspaceView.command 'sort-lines:reverse-sort', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      sortLinesReversed(editor)

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
