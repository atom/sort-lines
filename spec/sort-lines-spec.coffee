{WorkspaceView} = require 'atom'

describe "sorting lines", ->
  [activationPromise, editor, editorView] = []

  sortLines = (callback) ->
    editorView.trigger "sort-lines:sort"
    waitsForPromise -> activationPromise
    runs(callback)

  sortLinesReversed = (callback) ->
    editorView.trigger "sort-lines:reverse-sort"
    waitsForPromise -> activationPromise
    runs(callback)

  uniqueLines = (callback) ->
    editorView.trigger "sort-lines:unique"
    waitsForPromise -> activationPromise
    runs(callback)

  sortLineCaseInsensitive = (callback) ->
    editorView.trigger "sort-lines:case-insensitive-sort"
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    activationPromise = atom.packages.activatePackage('sort-lines')

  describe "when no lines are selected", ->
    it "sorts all lines", ->
      editor.setText """
        Hydrogen
        Helium
        Lithium
      """
      editor.setCursorBufferPosition([0, 0])

      sortLines ->
        expect(editor.getText()).toBe """
          Helium
          Hydrogen
          Lithium
        """

    it "sorts all lines, ignoring the trailing new line", ->
      editor.setText """
        Hydrogen
        Helium
        Lithium

      """
      editor.setCursorBufferPosition([0, 0])

      sortLines ->
        expect(editor.getText()).toBe """
          Helium
          Hydrogen
          Lithium

        """

  describe "when entire lines are selected", ->
    it "sorts the selected lines", ->
      editor.setText """
        Hydrogen
        Helium
        Lithium
        Beryllium
        Boron
      """
      editor.setSelectedBufferRange([[1,0], [4,0]])

      sortLines ->
        expect(editor.getText()).toBe """
          Hydrogen
          Beryllium
          Helium
          Lithium
          Boron
        """

  describe "when partial lines are selected", ->
    it "sorts the selected lines", ->
      editor.setText """
        Hydrogen
        Helium
        Lithium
        Beryllium
        Boron
      """
      editor.setSelectedBufferRange([[1,3], [3,2]])

      sortLines ->
        expect(editor.getText()).toBe """
          Hydrogen
          Beryllium
          Helium
          Lithium
          Boron
        """

  describe "when there are multiple selection ranges", ->
    it "sorts the lines in each selection range", ->
      editor.setText """
        Hydrogen
        Helium    # selection 1
        Beryllium # selection 1
        Carbon
        Fluorine  # selection 2
        Aluminum  # selection 2
        Gallium
        Europium
      """
      editor.addSelectionForBufferRange([[1, 0], [3, 0]])
      editor.addSelectionForBufferRange([[4, 0], [6, 0]])

      sortLines ->
        expect(editor.getText()).toBe """
          Hydrogen
          Beryllium # selection 1
          Helium    # selection 1
          Carbon
          Aluminum  # selection 2
          Fluorine  # selection 2
          Gallium
          Europium
        """

  describe "reversed sorting", ->
    it "sorts all lines in reverse order", ->
      editor.setText """
        Hydrogen
        Helium
        Lithium
      """

      editor.setCursorBufferPosition([0, 0])

      sortLinesReversed ->
        expect(editor.getText()).toBe """
          Lithium
          Hydrogen
          Helium
        """

  describe "uniqueing", ->
    it "uniques all lines but does not change order", ->
      editor.setText """
        Hydrogen
        Hydrogen
        Helium
        Lithium
        Hydrogen
        Hydrogen
        Helium
        Lithium
        Hydrogen
        Hydrogen
        Helium
        Lithium
        Hydrogen
        Hydrogen
        Helium
        Lithium
      """

      editor.setCursorBufferPosition([0, 0])

      uniqueLines ->
        expect(editor.getText()).toBe """
          Hydrogen
          Helium
          Lithium
        """

  describe "case-insensitive sorting", ->
    it "sorts all lines, ignoring case", ->
      editor.setText """
        Hydrogen
        lithium
        helium
        Helium
        Lithium
      """

      editor.setCursorBufferPosition([0, 0])

      sortLineCaseInsensitive ->
        expect(editor.getText()).toBe """
          helium
          Helium
          Hydrogen
          lithium
          Lithium
        """
