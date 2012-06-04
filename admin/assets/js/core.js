jQuery( function($) {

	// validator defaults
	$.validator.setDefaults({
		errorClass: 'error', 
		errorElement: 'span',
	    highlight: function(element) {
	        $(element).parent().parent().addClass("error");
	    },
	    unhighlight: function(element) {
	        $(element).parent().parent().removeClass("error");
	    }
	});

	// return to top of page
	$( "#top-of-page" ).click(function(e){
		$( "html,body" ).animate( { scrollTop: 0 }, "slow" );
		e.preventDefault();	
	});
	
	// delete confirmation
	$( "a[title~='Delete']" ).click(function(){
		return confirm( "Delete this item?" );
	});

	// populate title when page title is entered
	$( "#page-form input#title" ).blur(function(){
		var title = $( "input#title" )
		if( title.val().length==0 ) title.val( $( this ).val() );
	});

	// text editor configuration
	$( "form" ).bind( "submit", function(){
		if( typeof CKEDITOR != "undefined" ){
			for( instance in CKEDITOR.instances ){
				CKEDITOR.instances[ instance ].updateElement();
			}
		}
	});
	var currentURI = document.location.href;
	CKEDITOR.config[ "baseHref" ] = currentURI.substring( 0, currentURI.indexOf( "index.cfm" ) );
	CKEDITOR.config.toolbar_Custom =
	[
		{ name: "document", items : [ "Source" ] },
		{ name: "clipboard", items : [ "Cut", "Copy", "Paste", "PasteText", "PasteFromWord", "-", "Undo", "Redo" ] },
		{ name: "editing", items : [ "Find", "Replace", "-", "SelectAll" ] },
		{ name: "styles", items : [ "Styles", "Format", "Font", "FontSize" ] },
		{ name: "colors", items : [ "TextColor", "BGColor" ] },
		{ name: "tools", items : [ "Maximize", "ShowBlocks" ] },		
		"/",
		{ name: "basicstyles", items : [ "Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript", "-", "RemoveFormat" ] },
		{ name: "paragraph", items : [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "Blockquote", "CreateDiv",
		"-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock", "-", "BidiLtr", "BidiRtl" ] },
		{ name: "links", items : [ "Link", "Unlink", "Anchor" ] },
		{ name: "insert", items : [ "Image", "Flash", "Table", "HorizontalRule", "SpecialChar", "PageBreak", "Iframe" ] }
	];
	CKEDITOR.config[ "toolbar" ] = "Custom";
	CKEDITOR.config[ "height" ] = 400;
	CKEDITOR.config[ "uiColor" ] = "##ddd"; 
	CKEDITOR.config[ "contentsCss" ] = CKEDITOR.config[ "baseHref" ] + "assets/css/core.css";
	CKEDITOR.config[ "skin" ] = "kama";
	CKEDITOR.config[ "bodyId" ] = "content";
	fileBrowserpath = CKEDITOR.config[ "baseHref" ] + "index.cfm?action=admin:filemanager.configure&";
	CKEDITOR.config[ "filebrowserBrowseUrl" ] = fileBrowserpath + "editorType=cke&EDITOR_RESOURCE_TYPE=file";
	CKEDITOR.config[ "filebrowserImageBrowseUrl" ] = fileBrowserpath + "editorType=cke&EDITOR_RESOURCE_TYPE=image";
	CKEDITOR.config[ "filebrowserFlashBrowseUrl" ] = fileBrowserpath + "editorType=cke&EDITOR_RESOURCE_TYPE=flash";
	CKEDITOR.config[ "filebrowserUploadUrl" ] = "";
	CKEDITOR.config[ "filebrowserImageUploadUrl" ] = "";
	CKEDITOR.config[ "filebrowserFlashUploadUrl" ] = "";
	
} );