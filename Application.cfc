/*
	Xindi (http://simonbingham.github.com/xindi/) - Version 2012.5.3.13
	
	Copyright (c) 2012, Simon Bingham (http://www.simonbingham.me.uk/)
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

component extends="frameworks.org.corfield.framework"
{
	
	/**
	* application settings
	*/
	this.development = ListFind( "localhost,127.0.0.1,127.0.0.1:8888", CGI.SERVER_NAME );
	this.applicationroot = getDirectoryFromPath( getCurrentTemplatePath() );
	this.sessionmanagement = true;
	this.mappings[ "/model" ] = this.applicationroot & "model/";
	this.mappings[ "/ValidateThis" ] = this.applicationroot & "frameworks/ValidateThis/";
	this.datasource = ListLast( this.applicationroot, "\/" );
	this.ormenabled = true;
	this.ormsettings = {
		flushatrequestend = false
		, automanagesession = false
		, cfclocation = this.mappings[ "/model" ]
		, eventhandling = true
		, eventhandler = "model.aop.GlobalEventHandler"		
	};
	// create database and populate when the application starts in development environment
	// you might want to comment out this code after the initial install
	if( this.development && !isNull( url.rebuild ) )
	{
		this.ormsettings.dbcreate = "dropcreate";
		this.ormsettings.sqlscript = "_setup/setup.sql";
	}

	/**
	* FW/1 framework settings (https://github.com/seancorfield/fw1)
	*/
	variables.framework = {
		cacheFileExists = !this.development
		, defaultSubsystem = "public"
		, generateSES = true
		, maxNumContextsPreserved = 1
		, password = ""
		, reloadApplicationOnEveryRequest = this.development
		, usingSubsystems = true
		// , routes = [ { ""="", hint="" } ]
	};
	
	/**
     * called when application starts
	 */	
	void function setupApplication()
	{
		ORMReload();
		
		// setup bean factory
		var beanfactory = new frameworks.org.corfield.ioc( "/model" );
		setBeanFactory( beanfactory );
		var ValidateThisConfig = { definitionPath="/model/" };
		beanFactory.addBean( "Validator", new ValidateThis.ValidateThis( ValidateThisConfig ) );
		beanFactory.addBean( "MetaData", new model.beans.MetaData() );
		
		// define revision identifier
		application.revision = Hash( Now() );
		
		// get configuration
		application.config = getConfig();
	}
	
	/**
     * called when page request starts
	 */	
	void function setupRequest()
	{
		// define base url
		if ( CGI.HTTPS eq "on" ) rc.basehref = "https://";
		else rc.basehref = "http://";
		rc.basehref &= CGI.HTTP_HOST & variables.framework.base;
	  	
	  	// define default meta data
		rc.MetaData = getBeanFactory().getBean( "MetaData" );
		
		// store revision identifier in request context
		rc.revision = application.revision;
		
		// call admin on every request (used for security)
		controller( "admin:main.default" );		 
	}
	
	/**
     * called when view rendering begins
	 */		
	void function setupView()
	{
		rc.navigation = getBeanFactory().getBean( "ContentService" ).getPages();
	}	
	
	/**
     * called if view is missing
	 */	
	any function onMissingView( required rc )
	{
		rc.Page = getBeanFactory().getBean( "ContentService" ).getPageBySlug( ListLast( CGI.PATH_INFO, "/" ) );
		if ( rc.Page.isPersisted() )
		{
			rc.MetaData.setMetaTitle( rc.Page.getMetaTitle() ); 
			rc.MetaData.setMetaDescription( rc.Page.getMetaDescription() );
			rc.MetaData.setMetaKeywords( rc.Page.getMetaKeywords() );			
			return view( "public:main/default" );
		}
		else
		{
			var pagecontext = getPageContext().getResponse();
			pagecontext.getResponse().setStatus( 404 );
			return view( "public:main/notfound" );
		}
	}
	
	/**
     * configuration
	 */		
	private struct function getConfig()
	{
		var config = {
			enquirysettings = {
				subject = "Enquiry"
				, emailto = ""
			}
			, filemanagersettings = {
				allowedextensions = "txt,gif,jpg,png,wav,mpeg3,pdf,zip"
			}
			, newssettings = {
				enabled = true
				, rsstitle = ""
				, rssdescription = ""
			}
			, errorsettings = { 
				enabled=true
				, to=""
				, from=""
				, subject="Error Notification (#ListLast( this.applicationroot, '\/' )#)" 
			}
			, pagesettings = { 
				enableadddelete=true 
			}
			, securitysettings = {
				whitelist = "^admin:security,^public:"
			}
			, caching = {
				timespan = CreateTimeSpan( 0, 0, 5, 0 )
			}
		};
		if( this.development ) config.caching.timespan = CreateTimeSpan( 0, 0, 0, 0 );
		return config;
	}	

}