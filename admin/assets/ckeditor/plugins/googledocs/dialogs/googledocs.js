CKEDITOR.dialog.add('googledocs', function (editor) {
  return {
    title: editor.lang.googledocs.title,
    width: 400,
    height: 350,

    onLoad : function() {
      getDocuments();
    },

    contents:
    [
      //  document settings tab
      {
        id: 'settingsTab',
        label: editor.lang.googledocs.settingsTab,
        elements:
        [
          //  select
          {
            type: 'select',
            id: 'documents',
            className: 'googledocs',
            label: editor.lang.googledocs.selectDocument,
            items: [],
            'default': '',
            size: 4,
            onChange: function( api ) {
              var dialog = CKEDITOR.dialog.getCurrent();
              var url = dialog.getContentElement('settingsTab', 'txtUrl');
              url.setValue( this.getValue() );
            }
          },
          //  url
          {
            type: 'text',
            id: 'txtUrl',
            label: editor.lang.googledocs.url,
            required: true,
            validate: CKEDITOR.dialog.validate.notEmpty( editor.lang.googledocs.alertUrl )
          },
          //  options
          {
            type: 'hbox',
            widths: [ '60px', '330px' ],
            className: 'googledocs',
            children:
            [
              //  width
              {
                type: 'text',
                width: '45px',
                id: 'txtWidth',
                label: editor.lang.common.width,
                'default': 710,
                required: true,
                validate: CKEDITOR.dialog.validate.integer( editor.lang.googledocs.alertWidth )
              },
              //  height
              {
                type: 'text',
                id: 'txtHeight',
                width: '45px',
                label: editor.lang.common.height,
                'default': 920,
                required: true,
                validate: CKEDITOR.dialog.validate.integer( editor.lang.googledocs.alertHeight )
              }
            ]
          }
        ]
      },
      //  upload tab
      {
        id: 'uploadTab',
        label: editor.lang.googledocs.uploadTab,
        filebrowser: 'uploadButton',
        elements:
        [
          //  file input
          {
            type: 'file',
            id: 'upload'
          },
          //  submit button
          {
            type: 'fileButton',
            id: 'uploadButton',
            label: editor.lang.googledocs.btnUpload,
            filebrowser: {
              action: 'QuickUpload',
//              target: 'settingsTab:txtUrl',
              onSelect: function( fileUrl, data ) {
                getDocuments( fileUrl );
              }
            },
            'for': [ 'uploadTab', 'upload' ]
          }
        ]
      }
    ],
    onOk: function() {
      var dialog = this;
      var iframe = editor.document.createElement( 'iframe' );
      var srcEncoded = encodeURIComponent( dialog.getValueOf( 'settingsTab', 'txtUrl' ) );
      iframe.setAttribute( 'src',     'http://docs.google.com/viewer?url=' + srcEncoded + '&embedded=true' );
      iframe.setAttribute( 'width',   dialog.getValueOf( 'settingsTab', 'txtWidth' ) );
      iframe.setAttribute( 'height',  dialog.getValueOf( 'settingsTab', 'txtHeight' ) );
      iframe.setAttribute( 'style',   'border: none;' );
      editor.insertElement( iframe );
    },
    onShow: function() {
      getDocuments();
    }
  };
});

//  get documents list in format [[document1_name, document1_url],[document2_name, document2_url], ...]
var getDocuments = function( url ) {
  if( CKEDITOR.env.ie7Compat ) {
    fixIE7display();
  }
  $.get( CKEDITOR.currentInstance.config.filebrowserGoogledocsBrowseUrl, function( data ) {
    var dialog = CKEDITOR.dialog.getCurrent();
    var documents = dialog.getContentElement('settingsTab', 'documents');
    documents.clear();
    $.each( data, function( index, document ) {
      documents.add( document.name, document.url );
    });
    documents.setValue( url );
    console.log( url );
    url && documents.focus();
  }, "json" );
};
