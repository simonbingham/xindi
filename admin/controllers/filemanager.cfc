/*
	Copyright (c) 2012, Simon Bingham (http://www.simonbingham.me.uk/)
	
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
	 * Public methods
	 */	

	void function before( required rc )
	{
		rc.webrootdirectory = GetDirectoryFromPath( CGI.CF_TEMPLATE_PATH );
		rc.clientfilesdirectory = "_clientfiles/";
		if ( !IsNull( rc.subdirectory ) )
		{
			rc.subdirectory = Replace( rc.subdirectory, "*", "", "all" );
			rc.subdirectory = Replace( ReReplace( rc.subdirectory, "(\.){2,}", "", "all" ), ":", "/", "all" );
		}
		else
		{
			rc.subdirectory = "";
		}
		rc.currentdirectory = rc.webrootdirectory & rc.clientfilesdirectory & rc.subdirectory;
		var FileObj = CreateObject( "java", "java.io.File" ).init( JavaCast( "String", rc.currentdirectory ) );
		if ( !FileObj.isDirectory() ) rc.message.error = "Sorry, the requested " & rc.subdirectory & " is not valid.";
	}

	void function configure( required rc )
	{	
		if( StructKeyExists( rc, "editorType" ) ) session.editorType = rc.editorType;
		if( StructKeyExists( rc, "EDITOR_RESOURCE_TYPE" ) ) session.EDITOR_RESOURCE_TYPE = rc.EDITOR_RESOURCE_TYPE;
		if( StructKeyExists( rc, "CKEditor" ) ) session.CKEditor = rc.CKEditor;
		if( StructKeyExists( rc, "CKEditorFuncNum" ) ) session.CKEditorFuncNum = rc.CKEditorFuncNum;
		if( StructKeyExists( rc, "langCode" ) ) session.langCode = rc.langCode;
		variables.fw.redirect( "filemanager" );
	}

	void function createdirectory( required rc )
	{
		var newdirectorypath = ReReplaceNoCase( Trim( rc.newdirectory ), "[^a-z0-9_\-\.]", "", "all" );
		if ( newdirectorypath != "" ) 
		{
			var fileObj = createObject( "java", "java.io.File" ).init( JavaCast( "string", rc.currentdirectory & "/" & newdirectorypath ) );
			if ( fileObj.mkdirs() ) 
			{
				rc.message.success = "The directory " & newdirectorypath & " has been created.";
				variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory & "/" & newdirectorypath )#", preserve="message" );
			}
			else
			{
				rc.message.error = newdirectorypath & " is not a valid name.";
				variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory )#", preserve="message" );
			}
		}
	} 

	void function default( required rc )
	{
		var qListing = DirectoryList( rc.currentdirectory, false, "query" );
		var queryobject = new query();
		queryobject.setDBType( "query" );
		queryobject.setAttributes( sourceQuery=qListing );
		queryobject.setSQL( "select * from sourceQuery where name not like '.%' order by type" );
		rc.listing = queryobject.execute().getResult();
	}

	void function delete( required rc )
	{
		var FileObj = CreateObject( "java", "java.io.File" ).init( JavaCast( "String", rc.currentdirectory  & "/" & rc.delete ) );
		if ( FileObj.isFile() ) FileObj.delete();
		rc.message.success = "The file " & rc.delete & " has been deleted.";
		variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory )#", preserve="message" );
	}

	void function upload( required rc )
	{
		if ( !Len( Trim( rc.file ) ) ) variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory )#", preserve="message" );
		var result = FileUpload( rc.currentdirectory, "file", "", "MakeUnique" );
		if ( !ListFindNoCase( application.config.filemanagersettings.allowedextensions, result.serverfileext ) )
		{
			var FileObj = CreateObject( "java", "java.io.File" ).init( JavaCast( "String", result.serverdirectory & "/" & result.serverfile ) );
			if ( FileObj.isFile() ) FileObj.delete();
			rc.message.error = "Sorry, files ending in " & result.serverfileext & " are not allowed.";
		}
		else
		{
			rc.message.success = "The file " & result.serverfile & " has been uploaded.";
		}
		variables.fw.redirect( action="filemanager.default", querystring="subdirectory=#urlSafePath( rc.subdirectory )#", preserve="message" );
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