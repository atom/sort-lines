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
|`sort-lines:reverse-sort`|Sorts the lines in reverse order (case sensitive)|
|`sort-lines:by-length`|Sorts the lines by length|
|`sort-lines:by-length-reversed`|Sorts the lines by length in reverse order|
|`sort-lines:shuffle`|Sorts the lines in random order|
|`sort-lines:unique`|Removes duplicate lines|

Custom keybindings can be added by referencing the above commands.  To learn more, visit the [Using Atom: Basic Customization](http://flight-manual.atom.io/using-atom/sections/basic-customization/#customizing-keybindings) or [Behind Atom: Keymaps In-Depth](http://flight-manual.atom.io/behind-atom/sections/keymaps-in-depth) sections in the flight manual.
