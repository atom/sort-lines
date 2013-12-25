{_, Range} = require 'atom'

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
    if _.isEmpty(selectionRanges)
      [@sortableRangeForEntireBuffer()]
    else
      _.map selectionRanges, (selectionRange) =>
        @sortableRangeFrom(selectionRange)

  # Internal
  selectionRanges: ->
    _.reject @editor.getSelectedBufferRanges(), (range) ->
      range.isEmpty()

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
