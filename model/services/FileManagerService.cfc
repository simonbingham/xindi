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

component accessors="true"
{

	/*
	 * Public methods
	 */
	 	
	struct function createDirectory( required string directory )
	{
		var result = {};
		if( Len( Trim( arguments.directory ) ) ) 
		{
			result.theobject = CreateObject( "java", "java.io.File" ).init( JavaCast( "string", arguments.directory ) );
			result.messages.success = "The directory &quot;" & arguments.directory & "&quot; has been created.";
		}
		else
		{
			result.messages.error = "The directory &quot;" & newdirectorypath & "&quot; could not be created.";
		}
		return result;
	}
	
	struct function deleteFile( required string file )
	{
		result = {};
		if( isFile( arguments.file ) )
		{
			getFile( arguments.file ).delete();
			result.messages.success = "The file &quot;" & arguments.file & "&quot; has been deleted.";
		}
		else
		{
			result.messages.error = "The file &quot;" & arguments.file & "&quot; could not be deleted.";
		} 
		return result;
	}	
	
	query function getDirectoryList( required string directory, required string allowedextensions )
	{
		var listing = DirectoryList( arguments.directory, false, "query", "*." & Replace( arguments.allowedextensions, ",", "|*.", "all" ) );
		var queryobject = new query();
		queryobject.setDBType( "query" );
		queryobject.setAttributes( sourceQuery=listing );
		queryobject.setSQL( "select * from sourceQuery where name not like '.%' order by type" );
		return queryobject.execute().getResult();
	}	
	
	boolean function isDirectory( required string directory )
	{
		return getFile( arguments.directory ).isDirectory();
	}
	
	struct function uploadFile( required string file, required string destination, required string allowedextensions )
	{
		var result = {};
		try
		{
			result = FileUpload( arguments.destination, arguments.file, "", "MakeUnique" );
			result.messages.success = "The file &quot;" & result.serverfile & "&quot; has been uploaded.";
			if( !ListFindNoCase( arguments.allowedextensions, result.serverfileext ) ) deleteFile( result.serverdirectory & "/" & result.serverfile );
		}
		catch( any e )
		{ 
			result.messages.error = "Sorry, you are not permitted to upload this type of file.";
		}
		return result;
	}
	
	/*
	 * Private methods
	 */	

	private function getFile( required string file )
	{
		return CreateObject( "java", "java.io.File" ).init( JavaCast( "String", arguments.file ) );
	}	
	
	private boolean function isFile( required string file )
	{
		return getFile( arguments.file ).isFile();
	}
	
}