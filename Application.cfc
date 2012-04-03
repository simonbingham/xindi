component extends="frameworks.org.corfield.framework"
{
	
	/*
	* application settings
	*/
	this.development = CGI.SERVER_NAME == "localhost";
	this.applicationroot = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/model" ] = this.applicationroot & "model/";
	this.datasource = ListLast( this.applicationroot, "\/" );
	this.ormenabled = true;
	this.ormsettings = {
		flushatrequestend = false,
		automanagesession = false,
		cfclocation = this.mappings[ "/model" ],
		dbcreate = "update",
		sqlscript = this.applicationroot & "_setup/setup.sql"
	};

	/*
	* FW/1 framework settings (FW/1)
	* https://github.com/seancorfield/fw1/wiki/Using-Subsystems
	*/
	variables.framework = {
		usingSubsystems = true,
		defaultSubsystem = "public",
		generateSES = true,
		reloadApplicationOnEveryRequest = this.development,
		cacheFileExists = !this.development
	};
	
	void function setupApplication()
	{
		ORMReload();
		var bf = new frameworks.org.corfield.ioc( "/model" );
		setBeanFactory( bf );
	}
	
	void function setupRequest()
	{
	  	rc.basehref = "//" & CGI.SERVER_NAME & variables.framework.base;
	}
	
	// executes when a view is not found
	any function onMissingView( required rc )
	{}
	
}