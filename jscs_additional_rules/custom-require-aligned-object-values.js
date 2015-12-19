// This file is not in our code style so upstream merge should be easier
// original version: https://github.com/jscs-dev/node-jscs/blob/681e95329b69da62f7e448407df7b23c6d25e623/lib/rules/require-aligned-object-values.js

/**
 * Requires proper alignment in object literals.
 *
 * Type: `String`
 *
 * Values:
 *  - `"all"` for strict mode,
 *  - `"ignoreFunction"` ignores objects if one of the property values is a function expression,
 *  - `"ignoreLineBreak"` ignores objects if there are line breaks between properties
 *
 * #### Example
 *
 * ```js
 * "requireAlignedObjectValues": "all"
 * ```
 *
 * ##### Valid
 * ```js
 * var x = {
 *     a   : 1,
 *     bcd : 2,
 *     ef  : 'str'
 * };
 * ```
 * ##### Invalid
 * ```js
 * var x = {
 *     a : 1,
 *     bcd : 2,
 *     ef : 'str'
 * };
 * ```
 */

var assert = require('assert');

module.exports = function() {};

module.exports.prototype = {

    configure: function(mode) {
        var modes = {
            'all': 'all',
            'ignoreFunction': 'ignoreFunction',
            'ignoreLineBreak': 'ignoreLineBreak',
            'skipWithFunction': 'ignoreFunction',
            'skipWithLineBreak': 'ignoreLineBreak'
        };
        assert(
            typeof mode === 'string' && modes[mode],
            this.getOptionName() + ' requires one of the following values: ' + Object.keys(modes).join(', ')
        );
        this._mode = modes[mode];
    },

    getOptionName: function() {
        return 'customRequireAlignedObjectValues';
    },

    check: function(file, errors) {
        var mode = this._mode;

        file.iterateNodesByType('ObjectExpression', function(node) {
            if (node.properties < 2) {
                return;
            }

            var i = 0;
            var maxKeyEndPos = [0];
            var tokens = [];
            var optionalMaxKeyEndPos = [0];
            var skip = node.properties.some(function(property, index) {
                if ((index > 0 &&
                     node.properties[index - 1].loc.start.line !== property.loc.start.line - 1)) {
                  i++;
                  maxKeyEndPos.push(0);
                  optionalMaxKeyEndPos.push(0);
                }

                if (mode === 'ignoreFunction' && property.value.type === 'FunctionExpression') {
                    return true;
                }

                if (mode === 'ignoreLineBreak' && index > 0 &&
                     node.properties[index - 1].loc.end.line !== property.loc.start.line - 1) {
                    return true;
                }

                if (property.loc.start.line === property.loc.end.line) {
                    maxKeyEndPos[i] = Math.max(maxKeyEndPos[i], property.key.loc.end.column);
                } else {
                    optionalMaxKeyEndPos[i] = Math.max(optionalMaxKeyEndPos[i], property.key.loc.end.column);
                }

                var keyToken = file.getFirstNodeToken(property.key);
                var colon = file.getNextToken(keyToken);
                var value = file.getNextToken(colon);
                tokens.push({key: keyToken, colon: colon, value: value});
            });

            if (skip) {
                return;
            }

            i = 0;

            tokens.forEach(function(pair, index) {
                if ((index > 0 && tokens[index - 1].key.loc.start.line !== pair.value.loc.start.line - 1)) {
                  i++;
                }

                if (pair.key.loc.start.line === pair.value.loc.end.line) {
                    if (needsAlignment(i, pair.value.loc.start.column)) {
                        errors.assert.spacesBetween({
                            token: pair.colon,
                            nextToken: pair.value,
                            exactly: maxKeyEndPos[i] - pair.value.loc.start.column,
                            message: 'Alignment required'
                        });
                    }
                } else {
                    // Ensure there is at least one space before the start of multiline values
                    if (pair.value.loc.start.column !== pair.key.loc.end.column + 2 &&
                        needsAlignment(i-1, pair.value.loc.start.column)) {
                        errors.assert.spacesBetween({
                            token: pair.colon,
                            nextToken: pair.value,
                            exactly: maxKeyEndPos[i-1] - pair.value.loc.start.column,
                            message: 'Alignment required'
                        });
                    }
                }
            });

            function needsAlignment(index, column) {
                // The value start column should be two away from either
                // a. the max key end position
                // b. the max key end position of multiline values (if it is longer than the single line max)
                // c. the max of all single line key end positions
                // d. the max of all key end positions
                return column !== maxKeyEndPos[index] + 2 &&
                       (optionalMaxKeyEndPos[index] < maxKeyEndPos[index] ||
                        column !== optionalMaxKeyEndPos[index] + 2) &&
                       column !== Math.max.apply(null, maxKeyEndPos) + 2 &&
                       column !== Math.max.apply(null, maxKeyEndPos.concat(optionalMaxKeyEndPos)) + 2;
            }
        });
    }

};

