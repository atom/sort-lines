{sortLines} = require '../lib/sort-lines'

describe "SortLines", ->
  describe "sortLines(editor)", ->
    [editor] = []

    beforeEach ->
      editor = atom.project.openSync()
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

    describe "when entire lines are selected", ->
      it "sorts the selected lines", ->
        editor.setSelectedBufferRange([[1,0], [4,0]])
        sortLines(editor)
        expect(editor.getText()).toBe """
          Hydrogen
          Beryllium
          Helium
          Lithium
          Boron
        """

    describe "when partial lines are selected", ->
      it "sorts the selected lines", ->
        editor.setSelectedBufferRange([[1,3], [3,2]])
        sortLines(editor)
        expect(editor.getText()).toBe """
          Hydrogen
          Beryllium
          Helium
          Lithium
          Boron
        """
