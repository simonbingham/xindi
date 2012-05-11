$( function() {

	// return to top of page
	$( "#top-of-page" ).click(function(e){
		$( "html,body" ).animate( { scrollTop: 0 }, "slow" );
		e.preventDefault();	
	});
	
	// delete confirmation
	$( "a[title~='Delete']" ).click(function(){
		return confirm( "Delete this item?" );
	});

	// populate navigation title when page title is entered
	$( "#page-form input#title" ).blur(function(){
		var navigationtitle = $( "input#navigationtitle" )
		if( navigationtitle.val().length==0 ) navigationtitle.val( $( this ).val() );
	});
	
	// text editor configuration
	var currentURI = document.location.href;
	CKEDITOR.config[ "baseHref" ] = currentURI.substring( 0, currentURI.indexOf( "index.cfm" ) );
	CKEDITOR.config.toolbar_Full =
	[
		{ name: "document", items : [ "Source", "-", "Save", "NewPage", "DocProps", "Preview", "Print", "-", "Templates" ] },
		{ name: "clipboard", items : [ "Cut", "Copy", "Paste", "PasteText", "PasteFromWord", "-", "Undo", "Redo" ] },
		{ name: "editing", items : [ "Find", "Replace", "-", "SelectAll", "-", "SpellChecker", "Scayt" ] },
		{ name: "forms", items : [ "Form", "Checkbox", "Radio", "TextField", "Textarea", "Select", "Button", "ImageButton", 
	        "HiddenField" ] },
		"/",
		{ name: "basicstyles", items : [ "Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript", "-", "RemoveFormat" ] },
		{ name: "paragraph", items : [ "NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", "Blockquote", "CreateDiv",
		"-", "JustifyLeft", "JustifyCenter", "JustifyRight", "JustifyBlock", "-", "BidiLtr", "BidiRtl" ] },
		{ name: "links", items : [ "Link", "Unlink", "Anchor" ] },
		{ name: "insert", items : [ "Image", "Flash", "Table", "HorizontalRule", "Smiley", "SpecialChar", "PageBreak", "Iframe" ] },
		"/",
		{ name: "styles", items : [ "Styles", "Format", "Font", "FontSize" ] },
		{ name: "colors", items : [ "TextColor", "BGColor" ] },
		{ name: "tools", items : [ "Maximize", "ShowBlocks", "-", "About" ] }
	];
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
	CKEDITOR.config.toolbar_Basic =
	[
		["Bold", "Italic", "-", "NumberedList", "BulletedList", "-", "Link", "Unlink","-","About"]
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