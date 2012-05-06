component 
{
	this.applicationroot = ReReplace( getDirectoryFromPath( getCurrentTemplatePath() ), "tests.$", "", "all" );
	
	this.name = ReReplace( "[^W]", this.applicationroot & "tests", "", "all" );
	this.sessionmanagement = true;
	this.mappings[ "/model" ] = this.applicationroot & "model/";
	this.datasource = "xindi_testsuite";
	this.ormenabled = true;
	this.ormsettings = {
		flushatrequestend = false
		, automanagesession = false
		, cfclocation = this.mappings[ "/model" ]
		, eventhandling = true
		, eventhandler = "model.aop.GlobalEventHandler"
		, dbcreate = "update"		
	};
}