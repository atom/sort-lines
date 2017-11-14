const RangeFinder = require('./range-finder')
const shuffle = require('array-shuffle')
const naturalSort = require('javascript-natural-sort')

module.exports = {
  activate () {
    atom.commands.add('atom-text-editor:not([mini])', {
      'sort-lines:sort' () {
        sortLines(atom.workspace.getActiveTextEditor())
      },
      'sort-lines:reverse-sort' () {
        sortLinesReversed(atom.workspace.getActiveTextEditor())
      },
      'sort-lines:unique' () {
        uniqueLines(atom.workspace.getActiveTextEditor())
      },
      'sort-lines:case-insensitive-sort' () {
        sortLinesInsensitive(atom.workspace.getActiveTextEditor())
      },
      'sort-lines:natural' () {
        sortLinesNatural(atom.workspace.getActiveTextEditor())
      },
      'sort-lines:by-length' () {
        sortLinesByLength(atom.workspace.getActiveTextEditor())
      },
      'sort-lines:by-length-reversed' () {
        sortLinesByLengthReversed(atom.workspace.getActiveTextEditor())
      },
      'sort-lines:shuffle' () {
        shuffleLines(atom.workspace.getActiveTextEditor())
      }
    })
  }
}

function sortTextLines (editor, sorter) {
  const sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach((range) => {
    const textLines = editor.getTextInBufferRange(range).split(/\r?\n/g)
    const sortedTextLines = sorter(textLines)
    editor.setTextInBufferRange(range, sortedTextLines.join('\n'))
  })
}

function sortLines (editor) {
  sortTextLines(editor,
    (textLines) => textLines.sort((a, b) => a.localeCompare(b))
  )
}

function sortLinesReversed (editor) {
  sortTextLines(editor,
    (textLines) => textLines.sort((a, b) => b.localeCompare(a))
  )
}

function uniqueLines (editor) {
  sortTextLines(editor,
    (textLines) => Array.from(new Set(textLines))
  )
}

function sortLinesInsensitive (editor) {
  sortTextLines(editor,
    (textLines) => textLines.sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()))
  )
}

function sortLinesNatural (editor) {
  sortTextLines(editor,
    (textLines) => textLines.sort(naturalSort)
  )
}

function sortLinesByLength (editor) {
  sortTextLines(editor,
    (textLines) => textLines.sort((a, b) => a.length - b.length)
  )
}

function sortLinesByLengthReversed (editor) {
  sortTextLines(editor,
    (textLines) => textLines.sort((a, b) => b.length - a.length)
  )
}

function shuffleLines (editor) {
  sortTextLines(editor,
    (textLines) => shuffle(textLines)
  )
}
