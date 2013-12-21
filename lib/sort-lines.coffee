{_} = require 'atom'

sortLines = (editor) ->
  screenLines = editor.linesForScreenRows(0, editor.getScreenLineCount())
  textLines = _.map(screenLines, (screenLine) -> screenLine.text)
  textLines.sort (a, b) -> a.localeCompare(b)
  editor.setText(textLines.join("\n"))

module.exports =
  activate: (state) ->
    atom.workspaceView.command 'sort-lines:sort', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      sortLines(editor)

  sortLines: sortLines
