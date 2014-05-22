RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.workspaceView.command 'sort-lines:sort', '.editor', ->
      editor = atom.workspace.getActiveEditor()
      sortLines(editor)

    atom.workspaceView.command 'sort-lines:reverse-sort', '.editor', ->
      editor = atom.workspace.getActiveEditor()
      sortLinesReversed(editor)

    atom.workspaceView.command 'sort-lines:unique', '.editor', ->
      editor = atom.workspace.getActiveEditor()
      uniqueLines(editor)

    atom.workspaceView.command 'sort-lines:case-insensitive-sort', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
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
