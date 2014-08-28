/**
 * @author: Önder Ceylan <onderceylan@gmail.com>
 * @copyright Copyright (c) 2013 - Önder Ceylan. All rights reserved.
 * @license Licensed under the terms of GPL, LGPL and MPL licenses.
 * @version 1.0
 *
 * Date: 5/9/13
 * Time: 5:14 PM
 */

CKEDITOR.plugins.add('texttransform',
    {

        // define lang codes for available lang files here
        lang: 'en,tr',

        // plugin initialise
        init: function(editor)
        {
            // set num for switcher loop
            var num = 0;

            // add transformTextSwitch command to be used with button
            editor.addCommand('transformTextSwitch',
                {
                    exec : function()
                    {
                        var selection = editor.getSelection();
                        var commandArray = ['transformTextToUppercase', 'transformTextToLowercase', 'transformTextCapitalize'];

                        if (selection.getSelectedText().length > 0) {

                            selection.lock();

                            editor.execCommand( commandArray[num] );

                            selection.unlock(true);

                            if (num < commandArray.length - 1) {
                                num++;
                            } else {
                                num = 0;
                            }

                        }
                    }
                });

            // add transformTextToUppercase command to be used with buttons and 'execCommand' method
            editor.addCommand('transformTextToUppercase',
                {
                    exec : function()
                    {
                        var selection = editor.getSelection();

                        if (selection.getSelectedText().length > 0) {

                            if (editor.langCode == "tr") {
                                editor.insertHtml(selection.getSelectedText().trToUpperCase());
                            } else {
                                editor.insertHtml(selection.getSelectedText().toUpperCase());
                            }

                        }
                    }
                });

            // add transformTextToUppercase command to be used with buttons and 'execCommand' method
            editor.addCommand('transformTextToLowercase',
                {
                    exec : function()
                    {
                        var selection = editor.getSelection();

                        if (selection.getSelectedText().length > 0) {

                            if (editor.langCode == "tr") {
                                editor.insertHtml(selection.getSelectedText().trToLowerCase());
                            } else {
                                editor.insertHtml(selection.getSelectedText().toLowerCase());
                            }
                        }

                    }
                });

            // add transformTextSwitch command to be used with buttons and 'execCommand' method
            editor.addCommand( 'transformTextCapitalize',
                {
                    exec : function()
                    {
                        var selection = editor.getSelection();
                        if (selection.getSelectedText().length > 0) {

                            var capitalized;

                            if (editor.langCode == "tr") {
                                capitalized = (selection.getSelectedText()).replace(/\w\S*/g, function(txt){return txt.charAt(0).trToUpperCase() + txt.substr(1).trToLowerCase();});
                                editor.insertHtml(capitalized);
                            } else {
                                capitalized = (selection.getSelectedText()).replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
                                editor.insertHtml(capitalized);
                            }

                        }
                    }
                });

            // add TransformTextSwitcher button to editor
            editor.ui.addButton('TransformTextSwitcher',
                {
                    label: editor.lang.texttransform.transformTextSwitchLabel,
                    command: 'transformTextSwitch',
                    icon: this.path + 'images/transformSwitcher.png'
                } );

            // add TransformTextToLowercase button to editor
            editor.ui.addButton('TransformTextToLowercase',
                {
                    label: editor.lang.texttransform.transformTextToLowercaseLabel,
                    command: 'transformTextToLowercase',
                    icon: this.path + 'images/transformToLower.png'
                } );

            // add TransformTextToUppercase button to editor
            editor.ui.addButton('TransformTextToUppercase',
                {
                    label: editor.lang.texttransform.transformTextToUppercaseLabel,
                    command: 'transformTextToUppercase',
                    icon: this.path + 'images/transformToUpper.png'
                } );

            // add TransformTextCapitalize button to editor
            editor.ui.addButton('TransformTextCapitalize',
                {
                    label: editor.lang.texttransform.transformTextCapitalizeLabel,
                    command: 'transformTextCapitalize',
                    icon: this.path + 'images/transformCapitalize.png'
                } );
        }
    } );
