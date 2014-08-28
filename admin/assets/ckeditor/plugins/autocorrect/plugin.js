/**
 * @license TODO
 */

/**
 * @fileOverview TODO
 */

(function() {
	CKEDITOR.plugins.add( 'autocorrect', {
		requires: 'menubutton',
		lang: 'en,ru',
		icons: 'autocorrect',
		init: function( editor ) {
			var config = editor.config;
			var lang = editor.lang.autocorrect;

			editor.addCommand( 'autocorrect', {
				exec: function(editor) {
					editor.fire( 'saveSnapshot' );
					var selectedRange = editor.getSelection().getRanges().shift();
					var bookmark = selectedRange.createBookmark();

					var walkerRange;
					if (selectedRange.collapsed) {
						walkerRange = new CKEDITOR.dom.range(editor.editable());
						walkerRange.selectNodeContents(editor.editable());
					} else {
						walkerRange = selectedRange.clone();
					}

					var walker = new CKEDITOR.dom.walker( walkerRange );
					editor.editable().$.normalize();
					walker.evaluator = function( node ) { return node.type === CKEDITOR.NODE_TEXT && !isBookmark(node) };
					var node;
					while (node = walker.next()) {
						var next = getNext(node);
						var parent = getBlockParent(node);
						correctTextNode(node, (parent.isBlockBoundary() && !next) || next && next.type === CKEDITOR.NODE_ELEMENT && next.getName() === 'br');
						if (parent.getName() === 'p' && !skipBreaks(next)) {
							correctParagraph(parent);
						}
					}

					editor.getSelection().selectBookmarks([bookmark]);
					editor.fire( 'saveSnapshot' );
				}
			} );

			var command = editor.addCommand('toggleAutocorrect', {
				preserveState: true,
				canUndo: false,

				exec: function( editor ) {
					this.setState(isEnabled() ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_ON);
				}
			});

			var isEnabled = function() {
				return command.state === CKEDITOR.TRISTATE_ON;
			};


			var menuGroup = 'autocorrectButton';
			editor.addMenuGroup( menuGroup );

			// combine menu items to render
			var uiMenuItems = {};

			// always added
			uiMenuItems.autoCorrectWhileTyping = {
				label: lang.disable,
				group: menuGroup,
				command: 'toggleAutocorrect'
			};

			uiMenuItems.autoCorrectNow = {
				label: lang.apply,
				command: 'autocorrect',
				group: menuGroup
			};

			editor.addMenuItems( uiMenuItems );

			editor.ui.add( 'AutoCorrect', CKEDITOR.UI_MENUBUTTON, {
				label: lang.toolbar,
				modes: { wysiwyg: 1 },
				toolbar: 'spellchecker,20',
				onRender: function() {
					command.on( 'state', function() {
						this.setState( command.state );
					}, this );
				},
				onMenu: function() {
					editor.getMenuItem( 'autoCorrectWhileTyping' ).label = isEnabled() ? lang.disable : lang.enable;

					return {
						autoCorrectWhileTyping: CKEDITOR.TRISTATE_OFF,
						autoCorrectNow: CKEDITOR.TRISTATE_OFF
					};
				}
			});

			var showInitialState = function( evt ) {
				evt.removeListener();
				command.setState( config.autocorrect_enabled ? CKEDITOR.TRISTATE_ON : CKEDITOR.TRISTATE_OFF );
			};

			editor.on( 'instanceReady', showInitialState );

			var isTyping = false;

			var horizontalRuleMarkers = ['-', '_'];
			var bulletedListMarkers = ['\\*', '\\+', '•'];
			var numberedListMarkers = ['[0-9]+', '[ivxlcdm]+', '[IVXLCDM]+', '[a-z]', '[A-Z]'];

			var listItemContentPattern = '(?:.*?)[^\\.!,\\s](?:.*)';

			var isBookmark = CKEDITOR.dom.walker.bookmark();

			function skipBreaks(node, isBackwards) {
				while (node && node.type == CKEDITOR.NODE_ELEMENT && node.getName() == 'br') {
					node = isBackwards ? node.getPrevious() : node.getNext();
				}
				return node;
			}

			function isWhitespace(ch) {
				return ch === ' ' || ch === ' ';
			}

			function isPunctuation(ch) {
				return ch === '.' || ch === ',' || ch === '!' || ch === '?' || ch === '/';
			}

			function correctAtCursor(cursor, isEnter) {
				if (cursor.startContainer.type == CKEDITOR.NODE_ELEMENT) {
					var startNode = cursor.startContainer.getChild(cursor.startOffset - 1);
					// Firefox in some cases sets cursor after ending <br>
					startNode = skipBreaks(startNode, true);
					if (!startNode)
						return;
					cursor.setStart(startNode, startNode.getText().length);
					cursor.setEnd(startNode, startNode.getText().length);
				}

				var inputChar, leftChar;
				// Handles special case of Enter key press
				if (isEnter) {
					inputChar = '';
					leftChar = cursor.startContainer.getText().substring(cursor.startOffset-1, cursor.startOffset);
				} else {
					inputChar = cursor.startContainer.getText().substring(cursor.startOffset-1, cursor.startOffset);
					leftChar = cursor.startContainer.getText().substring(cursor.startOffset-2, cursor.startOffset - 1);
				}

				if (config.autocorrect_replaceDoubleQuotes && replaceDoubleQuote(inputChar, leftChar, cursor))
					return;

				if (config.autocorrect_replaceSingleQuotes && replaceSingleQuote(inputChar, leftChar, cursor))
					return;

				// bulleted and numbered lists
				if (isWhitespace(inputChar))
					autoCorrectOnWhitespace(cursor);

				if (isEnter || isPunctuation(inputChar) || isWhitespace(inputChar))
					autoCorrectOnDelimiter(cursor, inputChar);
			}

			function correctTextNode(node, isBlockEnding) {
				var cursor = new CKEDITOR.dom.range(editor.editable());
				cursor.setStart(node, 0);
				cursor.setEnd(node, 0);
				while (cursor.startOffset < cursor.startContainer.getText().length) {
					cursor.setStart(cursor.startContainer, cursor.startOffset + 1);
					cursor.setEnd(cursor.startContainer, cursor.startOffset);
					correctAtCursor(cursor, false);
					if (isBlockEnding && cursor.endOffset == cursor.startContainer.getText().length) {
						// "Emulate" Enter key
						correctAtCursor(cursor, true);
					}
				}

			}

			function correctParagraph(p) {
				if (!p)
					return;

				// FIXME this way is wrong
				var content = p.getText();

				if (config.autocorrect_createHorizontalRules && insertHorizontalRule(p, content))
					return;
			}

			function getNext(node) {
				var next = node.getNext();
				while (next && isBookmark(next)) {
					next = next.getNext();
				}
				return next;
			}

			function replacePrefix(range, prefix, delimiter) {
				// Format hyperlink
				if (config.autocorrect_recognizeUrls && formatHyperlink(range, prefix, delimiter))
					return;

				// Autoreplace using replacement table
				if (config.autocorrect_useReplacementTable && replaceSequence(range, prefix))
					return;

				// Format ordinals
				if (config.autocorrect_formatOrdinals && formatOrdinals(range, prefix))
					return;
			}
							// bulleted and numbered lists

			function autoCorrectOnWhitespace(cursor) {
				var range = new CKEDITOR.dom.range(editor.editable());
				range.setStart(cursor.startContainer, cursor.startOffset - 1);
				range.setEnd(cursor.endContainer, cursor.endOffset - 1);

				var offset = range.endOffset;
				var prefix = retreivePrefix(range);

				if (!prefix)
					return;

				if (config.autocorrect_formatBulletedLists && formatBulletedList(range, prefix))
					return;

				if (config.autocorrect_formatNumberedLists && formatNumberedList(range, prefix))
					return;

				var diff = offset - range.endOffset;
				cursor.setStart(cursor.startContainer, cursor.startOffset + diff);
				cursor.setEnd(cursor.endContainer, cursor.endOffset + diff);

				var leftChar = range.startContainer.getText().substring(range.startOffset-1, range.startOffset);

				// Replace hypen
				// TODO improve it
				if (config.autocorrect_replaceHyphens && leftChar == '-') {
					var charBeforeHyphen = range.startContainer.getText().substring(range.startOffset-2, range.startOffset-1);
					if (charBeforeHyphen == ' ' || charBeforeHyphen == ' ') {
						var dash = config.autocorrect_dash;
						beforeReplace();
						var text = range.startContainer.getText();
						range.startContainer.setText(text.substring(0, range.startOffset - 1) + dash + text.substring(range.startOffset));
						afterReplace();
					}
				}
			}

			function autoCorrectOnDelimiter(cursor, delimiter) {
				var range = new CKEDITOR.dom.range(editor.editable());
				range.setStart(cursor.startContainer, cursor.startOffset - delimiter.length);
				range.setEnd(cursor.endContainer, cursor.endOffset - delimiter.length);

				var offset = range.endOffset;
				var prefix = retreivePrefix(range);

				if (!prefix)
					return;

				replacePrefix(range, prefix, delimiter);

				var diff = offset - range.endOffset;
				cursor.setStart(cursor.startContainer, cursor.startOffset + diff);
				cursor.setEnd(cursor.endContainer, cursor.endOffset + diff);
			}

			function retreivePrefix(range) {
				if (range && range.startContainer && range.startContainer.$.data) {
					var chars = '';
					var startOffset = range.startOffset - 1;
					var ch = range.startContainer.$.data.substring(startOffset, startOffset + 1);
					while (ch && ch != ' ' && ch != ' ' && startOffset >= 0) {
						chars = ch + chars;
						ch = range.startContainer.$.data.substring(--startOffset, startOffset + 1);
					}
					return chars;
				}
				return '';
			}

			var bookmark;
			function beforeReplace() {
				if (!isTyping)
					return;
				editor.fire( 'saveSnapshot' );
				bookmark = editor.getSelection().getRanges().shift().createBookmark();
			}

			function afterReplace() {
				if (!isTyping)
					return;
				editor.getSelection().selectBookmarks([bookmark]);
				editor.fire( 'saveSnapshot' );
			}

			var replacementTable = config.autocorrect_replacementTable;
			function replaceSequence(range, prefix) {
				var replacement = replacementTable[prefix];
				if (!replacement)
					return false;

				beforeReplace();
				var text = range.startContainer.getText();
				range.startContainer.setText(text.substring(0, range.startOffset - prefix.length) + replacement + text.substring(range.startOffset));
				range.setEnd(range.endContainer, range.startOffset + prefix.length - 1);
				afterReplace();

				return true;
			}

			var urlRe = /(http:|https:|ftp:|mailto:|tel:|skype:|www\.)([^\s\.,?!#]|[\.,?!#](?=[^\s\.,?!#]))+/i;
			function formatHyperlink(range, prefix, delimiter) {
				if (isPunctuation(delimiter))
					return;
				var match = prefix.match(urlRe);
				if (!match)
					return false;

				var url = match[0];
				var href = match[1] === 'www.' ? 'http://' + url : url;

				beforeReplace();
				var attributes = {'data-cke-saved-href': href, href: href};
				var style = new CKEDITOR.style({ element: 'a', attributes: attributes } );
				style.type = CKEDITOR.STYLE_INLINE; // need to override... dunno why.
				range.setStart(range.startContainer, range.startOffset - prefix.length);
				range.setEnd(range.startContainer, range.startOffset + url.length);
				style.applyToRange( range.clone() );
				afterReplace();

				return true;
			}

			var suffixes = {st: true, nd: true, rd: true, th: true};
			function formatOrdinals(range, prefix) {
				var suffix = prefix.slice(-2);
				if (!(suffix in suffixes))
					return false;

				var number = prefix.slice(0, -2);
				var numberRe = /^\d+$/;
				if (!numberRe.test(number))
					return false;

				var n = number % 100;
				if (n > 9 && n < 20) {
					if (suffix !== 'th')
						return false;
				} else {
					n = number % 10;
					if (n == 1) {
						if (suffix !== 'st')
							return false;
					} else if (n == 2) {
						if (suffix !== 'nd')
							return false;
					} else if (n == 3) {
						if (suffix !== 'rd')
							return false;
					} else if (suffix !== 'th')
						return false;
				}

				beforeReplace();
				var style = new CKEDITOR.style({ element: 'sup' } );
				range.setStart(range.startContainer, range.startOffset - suffix.length);
				range.setEnd(range.startContainer, range.startOffset + suffix.length);
				style.applyToRange( range.clone() );
				afterReplace();

				return true;
			}

			var horizontalRuleRe = new RegExp('^' + '(' + horizontalRuleMarkers.map(function(marker){ return marker + '{3,}';}).join('|') + ')' + '$');
			function insertHorizontalRule(parent, content) {
				var match = content.match(horizontalRuleRe);
				if (!match)
					return false;

				var hr = editor.document.createElement( 'hr' );
				hr.replace(parent);

				return true;
			}

			var bulletedListItemRe = new RegExp('^' + '(' + bulletedListMarkers.join('|') + ')' + '$');
			function formatBulletedList(range, prefix) {
				if (range.startContainer.getPrevious() || range.startOffset > prefix.length )
					return false;

				var match = prefix.match(bulletedListItemRe);
				if (!match)
					return false;

				var parent = getBlockParent(range.startContainer);
				var marker = match[1];

				var firstChild = parent.getFirst();
				beforeReplace();
				firstChild.setText(firstChild.getText().substring(marker.length + 1));
				var previous = parent.getPrevious();
				if (!isTyping && previous && previous.type == CKEDITOR.NODE_ELEMENT && previous.getName() == 'ul') {
					appendContentsToList(parent, previous);
				} else {
					replaceContentsWithList([parent], 'ul', null);
				}
				afterReplace();

				return true;
			}

			var numberedListItemRe = new RegExp('^' + '(' + numberedListMarkers.join('|') + ')' + '[\\.\\)]' + '$');
			function formatNumberedList(range, prefix) {
				if (range.startContainer.getPrevious() || range.startOffset > prefix.length )
					return false;

				var match = prefix.match(numberedListItemRe);
				if (!match)
					return false;

				var parent = getBlockParent(range.startContainer);
				var start = match[1];
				var type;
				if (start.match(/\d/))
					type = '1';
				else if (start.match(/[ivxlcdm]+/))
					type = 'i';
				else if (start.match(/[IVXLCDM]+/))
					type = 'I';
				else if (start.match(/[a-z]/))
					type = 'a';
				else if (start.match(/[A-Z]/))
					type = 'A';

				beforeReplace();
				var firstChild = parent.getFirst();
				firstChild.setText(firstChild.getText().substring(start.length + 2));
				var startNumber = toNumber(start, type);
				var previous = parent.getPrevious();
				if (!isTyping && previous && previous.type == CKEDITOR.NODE_ELEMENT && previous.getName() == 'ol' && previous.getAttribute('type') == type && getLastNumber(previous) == startNumber - 1) {
					appendContentsToList(parent, previous);
				} else {
					var attributes = startNumber === 1 ? {type: type} : {type: type, start: startNumber};
					replaceContentsWithList([parent], 'ol', attributes);
				}
				afterReplace();

				return true;
			}

			var doubleQuotes = config.autocorrect_doubleQuotes;
			function replaceDoubleQuote(inputChar, leftChar, quoteRange) {
				if (inputChar !== '"')
					return false;

				replaceQuote(leftChar, doubleQuotes, quoteRange);
				return true;
			}

			var singleQuotes = config.autocorrect_singleQuotes;
			function replaceSingleQuote(inputChar, leftChar, quoteRange) {
				if (inputChar !== '\'')
					return false;

				replaceQuote(leftChar, singleQuotes, quoteRange);
				return true;
			}

			function replaceQuote(leftChar, quotes, range) {
				var isClosingQuote = leftChar && '  -'.indexOf(leftChar) < 0;
				var replacement = quotes[isClosingQuote ? 1 : 0];

				beforeReplace();
				var text = range.startContainer.getText();
				range.startContainer.setText(text.substring(0, range.endOffset - 1) + replacement + text.substring(range.endOffset));
				range.setStart(range.startContainer, range.endOffset);
				afterReplace();
			}

			function getBlockParent(node) {
				while (node && (node.type !== CKEDITOR.NODE_ELEMENT || (node.getName() in CKEDITOR.dtd.$inline || node.getName() in CKEDITOR.dtd.$empty ))) {
					node = node.getParent();
				}
				return node;
			}

			function getLastNumber(list) {
				return list.$.start + list.getChildCount() - 1;
			}

			function replaceContentsWithList(listContents, type, attributes) {
				// Insert the list to the DOM tree.
				var insertAnchor = listContents[ listContents.length - 1 ].getNext(),
					listNode = editor.document.createElement( type );

				var commonParent = listContents[0].getParent();

				var contentBlock;

				while ( listContents.length ) {
					contentBlock = listContents.shift();
					appendContentsToList(contentBlock, listNode);
				}

				// Apply list root dir only if it has been explicitly declared.
				// if ( listDir && explicitDirection )
				// 	listNode.setAttribute( 'dir', listDir );

				if (attributes)
					listNode.setAttributes(attributes);

				if ( insertAnchor )
					listNode.insertBefore( insertAnchor );
				else
					listNode.appendTo( commonParent );
			}

			function appendContentsToList(contentBlock, listNode) {
				var listItem = editor.document.createElement( 'li' );

				// If current block should be preserved, append it to list item instead of
				// transforming it to <li> element.
				if ( false /*shouldPreserveBlock( contentBlock )*/ )
					contentBlock.appendTo( listItem );
				else {
					contentBlock.copyAttributes( listItem );
					// Remove direction attribute after it was merged into list root. (#7657)
					/*if ( listDir && contentBlock.getDirection() ) {
						listItem.removeStyle( 'direction' );
						listItem.removeAttribute( 'dir' );
					}*/
					contentBlock.moveChildren( listItem );
					contentBlock.remove();
				}

				listItem.appendTo( listNode );
			}

			function characterPosition(character) {
				var alfa = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				return alfa.indexOf(character) + 1;
			}

			function toArabic(number) {
				if (!number) return 0;
				if (number.substring(0, 1) == "M") return 1000 + toArabic(number.substring(1));
				if (number.substring(0, 2) == "CM") return 900 + toArabic(number.substring(2));
				if (number.substring(0, 1) == "D") return 500 + toArabic(number.substring(1));
				if (number.substring(0, 2) == "CD") return 400 + toArabic(number.substring(2));
				if (number.substring(0, 1) == "C") return 100 + toArabic(number.substring(1));
				if (number.substring(0, 2) == "XC") return 90 + toArabic(number.substring(2));
				if (number.substring(0, 1) == "L") return 50 + toArabic(number.substring(1));
				if (number.substring(0, 2) == "XL") return 40 + toArabic(number.substring(2));
				if (number.substring(0, 1) == "X") return 10 + toArabic(number.substring(1));
				if (number.substring(0, 2) == "IX") return 9 + toArabic(number.substring(2));
				if (number.substring(0, 1) == "V") return 5 + toArabic(number.substring(1));
				if (number.substring(0, 2) == "IV") return 4 + toArabic(number.substring(2));
				if (number.substring(0, 1) == "I") return 1 + toArabic(number.substring(1));
			}

			function toNumber(start, type) {
				switch (type) {
					case '1':
						return start|0;
					case 'i':
						return toArabic(start.toUpperCase());
					case 'I':
						return toArabic(start);
					case 'a':
						return characterPosition(start.toUpperCase());
					case 'A':
						return characterPosition(start);
				}
			}

			editor.on( 'key', function( event ) {
				if (!isEnabled())
					return;
				if (editor.mode !== 'wysiwyg')
					return;
				if (event.data.keyCode != 2228237 && event.data.keyCode != 13)
					return;

				var cursor = editor.getSelection().getRanges().shift();
				var paragraph = null;

				if (event.data.keyCode === 13) {
					var parent = getBlockParent(cursor.startContainer);
					if (parent.getName() === 'p') {
						paragraph = parent;
					}
				}

				setTimeout(function() {
					isTyping = true;
					correctAtCursor(cursor, true);
					correctParagraph(paragraph);
					isTyping = false;
				});
			});

			editor.on( 'contentDom', function() {
				editor.editable().on( 'keypress', function( event ) {
					if (!isEnabled())
						return;
					if ( event.data.$.ctrlKey || event.data.$.metaKey )
						return;

					setTimeout(function() {
						isTyping = true;
						var cursor = editor.getSelection().getRanges().shift();
						correctAtCursor(cursor);
						isTyping = false;
					});
				});
			});
		}
	});

	CKEDITOR.plugins.autoreplace = {};

})();


CKEDITOR.config.autocorrect_enabled = true;
/**
 *
 *
 * @cfg
 * @member CKEDITOR.config
 */
// language specific

CKEDITOR.config.autocorrect_replacementTable = {"--": "–", "-->": "→", "-+": "±", "->": "→", "...": "…", "(c)": "©", "(r)": "®", "(tm)": "™", "(o)": "˚", "+-": "±", "<-": "←", "<--": "←", "<-->": "↔", "<->": "↔", "<<": "«", ">>": "»", "~=": "≈", "1/2": "½", "1/4": "¼", "3/4": "¾"};

CKEDITOR.config.autocorrect_useReplacementTable = true;

CKEDITOR.config.autocorrect_recognizeUrls = true;
// language specific
CKEDITOR.config.autocorrect_dash = '–';

CKEDITOR.config.autocorrect_replaceHyphens = true;

CKEDITOR.config.autocorrect_formatOrdinals = true;

CKEDITOR.config.autocorrect_replaceSingleQuotes = true;
// language specific
CKEDITOR.config.autocorrect_singleQuotes = "‘’";

CKEDITOR.config.autocorrect_replaceDoubleQuotes = true;
// language specific
CKEDITOR.config.autocorrect_doubleQuotes = "“”";

CKEDITOR.config.autocorrect_createHorizontalRules = true;

CKEDITOR.config.autocorrect_formatBulletedLists = true;

CKEDITOR.config.autocorrect_formatNumberedLists = true;

// XXX table autocreation?
// XXX upper first word of a sentense?
