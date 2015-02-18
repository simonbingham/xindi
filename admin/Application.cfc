component {

	// ------------------------ APPLICATION SETTINGS ------------------------ //

	this.applicationroot = getDirectoryFromPath(getCurrentTemplatePath());
	this.name = ListLast(this.applicationroot, "\/") & "_" & Hash(this.applicationroot);

	// ------------------------ CALLED WHEN PAGE REQUEST STARTS ------------------------ //

	function onRequestStart(){
		location(url="../index.cfm/admin:main", addtoken="false");
	}
}
