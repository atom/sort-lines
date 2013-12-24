RangeFinder = require './range-finder'

module.exports =
  activate: (state) ->
    atom.workspaceView.command 'sort-lines:sort', '.editor', =>
      editor = atom.workspaceView.getActivePaneItem()
      @sortLines(editor)

  sortLines: (editor) ->
    sortableRanges = RangeFinder.rangesFor(editor)
    sortableRanges.forEach (range) ->
      textLines = editor.getTextInBufferRange(range).split("\n")
      textLines.sort (a, b) -> a.localeCompare(b)
      editor.setTextInBufferRange(range, textLines.join("\n"))
