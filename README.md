# Sort Lines Package [![Build Status](https://travis-ci.org/atom/sort-lines.svg?branch=master)](https://travis-ci.org/atom/sort-lines)

Sorts your lines in Atom, never gets tired.

![sort-lines-demo](https://f.cloud.github.com/assets/2988/1796891/85e69ff2-6a93-11e3-89ac-31927f604592.gif)

## Key Mappings

By default, `f5` will be bound to the `sort-lines:sort` command, which is case sensitive.

To bid it to case-insensitive sort instead, edit your keymap file (see *Settings* > *Keybindings*) and add the following:

```
'atom-text-editor':
  'f5': 'sort-lines:case-insensitive-sort'
```
