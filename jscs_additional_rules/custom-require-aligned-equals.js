var assert = require( 'assert' );

module.exports = function() {};

module.exports.prototype = {

  configure: function( options ) {
    assert( options === true, this.getOptionName() + ' option requires a true value or should be removed' );
  },

  getOptionName: function() {
    return 'customRequireAlignedEquals';
  },

  check: function( file, errors ) {
    file.iterateNodesByType( 'VariableDeclarator', function( node ) {
      var loc;
      var pos = node.parentNode.parentCollection.indexOf( node.parentNode );

      if ( pos < node.parentNode.parentCollection.length - 1 ) {
        var sibling = node.parentNode.parentCollection[pos + 1];
        if ( sibling.type === 'ExpressionStatement' &&
             sibling.expression.type === 'AssignmentExpression' &&
             // Only care about assignments on neighboring lines
             node.init.loc.start.line + 1 === sibling.expression.right.loc.start.line &&
             node.init.loc.start.column !== sibling.expression.right.loc.start.column ) {
            loc = node.init.loc.end;
            loc.column += 1;
            errors.add( 'New line required', loc );
        } else if ( sibling.type === 'VariableDeclaration' &&
                    sibling.declarations[0].type === 'VariableDeclarator' &&
                    // Only care about assignments on neighboring lines
                    node.init.loc.start.line + 1 === sibling.declarations[0].init.loc.start.line &&
                    node.init.loc.start.column !== sibling.declarations[0].init.loc.start.column ) {
          // Require a new line between a single line assignment statement and multiline assignment
          if ( sibling.declarations[0].init.loc.start.line !== sibling.declarations[0].init.loc.end.line ) {
            loc = node.init.loc.end;
            loc.column += 1;
            errors.add( 'New line required', loc );
          } else {
            errors.add( 'Alignment required', node.init.loc.start );
          }
        }
      }
    } );

    file.iterateNodesByType( 'AssignmentExpression', function( node ) {
      var pos = node.parentNode.parentCollection.indexOf( node.parentNode );

      if ( pos < node.parentNode.parentCollection.length - 1 ) {
        var sibling = node.parentNode.parentCollection[pos + 1];
        if ( sibling.type === 'ExpressionStatement' &&
             sibling.expression.type === 'AssignmentExpression' &&
             // Only care about assignments on neighboring lines
             node.right.loc.start.line + 1 === sibling.expression.right.loc.start.line &&
             node.right.loc.start.column !== sibling.expression.right.loc.start.column ) {
          // Require a new line between a single line assignment statement and multiline assignment
          if ( sibling.expression.right.loc.start.line !== sibling.expression.right.loc.end.line ) {
            var loc = node.right.loc.end;
            loc.column += 1;
            errors.add( 'New line required', loc );
          } else {
            errors.add( 'Alignment required', node.right.loc.start );
          }
        }
      }
    } );
  }

};
