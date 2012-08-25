/*
	Xindi - http://www.getxindi.com/ - Version 2012.08.24
	
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

component extends="frameworks.org.corfield.framework"{
			
	// ------------------------ APPLICATION SETTINGS ------------------------ //
	
	this.applicationroot = getDirectoryFromPath( getCurrentTemplatePath() );
	this.name = ListLast( this.applicationroot, "\/" );
	this.sessionmanagement = true;
	// prevent bots creating lots of sessions
	if ( structKeyExists( cookie, "CFTOKEN" ) ) this.sessiontimeout = createTimeSpan( 0, 0, 20, 0 );
	else this.sessiontimeout = createTimeSpan( 0, 0, 0, 1 );
	this.mappings[ "/hoth" ] = this.applicationroot & "frameworks/hoth/";
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
		, secondarycacheenabled = true 		
	};
	this.development = IsLocalHost( CGI.REMOTE_ADDR );
	// create database and populate when the application starts in development environment
	// you might want to comment out this code after the initial install
	if( this.development && !isNull( url.rebuild ) ){
		this.ormsettings.dbcreate = "dropcreate";
		this.ormsettings.sqlscript = "_install/setup.sql";
	}

	// ------------------------ FW/1 SETTINGS ------------------------ //
	
	variables.framework = {
		cacheFileExists = !this.development
		, defaultSubsystem = "public"
		, generateSES = true
		, maxNumContextsPreserved = 1
		, password = ""
		, reloadApplicationOnEveryRequest = this.development
		, usingSubsystems = true
		, routes = [
			{ "news"="news", hint="Redirect to news feature" }
			, { "enquiry"="enquiry", hint="Redirect to enquiry feature" }
		]
	};
	
	// ------------------------ CALLED WHEN APPLICATION STARTS ------------------------ //	
	
	void function setupApplication(){
		// add exception tracker to application scope
		var HothConfig = new hoth.config.HothConfig();
		HothConfig.setApplicationName( getConfig().name );
		HothConfig.setLogPath( this.applicationroot & "logs/hoth" );
		HothConfig.setLogPathIsRelative( false );
		HothConfig.setEmailNewExceptions( getConfig().exceptiontracker.emailnewexceptions );
		HothConfig.setEmailNewExceptionsTo( getConfig().exceptiontracker.emailnewexceptionsto );
		HothConfig.setEmailNewExceptionsFrom( getConfig().exceptiontracker.emailnewexceptionsfrom );
		HothConfig.setEmailExceptionsAsHTML( getConfig().exceptiontracker.emailexceptionsashtml );
		application.exceptiontracker = new Hoth.HothTracker( HothConfig );
	
		// setup bean factory
		var beanfactory = new frameworks.org.corfield.ioc( "/model", { singletonPattern = "(Service|Gateway)$" } );
		setBeanFactory( beanfactory );

		// add validator bean to factory
		var validatorconfig = { definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult" };
		beanFactory.addBean( "Validator", new ValidateThis.ValidateThis( validatorconfig ) );

		// add meta data bean to factory
		beanFactory.addBean( "MetaData", new model.content.MetaData() );

		// add config bean to factory
		beanFactory.addBean( "config", getConfig() );
	}
	
	// ------------------------ CALLED WHEN PAGE REQUEST STARTS ------------------------ //	

	void function setupRequest(){
		if( this.development && !isNull( url.rebuild ) ) ORMReload();

		// define base url
		if( CGI.HTTPS eq "on" ) rc.basehref = "https://";
		else rc.basehref = "http://";
		rc.basehref &= CGI.HTTP_HOST & variables.framework.base;
	  	
	  	// define default meta data
		rc.MetaData = getBeanFactory().getBean( "MetaData" );
		
		// store config in request context
		rc.config = getBeanFactory().getBean( "Config" );
	}
	
	// ------------------------ CALLED WHEN VIEW RENDERING STARTS ------------------------ //	
	
	void function setupView(){
		// get data need to build the navigation
		rc.navigation = getBeanFactory().getBean( "ContentService" ).getNavigation();
	}
	
	// ------------------------ CALLED WHEN EXCEPTION OCCURS ------------------------ //	
	
	void function onError( Exception, event ){	
		if( StructKeyExists( application, "exceptiontracker" ) ) application.exceptiontracker.track( arguments.Exception );
		super.onError( arguments.Exception, arguments.event );
	}	
	
	// ------------------------ CALLED WHEN VIEW IS MISSING ------------------------ //	

	any function onMissingView( required rc ){
		var slug = LCase( ListLast( CGI.PATH_INFO, "/" ) );
		if ( slug == "" ) slug = rc.config.page.defaultslug; // set default
		rc.Page = getBeanFactory().getBean( "ContentService" ).getPageBySlug( slug );
		if( !rc.Page.isPersisted() ){
			var pagecontext = getPageContext().getResponse();
			pagecontext.getResponse().setStatus( 404 );
			rc.MetaData.setMetaTitle( "Page Not Found" ); 
			return view( "public:main/notfound" );
		}else{
			rc.breadcrumbs = getBeanFactory().getBean( "ContentService" ).getNavigationPath( rc.Page.getPageID() );
			
			rc.MetaData.setMetaTitle( rc.Page.getMetaTitle() ); 
			rc.MetaData.setMetaDescription( rc.Page.getMetaDescription() );
			rc.MetaData.setMetaKeywords( rc.Page.getMetaKeywords() );
			return view( "public:main/missingview" );
		}
	}
	
	// ------------------------ CONFIGURATION ------------------------ //	
	
	private struct function getConfig(){
		var config = {
			development = this.development
			, enquiry = {
				enabled = true
				, subject = "Enquiry"
				, emailto = ""
			}
			, exceptiontracker = { 
				emailnewexceptions = true
				, emailnewexceptionsto = ""
				, emailnewexceptionsfrom = ""
				, emailexceptionsashtml = true
			}
			, filemanager = {
				allowedextensions = "txt,gif,jpg,png,wav,mpeg3,pdf,zip,mp3,jpeg"
			}
			, name = ""
			, news = {
				enabled = true
				, recordsperpage = 10
				, rsstitle = ""
				, rssdescription = ""
			}
			, page = { 
				enableadddelete = true
				, maxlevels = 2 // number of page tiers that can be added - Bootstrap dropdown supports a maximum of 2
				, suppressaddpage = "" // comma delimited list of page ids for pages that cannot have child pages added
				, suppressdeletepage = "1" // comma delimited list of page ids for pages that cannot be deleted
				, suppressmovepage = "" // comma delimited list of page ids for pages that cannot be moved
				, defaultslug = "home" // default 'slug' to use to get homepage
			}
			, revision = Hash( Now() )
			, security = {
				resetpasswordemailfrom = ""
				, resetpasswordemailsubject = ""
				, whitelist = "^admin:security,^public:" // list of unsecure actions - by default all requests require authentication
			}
		};
		// override config in development mode
		if( config.development ){
			config.enquiry.emailto = "";
			config.exceptiontracker.emailnewexceptions = false;
			config.security.resetpasswordemailfrom = "";
		} 
		return config;
	}
	
	// ------------------------ FRAMEWORK HELPERS ------------------------ //
	
	/**
	* I override the FW/1 buildURL method to clean up the homepage URLs *
	**/
	public string function buildURL( string action = '.', string path = variables.magicBaseURL, any queryString = '' ) {
		var theurl = super.buildURL( arguments.action, arguments.path, arguments.queryString );
		theurl = ReReplace( theurl, "index\.cfm/#getBeanFactory().getBean( "Config" ).page.defaultslug#$", "" );
		return theurl;
	}

	// ------------------------ VIEW HELPERS ------------------------ //
	
	string function snippet( content, charactercount=100 ){
		var result = Trim( reReplace( arguments.content,"<[^>]{1,}>"," ","all" ) );
		if ( Len( result ) > arguments.charactercount+10 ){
			return Trim( Left( result, arguments.charactercount ) ) & "&hellip;";
		}
		else{
			return result;
		}
	}

}