component accessors = true extends = "abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "FileManagerService" setter = true getter = false;
	property name = "config" setter = true getter = false;

	// ------------------------ CONSTANTS ------------------------ //

	variables.CLIENT_FILES_DIRECTORY = "_clientfiles";
	variables.IMAGE_QUALITY = 0.8;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function before(required struct rc) {
		rc.webrootDirectory = GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH);
		rc.subDirectory = !IsNull(rc.subDirectory) ? Replace(ReReplace(Replace(rc.subDirectory, "*", "", "all"), "(\.) {2,}", "", "all"), ":", "/", "all") : "";
		rc.currentDirectory = rc.webrootDirectory & variables.CLIENT_FILES_DIRECTORY & rc.subDirectory;
		rc.clientFilesDirectory = variables.CLIENT_FILES_DIRECTORY;
		if (!variables.FileManagerService.isDirectory(directory = rc.currentDirectory)) {
			rc.message.error = "Sorry, the requested " & rc.subDirectory & " is not valid.";
		}
	}

	void function configure(required struct rc) {
		if (StructKeyExists(rc, "editorType")) {
			session.editorType = rc.editorType;
		}
		if (StructKeyExists(rc, "EDITOR_RESOURCE_TYPE")) {
			session.EDITOR_RESOURCE_TYPE = rc.EDITOR_RESOURCE_TYPE;
		}
		if (StructKeyExists(rc, "CKEditor")) {
			session.CKEditor = rc.CKEditor;
		}
		if (StructKeyExists(rc, "CKEditorFuncNum")) {
			session.CKEditorFuncNum = rc.CKEditorFuncNum;
		}
		if (StructKeyExists(rc, "langCode")) {
			session.langCode = rc.langCode;
		}
		variables.fw.redirect("filemanager");
	}

	void function createDirectory(required struct rc) {
		param name = "rc.newDirectory" default = "";
		local.newDirectory = ReReplaceNoCase(Trim(rc.newDirectory), "[^a-z0-9_\-\.]", "", "all");
		rc.result = variables.FileManagerService.createDirectory(currentDirectory = rc.currentDirectory, newDirectory = local.newDirectory);
		if (structkeyexists(rc.result, "theObject") && rc.result.theObject.mkdirs() && rc.result.getIsSuccess()) {
			variables.fw.redirect(action = "filemanager.default", querystring = "subdirectory=#urlSafePath(rc.subDirectory & '/' & local.newDirectory)#", preserve = "result");
		} else {
			variables.fw.redirect(action = "filemanager.default", querystring = "subdirectory=#urlSafePath(rc.subDirectory)#", preserve = "result");
		}
	}

	void function crop(required struct rc) {
		if (IsNull(rc.image)) {
			variables.fw.redirect("filemanager.default");
		} else {
			local.imagePath = rc.currentDirectory & "/" & rc.image;
			if (FileExists(local.imagePath) && IsImageFile(local.imagePath)) {
				local.ImageObject = ImageRead(local.imagePath);
				rc.ImageInfo = ImageInfo(local.ImageObject);
			} else {
				variables.fw.redirect("filemanager.default");
			}
		}
	}

	void function default(required struct rc) {
		rc.listing = variables.FileManagerService.getDirectoryList(directory = rc.currentDirectory, allowedExtensions = variables.config.filemanager.allowedExtensions);
	}

	void function delete(required struct rc) {
		param name = "rc.delete" default = "";
		rc.result = variables.FileManagerService.deleteFile(file = rc.currentDirectory & "/" & rc.delete);
		variables.fw.redirect(action = "filemanager.default", querystring = "subDirectory=#urlSafePath(rc.subDirectory)#", preserve = "result");
	}

	void function doCrop(required struct rc) {
		local.imageObject = ImageRead(rc.currentDirectory & "/" & rc.image);
		local.imageInfo = ImageInfo(local.imageObject);
		local.cropWidth = Val(rc.x2) - Val(rc.x1);
		local.cropHeight = Val(rc.y2) - Val(rc.y1);
		local.dimensions = rc.width & "x" & rc.height;
		if (local.cropWidth > 0 && local.cropHeight > 0) {
			local.dimensions = local.cropWidth & "x" & local.cropHeight;
		}
		local.newFileName = ReReplaceNoCase(rc.image, "\.(.)*$", "") & "_" & local.dimensions & "." & ListLast(rc.image, ".");
		local.isModified = false;
		ImageSetAntialiasing(local.imageObject, "on");
		if (local.imageInfo.width > rc.width || local.imageInfo.height > rc.height) {
			ImageResize(local.imageObject, rc.width, rc.height);
			local.isModified = true;
		}
		if (local.cropWidth > 0 && local.cropHeight > 0) {
			ImageCrop(local.imageObject, Val(rc.x1), Val(rc.y1), local.cropWidth, local.cropHeight);
			local.isModified = true;
		}
		if (local.isModified) {
			ImageWrite(local.imageObject, rc.currentDirectory & "/" & local.newFileName, variables.IMAGE_QUALITY);
			rc.messages = ["The image has been edited and saved as '#local.newFileName#'"];
			variables.fw.redirect("filemanager.default?subdirectory=#urlSafePath(rc.subdirectory)#", "messages");
		} else {
			variables.fw.redirect("filemanager.default?subdirectory=#urlSafePath(rc.subdirectory)#");
		}
	}

	void function upload(required struct rc) {
		param name = "rc.file" default = "";
		rc.result = variables.FileManagerService.uploadFile(file = "file", destination = rc.currentDirectory, allowedExtensions = variables.config.fileManager.allowedExtensions);
		variables.fw.redirect(action = "filemanager.default", querystring = "subdirectory=#urlSafePath(rc.subDirectory)#", preserve = "result");
	}

	// ------------------------ PRIVATE METHODS ------------------------ //

	private string function urlSafePath(required string path) {
		local.result = Replace(arguments.path, "/", ":", "all");
		if (!Len(Trim(local.result))) {
			local.result = "*";
		}
		return local.result;
	}

}
