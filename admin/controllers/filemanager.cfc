component accessors="true" extends="abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="FileManagerService" setter="true" getter="false";
	property name="config" setter="true" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function before(required struct rc) {
		rc.webrootdirectory = GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH);
		rc.clientfilesdirectory = "_clientfiles";
		if(!IsNull(rc.subdirectory)) rc.subdirectory = Replace(ReReplace(Replace(rc.subdirectory, "*", "", "all"), "(\.) {2,}", "", "all"), ":", "/", "all");
		else rc.subdirectory = "";
		rc.currentdirectory = rc.webrootdirectory & rc.clientfilesdirectory & rc.subdirectory;
		if(!variables.FileManagerService.isDirectory(rc.currentdirectory)) rc.message.error = "Sorry, the requested " & rc.subdirectory & " is not valid.";
	}

	void function configure(required struct rc) {
		if(StructKeyExists(rc, "editorType")) session.editorType = rc.editorType;
		if(StructKeyExists(rc, "EDITOR_RESOURCE_TYPE")) session.EDITOR_RESOURCE_TYPE = rc.EDITOR_RESOURCE_TYPE;
		if(StructKeyExists(rc, "CKEditor")) session.CKEditor = rc.CKEditor;
		if(StructKeyExists(rc, "CKEditorFuncNum")) session.CKEditorFuncNum = rc.CKEditorFuncNum;
		if(StructKeyExists(rc, "langCode")) session.langCode = rc.langCode;
		variables.fw.redirect("filemanager");
	}

	void function createdirectory(required struct rc) {
		param name="rc.newdirectory" default="";
		var newdirectory = ReReplaceNoCase(Trim(rc.newdirectory), "[^a-z0-9_\-\.]", "", "all");
		rc.result = variables.FileManagerService.createDirectory(rc.currentdirectory & "/" & newdirectory);
		if(rc.result.theobject.mkdirs() && rc.result.getIsSuccess()) variables.fw.redirect(action="filemanager.default", querystring="subdirectory=#urlSafePath(rc.subdirectory & "/" & newdirectory)#", preserve="result");
		else variables.fw.redirect(action="filemanager.default", querystring="subdirectory=#urlSafePath(rc.subdirectory)#", preserve="result");
	}

	void function crop(required struct rc) {
		if(IsNull(rc.image)) {
			variables.fw.redirect("filemanager.default");
		}else{
			var uncImagePath = rc.currentdirectory & "/" & rc.image;
			if(FileExists(uncImagePath) && IsImageFile(uncImagePath)) {
				var ImageObject = ImageRead(uncImagePath);
				rc.ImageInfo = ImageInfo(ImageObject);
			}else{
				variables.fw.redirect("filemanager.default");
			}
		}
	}

	void function default(required struct rc) {
		rc.listing = variables.FileManagerService.getDirectoryList(rc.currentdirectory, variables.config.filemanager.allowedextensions);
	}

	void function delete(required struct rc) {
		param name="rc.delete" default="";
		rc.result = variables.FileManagerService.deleteFile(file=rc.currentdirectory & "/" & rc.delete);
		variables.fw.redirect(action="filemanager.default", querystring="subdirectory=#urlSafePath(rc.subdirectory)#", preserve="result");
	}

	void function docrop(required struct rc) {
		var ImageObject = ImageRead(rc.currentdirectory & "/" & rc.image);
		var ImageInfo = ImageInfo(ImageObject);
		var cropWidth = Val(rc.x2) - Val(rc.x1);
		var cropHeight = Val(rc.y2) - Val(rc.y1);
		var dimensions = rc.width & "x" & rc.height;
		if(cropWidth > 0 && cropHeight > 0) dimensions = cropWidth & "x" & cropHeight;
		var newFileName = ReReplaceNoCase(rc.image, "\.(.)*$", "") & "_" & dimensions & "." & ListLast(rc.image, ".");
		var ismodified = false;
		ImageSetAntialiasing(ImageObject, "on");
		if(ImageInfo.width > rc.width || ImageInfo.height > rc.height) {
			ImageResize(ImageObject, rc.width, rc.height);
			ismodified = true;
		}
		if(cropWidth > 0 && cropHeight > 0) {
			ImageCrop(ImageObject, Val(rc.x1), Val(rc.y1), cropWidth, cropHeight);
			ismodified = true;
		}
		if(ismodified) {
			ImageWrite(ImageObject, rc.currentdirectory & "/" & newFileName, 0.8);
			rc.messages = ["The image has been edited and saved as '#newFileName#'"];
			variables.fw.redirect("filemanager.default?subdirectory=#urlSafePath(rc.subdirectory)#", "messages");
		}else{
			variables.fw.redirect("filemanager.default?subdirectory=#urlSafePath(rc.subdirectory)#");
		}
	}

	void function upload(required struct rc) {
		param name="rc.file" default="";
		rc.result = variables.FileManagerService.uploadFile("file", rc.currentdirectory, variables.config.filemanager.allowedextensions);
		variables.fw.redirect(action="filemanager.default", querystring="subdirectory=#urlSafePath(rc.subdirectory)#", preserve="result");
	}

	// ------------------------ PRIVATE METHODS ------------------------ //

	private string function urlSafePath(required string path) {
		var result = Replace(arguments.path, "/", ":", "all");
		if(!Len(Trim(result))) result = "*";
		return result;
	}

}
