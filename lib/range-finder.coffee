{Range} = require 'atom'

module.exports =
class RangeFinder
  # Public
  @rangesFor: (editor) ->
    new RangeFinder(editor).ranges()

  # Public
  constructor: (@editor) ->

  # Public
  ranges: ->
    selectionRanges = @selectionRanges()
    if selectionRanges.length is 0
      [@sortableRangeFrom(@sortableRangeForEntireBuffer())]
    else
      selectionRanges.map (selectionRange) =>
        @sortableRangeFrom(selectionRange)

  # Internal
  selectionRanges: ->
    @editor.getSelectedBufferRanges().filter (range) ->
      not range.isEmpty()

  # Internal
  sortableRangeForEntireBuffer: ->
    @editor.getBuffer().getRange()

  # Internal
  sortableRangeFrom: (selectionRange) ->
    startRow = selectionRange.start.row
    startCol = 0
    endRow = if selectionRange.end.column == 0
      selectionRange.end.row - 1
    else
      selectionRange.end.row
    endCol = @editor.lineLengthForBufferRow(endRow)

    new Range [startRow, startCol], [endRow, endCol]
