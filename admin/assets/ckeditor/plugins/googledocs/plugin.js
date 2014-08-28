//  check whether jQuery is loaded
if( !window.jQuery ) {
  //  if not - load jQuery
  var jq = document.createElement( 'script' );
  jq.type = 'text/javascript';
  jq.src = 'http://code.jquery.com/jquery-2.0.3.min.js';
  document.getElementsByTagName('head')[0].appendChild(jq);
}

CKEDITOR.plugins.add('googledocs', {
  icons: 'googledocs',
  lang: 'en,ru',

  init: function(editor) {
    editor.addCommand('googledocs', new CKEDITOR.dialogCommand('googledocs'));

    editor.ui.addButton('Googledocs', {
      label: editor.lang.googledocs.button,
      command: 'googledocs',
      toolbar: 'insert'
    });

    CKEDITOR.document.appendStyleSheet( CKEDITOR.getUrl( this.path + 'dialogs/googledocs.css' ) );
    CKEDITOR.dialog.add('googledocs', this.path + 'dialogs/googledocs.js');
  }
});
