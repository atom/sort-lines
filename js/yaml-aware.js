/**
 * @author denim2x <denim2x@cyberdude.com>
 * @license MIT
 *
 * Provides sorting methods for YAML code;
 * uses the 'yaml-js' module to parse input text
 * into a workable AST (abstract syntax tree)
 */
"use strict";

let
  yaml = require('yaml-js'),
  assets = require("./assets"),

  merge_sort = assets.merge_sort,
  Range = assets.Range;


module.exports = function (sortTextLines) {
  function sort (editor, refine) {
    return sortTextLines(editor, function (textLines) {
      try {
        // Get the AST of the original text; it's
        // annotated with line numbers which offers
        // considerable convenience for further
        // processing
        let ast = yaml.compose(textLines.join("\n"));

        // Get the block ranges before sorting
        let before = ast.value.map(getRange);

        // Idem for after
        let after = merge_sort(before, sortRanges);

        // Refine the ranges 'before sorting' (and
        // implicitly 'after sorting' (since the two
        // contain exactly the same items
        refine && refine(textLines, before);

        // This is where the _actual_ sorting occurs;
        // here the textLines are rearranged according
        // to the ordering within 'after'
        let result = [], pos = 0;
        for (let i of Range(before.length)) {
          let b = before[i], a = after[i];
          if (pos < b[0]) {
            subsume(pos, b[0]);
          }
          pos = b[1];
          subsume(a[0], a[1]);
        }
        return subsume(pos);

        function subsume (start, end) {
          if (arguments.length == 1) {
            end = textLines.length;
          }
          for (let i of Range(start, end)) {
            result.push(textLines[i]);
          }
          return result;
        }
      } catch (e) {
        let msg, detail = "An exception of type '" + e.constructor.name +
          "' has been thrown while applying sort-lines:yaml-aware " +
          "to this selection";
        if (e.constructor.name == "ScannerError") {
          msg = "This selection doesn't constitute valid YAML code";
          detail += " (" + e.message + ")";
        } else {
          msg = e.message;
        }
        atom.notifications.addError(msg, {detail, dismissable: true});
      }
    });
  }

  return {
    /**
     * Handles comments in a 'roaming' manner - each
     * block is followed by the group of comments
     * preceding it (if any)
     */
    roaming: editor => sort(editor, function (textLines, before) {
      before[-1] = {1: 0};

      // This loop basically updates the staring position
      // of each range to include the group of comments
      // preceding it
      for (let i of Range(before.length - 1, -1)) {
        let b = before[i], p = before[i - 1];
        for (let j of Range(b[0] - 1, p[1] - 1)) {
          // Empty lines behave as potential 'delimiters'
          // between blocks, so they are simply skipped
          if (/^[ \t]*$/.test(textLines[j])) break;

          // This position might be the start of a group
          // of comments
          b[0] = j;
        }
      }

      delete before[-1];
    }),

    /**
     * Handles comments steadily - they aren't shifted
     * in any way
     */
    steady: editor => sort(editor)
  };
};

function getRange (item, index) {
  let start = item[0], end = item[1];
  if (end.constructor.name == "SequenceNode") {
    end = end.value.slice(-1)[0];
  }

  let range = [start.start_mark.line, end.end_mark.line + 1];
  range.value = start.value;
  range.size = range[1] - range[0];
  return range;
}

function sortRanges (a, b) {
  return a.value.localeCompare(b.value);
}
