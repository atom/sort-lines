{_, Range} = require 'atom'

module.exports =
class RangeFinder

  # Public
  @rangeFor: (editor) ->
    new RangeFinder(editor).range()

  # Public
  constructor: (@editor) ->

  # Public
  range: ->
    new Range [@startRow(), @startColumn()], [@endRow(), @endColumn()]

  # Internal
  startRow: ->
    if @isSelectedRangeEmpty() then 0 else @selectedBufferRange().start.row

  # Internal
  startColumn: ->
    0

  # Internal
  endRow: ->
    if @isSelectedRangeEmpty()
      @editor.getScreenLineCount()
    else
      @lastSelectedRow()

  # Internal
  endColumn: ->
    @editor.lineLengthForBufferRow(@endRow())

  # Internal
  lastSelectedRow: ->
    endPoint = @selectedBufferRange().end
    if endPoint.column == 0
      endPoint.row - 1
    else
      endPoint.row

  # Internal
  selectedBufferRange: ->
    @editor.getSelectedBufferRange()

  # Internal
  isSelectedRangeEmpty: ->
    @selectedBufferRange().isEmpty()
