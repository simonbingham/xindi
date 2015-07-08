component {

	this.applicationroot = ReReplace(getDirectoryFromPath(getCurrentTemplatePath()), "_tests.$", "", "all");
	this.name = ReReplace(this.applicationroot & "_tests", "[\W]", "", "all");
	this.sessionmanagement = TRUE;

	this.mappings["/CFSelenium"] = this.applicationroot & "framework/CFSelenium/";
	this.mappings["/framework"] = this.applicationroot & "framework/";
	this.mappings["/model"] = this.applicationroot & "model/";
	this.mappings["/testbox"] = this.applicationroot & "framework/testbox/";
	this.mappings["/tests"] = this.applicationroot & "_tests/";
	this.mappings["/ValidateThis"] = this.applicationroot & "framework/ValidateThis/";

}
