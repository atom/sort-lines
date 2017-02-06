{Range} = require 'atom'

module.exports =
class RangeFinder
  # Public
  @rangesFor: (editor, fullLines = true) ->
    new RangeFinder(editor).ranges(fullLines)

  # Public
  constructor: (@editor) ->

  # Public
  ranges: (fullLines = true) ->
    selectionRanges = @selectionRanges()
    if fullLines and selectionRanges.length is 0
      [@sortableRangeFrom(@sortableRangeForEntireBuffer(), fullLines)]
    else
      selectionRanges.map (selectionRange) =>
        @sortableRangeFrom(selectionRange, fullLines)

  # Internal
  selectionRanges: ->
    @editor.getSelectedBufferRanges().filter (range) ->
      not range.isEmpty()

  # Internal
  sortableRangeForEntireBuffer: ->
    @editor.getBuffer().getRange()

  # Internal
  sortableRangeFrom: (selectionRange, fullLines) ->
    startRow = selectionRange.start.row
    startCol = if fullLines then 0 else selectionRange.start.column

    if selectionRange.end.column == 0
      endRow = selectionRange.end.row - 1
      endCol = @editor.lineTextForBufferRow(endRow).length
    else
      endRow = selectionRange.end.row
      endCol = if fullLines
        @editor.lineTextForBufferRow(endRow).length
      else
        selectionRange.end.column

    new Range [startRow, startCol], [endRow, endCol]
