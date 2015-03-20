component {

	// ------------------------ APPLICATION SETTINGS ------------------------ //

	this.applicationRoot = ReReplace(getDirectoryFromPath(getCurrentTemplatePath()), "admin.$", "", "all");
	this.name = ReReplace(this.applicationRoot & "_admin", "[\W]", "", "all");

	// ------------------------ CALLED WHEN PAGE REQUEST STARTS ------------------------ //

	function onRequestStart() {
		location(url = "../index.cfm/admin:main", addToken = "false");
	}
}
