const {Range} = require('atom')

module.exports =
class RangeFinder {
  // Public
  static rangesFor (editor) {
    return new RangeFinder(editor).ranges()
  }

  // Public
  constructor (editor) {
    this.editor = editor
  }

  // Public
  ranges () {
    const selectionRanges = this.selectionRanges()
    if (selectionRanges.length === 0) {
      return [this.sortableRangeFrom(this.sortableRangeForEntireBuffer())]
    } else {
      return selectionRanges.map((selectionRange) => {
        return this.sortableRangeFrom(selectionRange)
      })
    }
  }

  // Internal
  selectionRanges () {
    return this.editor.getSelectedBufferRanges().filter((range) => !range.isEmpty())
  }

  // Internal
  sortableRangeForEntireBuffer () {
    return this.editor.getBuffer().getRange()
  }

  // Internal
  sortableRangeFrom (selectionRange) {
    const startRow = selectionRange.start.row
    const startCol = 0
    const endRow = endRowForSelectionRange(selectionRange)
    const endCol = this.editor.lineTextForBufferRow(endRow).length

    return new Range([startRow, startCol], [endRow, endCol])
  }
}

function endRowForSelectionRange (selectionRange) {
  const row = selectionRange.end.row
  const column = selectionRange.end.column

  if (column !== 0) {
    return row
  } else {
    return Math.max(0, row - 1)
  }
}
