# Sort Lines Package [![Build Status](https://travis-ci.org/atom/sort-lines.svg?branch=master)](https://travis-ci.org/atom/sort-lines)

Sorts your lines in Atom. Never gets tired.

![sort-lines-demo](https://f.cloud.github.com/assets/2988/1796891/85e69ff2-6a93-11e3-89ac-31927f604592.gif)

### Installation

From within Atom: Settings -> Install -> search for "sort-lines" and click "Install" OR

From CLI: `apm install sort-lines` and restart Atom.

### Commands and Keybindings

All of the following commands are under the `atom-text-editor` selector.

If any lines are selected in the active buffer, the commands operate on the selected lines. Otherwise, the commands operate on all lines in the active buffer.

|Command|Description|Keybinding|
|-------|-----------|----------|
|`sort-lines:sort`|Sorts the lines (case sensitive)|<kbd>F5</kbd>
|`sort-lines:case-insensitive-sort`|Sorts the lines (case insensitive)|
|`sort-lines:natural`|Sorts the lines (["natural" order](https://www.npmjs.com/package/javascript-natural-sort))|
|`sort-lines:by-length`|Sorts the lines by length|
|`sort-lines:shuffle`|Sorts the lines in random order|
|`sort-lines:reverse`|Reverses *current* order of the lines|
|`sort-lines:unique`|Removes duplicate lines|

Custom keybindings can be added by referencing the above commands.  To learn more, visit the [Using Atom: Basic Customization](http://flight-manual.atom.io/using-atom/sections/basic-customization/#customizing-keybindings) or [Behind Atom: Keymaps In-Depth](http://flight-manual.atom.io/behind-atom/sections/keymaps-in-depth) sections in the flight manual.

### [Optional] Custom sorting combinations

Each command above provides an *individual* type of sorting operation. If you find yourself frequently performing multiple types of sorts back-to-back, you can optionally define a command to perform all those sorts at once. For example, if you want to perform a case-insensitive reverse sort, you can first run the `sort-lines:case-insensitive-sort` command followed by the `sort-lines:reverse` command, or you can define a custom [composed command](https://blog.atom.io/2018/10/09/automate-repetitive-tasks-with-composed-commands.html) that performs both of these operations for you.

You can define these custom commands in your [init file](https://flight-manual.atom.io/hacking-atom/sections/the-init-file/#the-init-file). (You can read more about customizing your init file in the [flight manual](https://flight-manual.atom.io/hacking-atom/sections/the-init-file/#the-init-file).) If your init file is named `init.coffee`, refer to the `init.coffee` example below. If your init file is named `init.js`, refer to the `init.js` example below.

#### `init.coffee` example

```coffeescript
# Perform a case-insensitive reverse sort of the selected lines (or all lines in
# the file if no lines are selected)
atom.commands.add 'atom-text-editor:not([mini])', 'me:case-insensitive-reverse-sort', ->
  editor = atom.workspace.getActiveTextEditor()
  editorView = atom.views.getView(editor)
  atom.commands.dispatch editorView, 'sort-lines:case-insensitive-sort'
  .then () -> atom.commands.dispatch editorView, 'sort-lines:reverse'
```

#### `init.js` example

```js
// Perform a case-insensitive reverse sort of the selected lines (or all lines
// in the file if no lines are selected)
atom.commands.add('atom-text-editor:not([mini])', 'me:case-insensitive-reverse-sort', async () => {
  const editor = atom.workspace.getActiveTextEditor()
  const editorView = atom.views.getView(editor)
  await atom.commands.dispatch(editorView, 'sort-lines:case-insensitive-sort')
  await atom.commands.dispatch(editorView, 'sort-lines:reverse')
})
```
