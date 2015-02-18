component {

	this.applicationroot = ReReplace(getDirectoryFromPath(getCurrentTemplatePath()), "_tests.$", "", "all");
	this.name = ReReplace(this.applicationroot & "_tests", "[\W]", "", "all");
	this.sessionmanagement = TRUE;

	this.mappings["/framework"] = this.applicationroot & "framework/";
	this.mappings["/model"] = this.applicationroot & "model/";
	this.mappings["/tests"] = this.applicationroot & "_tests/";

}
