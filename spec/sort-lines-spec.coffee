{WorkspaceView} = require 'atom'

describe "sorting lines", ->
  [editorView] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()
    atom.packages.activatePackage('sort-lines')
    editorView = atom.workspaceView.getActiveView()

  describe "when no lines are selected", ->
    it "sorts all lines", ->
      editorView.setText """
        Hydrogen
        Helium
        Lithium
      """
      editorView.setCursorBufferPosition([0, 0])
      editorView.trigger "sort-lines:sort"
      expect(editorView.getText()).toBe """
        Helium
        Hydrogen
        Lithium
      """

  describe "when entire lines are selected", ->
    it "sorts the selected lines", ->
      editorView.setText """
        Hydrogen
        Helium
        Lithium
        Beryllium
        Boron
      """
      editorView.setSelectedBufferRange([[1,0], [4,0]])
      editorView.trigger "sort-lines:sort"
      expect(editorView.getText()).toBe """
        Hydrogen
        Beryllium
        Helium
        Lithium
        Boron
      """

  describe "when partial lines are selected", ->
    it "sorts the selected lines", ->
      editorView.setText """
        Hydrogen
        Helium
        Lithium
        Beryllium
        Boron
      """
      editorView.setSelectedBufferRange([[1,3], [3,2]])
      editorView.trigger "sort-lines:sort"
      expect(editorView.getText()).toBe """
        Hydrogen
        Beryllium
        Helium
        Lithium
        Boron
      """

  describe "when there are multiple selection ranges", ->
    it "sorts the lines in each selection range", ->
      editorView.setText """
        Hydrogen
        Helium    # selection 1
        Beryllium # selection 1
        Carbon
        Fluorine  # selection 2
        Aluminum  # selection 2
        Gallium
        Europium
      """
      editorView.addSelectionForBufferRange([[1, 0], [3, 0]])
      editorView.addSelectionForBufferRange([[4, 0], [6, 0]])
      editorView.trigger "sort-lines:sort"
      expect(editorView.getText()).toBe """
        Hydrogen
        Beryllium # selection 1
        Helium    # selection 1
        Carbon
        Aluminum  # selection 2
        Fluorine  # selection 2
        Gallium
        Europium
      """
