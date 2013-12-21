RangeFinder = require './range-finder'

sortLines = (editor) ->
  lineRange = RangeFinder.rangeFor(editor)
  textLines = editor.getTextInBufferRange(lineRange).split("\n")
  textLines.sort (a, b) -> a.localeCompare(b)
  editor.setTextInBufferRange(lineRange, textLines.join("\n"))

module.exports =
  activate: (state) ->
    atom.workspaceView.command 'sort-lines:sort', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      sortLines(editor)

  sortLines: sortLines
