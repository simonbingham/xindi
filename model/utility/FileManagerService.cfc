component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I create a directory
	 */
	struct function createDirectory(required string directory)
	{
		var result = variables.Validator.newResult();
		if(Len(Trim(arguments.directory))) {
			result.theobject = CreateObject("java", "java.io.File").init(JavaCast("string", arguments.directory));
			result.setSuccessMessage("The directory &quot;" & arguments.directory & "&quot; has been created.");
		}else{
			result.setErrorMessage("The directory &quot;" & newdirectorypath & "&quot; could not be created.");
		}
		return result;
	}

	/**
	 * I delete a file
	 */
	struct function deleteFile(required string file) {
		var result = variables.Validator.newResult();
		if(isFile(arguments.file)) {
			getFile(arguments.file).delete();
			result.setSuccessMessage("The file &quot;" & arguments.file & "&quot; has been deleted.");
		}else{
			result.setErrorMessage("The file &quot;" & arguments.file & "&quot; could not be deleted.");
		}
		return result;
	}

	/**
	 * I return a list of directories
	 */
	query function getDirectoryList(required string directory, required string allowedextensions) {
		var fileListing = DirectoryList(arguments.directory, false, "query", "*." & Replace(arguments.allowedextensions, ",", "|*.", "all"));
		var fullListing = DirectoryList(arguments.directory, false, "query");
		var queryobject = new query();
		queryobject.setDBType("query");
		queryobject.setAttributes(fileListing=fileListing);
		queryobject.setAttributes(fullListing=fullListing);
		queryobject.setSQL("
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
	boolean function isDirectory(required string directory) {
		return getFile(arguments.directory).isDirectory();
	}

	/**
	 * I upload a file
	 */
	struct function uploadFile(required string file, required string destination, required string allowedextensions) {
		var result = variables.Validator.newResult();
		try{
			var fileuploadresult = FileUpload(arguments.destination, arguments.file, "", "MakeUnique");
			if(!ListFindNoCase(arguments.allowedextensions, fileuploadresult.serverfileext)) {
				deleteFile(fileuploadresult.serverdirectory & "/" & fileuploadresult.serverfile);
				result.setErrorMessage("Sorry, you are not permitted to upload this type of file.");
			}else{
				result.setSuccessMessage("The file &quot;" & fileuploadresult.serverfile & "&quot; has been uploaded.");
			}
		}
		catch(any e) {
			result.setErrorMessage("Sorry, the file could not be uploaded.");
		}
		return result;
	}

	// ------------------------ PRIVATE METHODS ------------------------ //

	/**
	 * I return a file
	 */
	private function getFile(required string file) {
		return CreateObject("java", "java.io.File").init(JavaCast("String", arguments.file));
	}

	/**
	 * I return true if a file exists
	 */
	private boolean function isFile(required string file) {
		return getFile(arguments.file).isFile();
	}

}
