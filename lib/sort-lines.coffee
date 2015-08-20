RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor:not([mini])',
      'sort-lines:sort': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLines(editor)
      'sort-lines:reverse-sort': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLinesReversed(editor)
      'sort-lines:unique': ->
        editor = atom.workspace.getActiveTextEditor()
        uniqueLines(editor)
      'sort-lines:case-insensitive-sort': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLinesInsensitive(editor)
      'sort-lines:natural': ->
        editor = atom.workspace.getActiveTextEditor()
        sortLinesNatural(editor)

sortTextLines = (editor, sorter) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n")
    textLines = sorter(textLines)
    editor.setTextInBufferRange(range, textLines.join("\n"))

sortLines = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) -> if a is b then 0 else if a > b then 1 else -1

sortLinesReversed = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) -> if a is b then 0 else if a < b then 1 else -1

uniqueLines = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.filter (value, index, self) -> self.indexOf(value) == index

sortLinesInsensitive = (editor) ->
  sortTextLines editor, (textLines) ->
    textLines.sort (a, b) ->
      a = a.toLowerCase()
      b = b.toLowerCase()
      if a is b then 0 else if a > b then 1 else -1

sortLinesNatural = (editor) ->
  sortTextLines editor, (textLines) ->
    naturalSortRegex = /^(\d*)(\D*)(\d*)([\s\S]*)$/
    textLines.sort (a, b) =>
      return 0 if a is b
      [__, aLeadingNum, aWord, aTrailingNum, aRemainder] = naturalSortRegex.exec(a)
      [__, bLeadingNum, bWord, bTrailingNum, bRemainder] = naturalSortRegex.exec(b)
      return (if a < b then -1 else 1) if aWord isnt bWord
      return (if aLeadingNum < bLeadingNum then -1 else 1) if aLeadingNum isnt bLeadingNum
      return (if aTrailingNum < bTrailingNum then -1 else 1) if aTrailingNum isnt bTrailingNum
      return 0
