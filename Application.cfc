/* 
	Xindi - http://www.getxindi.com/ - Version TBC
	
	Copyright (c) 2012, Simon Bingham
	
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
	this.development = ListFind( "localhost,127.0.0.1,127.0.0.1:8888", CGI.SERVER_NAME ) != 0;
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
		this.ormsettings.sqlscript = "_install/setup.sql";
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
		//, routes = [ { ""="", hint="" } ]
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
		var ValidateThisConfig = { definitionPath="/model/", JSIncludes=false };
		beanFactory.addBean( "Validator", new ValidateThis.ValidateThis( ValidateThisConfig ) );
		beanFactory.addBean( "MetaData", new model.beans.MetaData() );
		beanFactory.addBean( "config", getConfig() );
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
		
		// store config in request context
		rc.config = getBeanFactory().getBean( "Config" );
		
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
     * called if view is missing - used for (almost) all Xindi page requests
	 */	
	any function onMissingView( required rc )
	{
		rc.Page = getBeanFactory().getBean( "ContentService" ).getPageBySlug( ListLast( CGI.PATH_INFO, "/" ) );
		if( !rc.Page.isPersisted() || ( rc.Page.hasChild() && !rc.Page.isRoot() and getConfig().pagesettings.suppressancestorpages ) )
		{
			var pagecontext = getPageContext().getResponse();
			pagecontext.getResponse().setStatus( 404 );
			return view( "public:main/notfound" );
		}
		else
		{
			rc.MetaData.setMetaTitle( rc.Page.getMetaTitle() ); 
			rc.MetaData.setMetaDescription( rc.Page.getMetaDescription() );
			rc.MetaData.setMetaKeywords( rc.Page.getMetaKeywords() );
			return view( "public:main/default" );
		}
	}
	
	/**
     * configuration
	 */		
	private struct function getConfig()
	{
		var config = {
			// enquiry form settings
			enquirysettings = {
				subject = "Enquiry"
				, emailto = ""
			}
			// error handler settings
			, errorsettings = { 
				enabled=true
				, to=""
				, from=""
				, subject="Error Notification (#ListLast( this.applicationroot, '\/' )#)" 
			}
			// file manager settings
			, filemanagersettings = {
				allowedextensions = "txt,gif,jpg,png,wav,mpeg3,pdf,zip"
			}
			// news feature settings
			, newssettings = {
				enabled = true
				, rsstitle = ""
				, rssdescription = ""
			}
			// page manager settings
			, pagesettings = { 
				enableadddelete = true
				, levellimit = 2 // number of page tiers that can be added - Bootstrap dropdown menu only supports 2
				, suppressancestorpages = true // set to true to use ancestor pages a navigation links to access child pages (ancestor pages will not have content)
			}
			// appended to regularly updated css and js urls to force reload
			, revision = Hash( Now() )
			// list of unsecure actions
			, securitysettings = {
				whitelist = "^admin:security,^public:"
			}
		};
		return config;
	}	

}