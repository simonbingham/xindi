component{

	this.applicationroot = ReReplace(getDirectoryFromPath(getCurrentTemplatePath()), "_tests.$", "", "all");
	this.name = ReReplace("[^W]", this.applicationroot & "_tests", "", "all");
	this.sessionmanagement = true;
	// prevent bots creating lots of sessions
	if (structKeyExists(cookie, "CFTOKEN")) this.sessiontimeout = createTimeSpan(0, 0, 5, 0);
	else this.sessiontimeout = createTimeSpan(0, 0, 0, 1);
	this.mappings["/framework"] = this.applicationroot & "framework/";
	this.mappings["/model"] = this.applicationroot & "model/";
	this.mappings["/ValidateThis"] = this.applicationroot & "framework/ValidateThis/";
	this.datasource = "xindi_testsuite";
	this.ormenabled = true;
	this.ormsettings = {
		flushatrequestend = false
		, automanagesession = false
		, cfclocation = this.mappings["/model"]
		, eventhandling = true
		, eventhandler = "model.aop.GlobalEventHandler"
		, dbcreate = "update"
	};

}
