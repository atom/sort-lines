{_, Range} = require 'atom'

sortLines = (editor) ->
  lineRange = getRangeToSort(editor)
  textLines = editor.getTextInBufferRange(lineRange).split("\n")
  textLines.sort (a, b) -> a.localeCompare(b)
  editor.setTextInBufferRange(lineRange, textLines.join("\n"))

getRangeToSort = (editor) ->
  selectedBufferRange = editor.getSelectedBufferRange();
  if isRangeEmpty(selectedBufferRange)
    new Range [0, 0], [editor.getScreenLineCount(), 0]
  else
    startRow = selectedBufferRange.start.row
    startCol = 0
    endRow = selectedBufferRange.end.row - 1
    endCol = editor.lineLengthForBufferRow(endRow)
    new Range [startRow, startCol], [endRow, endCol]

# TODO: Is there a method on Range that provides this functionality?
isRangeEmpty = (range) ->
  # TODO: Is there a method on Point to compare it to another Point in this manner?
  range.start.row == range.end.row and range.start.column == range.end.column

module.exports =
  activate: (state) ->
    atom.workspaceView.command 'sort-lines:sort', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      sortLines(editor)

  sortLines: sortLines
