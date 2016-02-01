# Sort Lines Package [![Build Status](https://travis-ci.org/atom/sort-lines.svg?branch=master)](https://travis-ci.org/atom/sort-lines)

Sorts your lines in Atom, never gets tired.

![sort-lines-demo](https://f.cloud.github.com/assets/2988/1796891/85e69ff2-6a93-11e3-89ac-31927f604592.gif)

### Commands and Keybindings

All of the following commands are under the `atom-text-editor` selector.

If any lines are selected in the active buffer, the commands operate on the selected lines. Otherwise, the commands operate on all lines in the active buffer.

|Command|Description|
|-------|-----------|
|`sort-lines:sort`|Sorts the lines (case sensitive)|
|`sort-lines:case-insensitive-sort`|Sorts the lines (case insensitive)|
|`sort-lines:reverse-sort`|Sorts the lines in reverse order (case sensitive)|
|`sort-lines:unique`|Removes duplicate lines|
|`sort-lines:natural`|Sorts the lines (["natural" order](https://en.wikipedia.org/wiki/Natural_sort_order))|

You may want to use keyboard shortcuts for triggering the above commands. This package does not provide keyboard shortcuts by default, but you can easily [define your own](https://atom.io/docs/latest/using-atom-basic-customization#customizing-key-bindings). To learn more, visit the [Using Atom: Basic Customization](https://atom.io/docs/latest/using-atom-basic-customization#customizing-key-bindings) or [Behind Atom: Keymaps In-Depth](https://atom.io/docs/latest/behind-atom-keymaps-in-depth) sections in the [Flight Manual](https://atom.io/docs/latest/).
