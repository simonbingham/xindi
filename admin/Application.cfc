component {

	// ------------------------ APPLICATION SETTINGS ------------------------ //

	this.applicationroot = ReReplace(getDirectoryFromPath(getCurrentTemplatePath()), "admin.$", "", "all");
	this.name = ReReplace(this.applicationroot & "_admin", "[\W]", "", "all");

	// ------------------------ CALLED WHEN PAGE REQUEST STARTS ------------------------ //

	function onRequestStart() {
		location(url="../index.cfm/admin:main", addtoken="false");
	}
}
