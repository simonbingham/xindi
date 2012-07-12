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

component accessors="true"{

	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
     * I create a directory
	 */		 	
	struct function createDirectory( required string directory )
	{
		var result = variables.Validator.newResult();
		if( Len( Trim( arguments.directory ) ) ) {
			result.theobject = CreateObject( "java", "java.io.File" ).init( JavaCast( "string", arguments.directory ) );
			result.setSuccessMessage( "The directory &quot;" & arguments.directory & "&quot; has been created." );
		}else{
			result.setErrorMessage( "The directory &quot;" & newdirectorypath & "&quot; could not be created." );
		}
		return result;
	}
	
	/**
     * I delete a file
	 */		
	struct function deleteFile( required string file ){
		var result = variables.Validator.newResult();
		if( isFile( arguments.file ) ){
			getFile( arguments.file ).delete();
			result.setSuccessMessage( "The file &quot;" & arguments.file & "&quot; has been deleted." );
		}else{
			result.setErrorMessage( "The file &quot;" & arguments.file & "&quot; could not be deleted." );
		}
		return result;
	}	
	
	/**
     * I return a list of directories
	 */		
	query function getDirectoryList( required string directory, required string allowedextensions ){
		var fileListing = DirectoryList( arguments.directory, false, "query", "*." & Replace( arguments.allowedextensions, ",", "|*.", "all" ) );
		var fullListing = DirectoryList( arguments.directory, false, "query" );
		var queryobject = new query();
		queryobject.setDBType( "query" );
		queryobject.setAttributes( fileListing=fileListing );
		queryobject.setAttributes( fullListing=fullListing );
		queryobject.setSQL( "
			select * from fileListing where name not like '.%'
			union
			select * from fullListing where type = 'Dir' 
			order by type, name " 
		);
		return queryobject.execute().getResult();
	}	
	
	/**
     * I return true if a directory exists
	 */		
	boolean function isDirectory( required string directory ){
		return getFile( arguments.directory ).isDirectory();
	}
	
	/**
     * I upload a file
	 */		
	struct function uploadFile( required string file, required string destination, required string allowedextensions ){
		var result = variables.Validator.newResult();
		try{
			var fileuploadresult = FileUpload( arguments.destination, arguments.file, "", "MakeUnique" );
			result.setSuccessMessage( "The file &quot;" & fileuploadresult.serverfile & "&quot; has been uploaded." );
			if( !ListFindNoCase( arguments.allowedextensions, fileuploadresult.serverfileext ) ) deleteFile( fileuploadresult.serverdirectory & "/" & fileuploadresult.serverfile );
		}
		catch( any e ){ 
			result.setErrorMessage( "Sorry, you are not permitted to upload this type of file." );
		}
		return result;
	}
	
	// ------------------------ PRIVATE METHODS ------------------------ //

	/**
     * I return a file
	 */	
	private function getFile( required string file ){
		return CreateObject( "java", "java.io.File" ).init( JavaCast( "String", arguments.file ) );
	}	

	/**
     * I return true if a file exists
	 */		
	private boolean function isFile( required string file ){
		return getFile( arguments.file ).isFile();
	}
	
}