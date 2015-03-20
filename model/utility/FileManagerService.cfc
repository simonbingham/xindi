/**
 * I am the file manager service component.
 */
component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I create a directory
	 */
	struct function createDirectory(required string currentDirectory, required string newDirectory)
	{
		local.result = variables.Validator.newResult();
		if (Len(Trim(arguments.newDirectory))) {
			local.directory = arguments.currentDirectory & "/" & arguments.newDirectory;
			local.result.theObject = CreateObject("java", "java.io.File").init(JavaCast("string", local.directory));
			local.result.setSuccessMessage("The directory &quot;" & local.directory & "&quot; has been created.");
		} else {
			local.result.setErrorMessage("The directory &quot;" & arguments.newDirectory & "&quot; could not be created.");
		}
		return local.result;
	}

	/**
	 * I delete a file
	 */
	struct function deleteFile(required string file) {
		local.result = variables.Validator.newResult();
		if (isFile(file = arguments.file)) {
			getFile(arguments.file).delete();
			local.result.setSuccessMessage("The file &quot;" & arguments.file & "&quot; has been deleted.");
		} else {
			local.result.setErrorMessage("The file &quot;" & arguments.file & "&quot; could not be deleted.");
		}
		return local.result;
	}

	/**
	 * I return a list of directories
	 */
	query function getDirectoryList(required string directory, required string allowedExtensions) {
		local.fileListing = DirectoryList(arguments.directory, false, "query", "*." & Replace(arguments.allowedExtensions, ",", "|*.", "all"));
		local.fullListing = DirectoryList(arguments.directory, false, "query");
		local.queryService = new query();
		local.queryService.setDBType("query");
		local.queryService.setAttributes(fileListing = local.fileListing);
		local.queryService.setAttributes(fullListing = local.fullListing);
		local.queryService.setSQL("
			SELECT * FROM fileListing WHERE name NOT LIKE '.%'
			UNION
			SELECT * FROM fullListing WHERE type = 'Dir'
			ORDER BY type, name");
		return local.queryService.execute().getResult();
	}

	/**
	 * I return true if a directory exists
	 */
	boolean function isDirectory(required string directory) {
		return getFile(file = arguments.directory).isDirectory();
	}

	/**
	 * I upload a file
	 */
	struct function uploadFile(required string file, required string destination, required string allowedExtensions) {
		local.result = variables.Validator.newResult();
		try {
			local.fileUploadResult = FileUpload(arguments.destination, arguments.file, "", "MakeUnique");
			if (!ListFindNoCase(arguments.allowedExtensions, local.fileUploadResult.serverFileExt)) {
				deleteFile(file = local.fileUploadResult.serverDirectory & "/" & local.fileuploadresult.serverFile);
				local.result.setErrorMessage("Sorry, you are not permitted to upload this type of file.");
			} else {
				local.result.setSuccessMessage("The file &quot;" & local.fileUploadResult.serverFile & "&quot; has been uploaded.");
			}
		}
		catch(any e) {
			local.result.setErrorMessage("Sorry, the file could not be uploaded.");
		}
		return local.result;
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
		return getFile(file = arguments.file).isFile();
	}

}
