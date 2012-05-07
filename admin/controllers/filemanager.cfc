/*
	Xindi - http://www.getxindi.com/
	
	Copyright (c) 2012, Simon Bingham
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

component accessors="true" extends="abstract"
{

	/*
	 * Dependency injection
	 */		

	property name="FileManagerService" setter="true" getter="false";

	/*
	 * Public methods
	 */	

	void function before( required struct rc )
	{
		rc.webrootdirectory = GetDirectoryFromPath( CGI.CF_TEMPLATE_PATH );
		rc.clientfilesdirectory = "_clientfiles";
		rc.subdirectory = "";
		if ( !IsNull( rc.subdirectory ) ) rc.subdirectory = Replace( ReReplace( Replace( rc.subdirectory, "*", "", "all" ), "(\.){2,}", "", "all" ), ":", "/", "all" );
		rc.currentdirectory = rc.webrootdirectory & rc.clientfilesdirectory & rc.subdirectory;
		if ( !variables.FileManagerService.isDirectory( rc.currentdirectory ) ) rc.message.error = "Sorry, the requested " & rc.subdirectory & " is not valid.";
	}

	void function configure( required struct rc )
	{	
		if( StructKeyExists( rc, "editorType" ) ) session.editorType = rc.editorType;
		if( StructKeyExists( rc, "EDITOR_RESOURCE_TYPE" ) ) session.EDITOR_RESOURCE_TYPE = rc.EDITOR_RESOURCE_TYPE;
		if( StructKeyExists( rc, "CKEditor" ) ) session.CKEditor = rc.CKEditor;
		if( StructKeyExists( rc, "CKEditorFuncNum" ) ) session.CKEditorFuncNum = rc.CKEditorFuncNum;
		if( StructKeyExists( rc, "langCode" ) ) session.langCode = rc.langCode;
		variables.fw.redirect( "filemanager" );
	}

	void function createdirectory( required struct rc )
	{
		param name="rc.newdirectory" default="";
		var newdirectory = ReReplaceNoCase( Trim( rc.newdirectory ), "[^a-z0-9_\-\.]", "", "all" );
		var result = variables.FileManagerService.createDirectory( rc.currentdirectory & "/" & newdirectory );
		rc.messages = result.messages;
		if( result.theobject.mkdirs() && StructKeyExists( result.messages, "success" ) ) variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory & "/" & newdirectory )#", preserve="messages" );
		else variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory )#", preserve="messages" );
	} 

	void function default( required struct rc )
	{
		rc.listing = variables.FileManagerService.getDirectoryList( rc.currentdirectory );
	}

	void function delete( required struct rc )
	{
		param name="rc.delete" default="";
		var result = variables.FileManagerService.deleteFile( rc.currentdirectory  & "/" & rc.delete );
		rc.messages = result.messages;
		variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory )#", preserve="messages" );
	}

	void function upload( required struct rc )
	{
		param name="rc.file" default="";
		var result = variables.FileManagerService.uploadFile( "file", rc.currentdirectory, application.config.filemanagersettings.allowedextensions );
		rc.messages = result.messages;
		variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory )#", preserve="messages" );
	}
	
	/*
	 * Private methods
	 */
	
	private string function urlSafePath( required string path )
	{
		var result = Replace( arguments.path, "/", ":", "all" );
		if ( !Len( Trim( result ) ) ) result = "*";
		return result;
	}
		
}