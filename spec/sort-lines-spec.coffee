{sortLines} = require '../lib/sort-lines'

describe "SortLines", ->
  describe "sortLines(editor)", ->
    [editor, buffer] = []

    beforeEach ->
      editor = atom.project.openSync()
      buffer = editor.getBuffer()
      editor.setText """
        Hydrogen
        Helium
        Lithium
        Beryllium
        Boron
      """

    describe "when no lines are selected", ->
      it "sorts all lines", ->
        editor.setCursorBufferPosition([0, 0])
        sortLines(editor)
        expect(editor.getText()).toBe """
          Beryllium
          Boron
          Helium
          Hydrogen
          Lithium
        """
