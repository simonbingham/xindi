component extends="frameworks.org.corfield.framework"{

	// ------------------------ APPLICATION SETTINGS ------------------------ //

	this.applicationroot = getDirectoryFromPath(getCurrentTemplatePath());
	this.name = ListLast(this.applicationroot, "\/") & "_" & Hash(this.applicationroot);
	this.sessionmanagement = true;
	// note: IsLocalHost on CF returns YES|NO which can't be passed to hibernate
	this.development = IsLocalHost(CGI.REMOTE_ADDR) ? true : false;
	// prevent bots creating lots of sessions
	if (structKeyExists(cookie, "CFTOKEN")) this.sessiontimeout = createTimeSpan(0, 0, 20, 0);
	else this.sessiontimeout = createTimeSpan(0, 0, 0, 1);
	this.mappings["/hoth"] = this.applicationroot & "frameworks/hoth/";
	this.mappings["/model"] = this.applicationroot & "model/";
	this.mappings["/ValidateThis"] = this.applicationroot & "frameworks/ValidateThis/";
	this.datasource = ListLast(this.applicationroot, "\/");
	this.ormenabled = true;
	this.ormsettings = {
		flushatrequestend = false
		, automanagesession = false
		, cfclocation = this.mappings["/model"]
		, eventhandling = true
		, eventhandler = "model.aop.GlobalEventHandler"
		, logsql = this.development
		// secondary cache temporarily disabled for application to work in Railo 4
		// bug reported to Railo team - https://issues.jboss.org/browse/RAILO-2233
		//, secondarycacheenabled = true
	};

	// create database and populate when the application starts in development environment
	// you might want to comment out this code after the initial install
	if(this.development && !isNull(url.rebuild)){
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
		, SESOmitIndex = false /* set this to true if you have url rewrite enabled */
		, subsystemDelimiter = ":" // see note below
		, routes = [
			{"news"="news", hint="Redirect to news feature"}
			, {"enquiry"="enquiry", hint="Redirect to enquiry feature"}
		]
	};

	/*
	There is a known issue with Apache on a Windows server and colons, if you have this issue, change the subsystemDelimiter setting to something like "~"
	You will also need to update admin/Application.cfc
	*/

	// ------------------------ CALLED WHEN APPLICATION STARTS ------------------------ //

	void function setupApplication(){
		// add exception tracker to application scope
		var HothConfig = new hoth.config.HothConfig();
		HothConfig.setApplicationName(getConfiguration().name);
		HothConfig.setLogPath(this.applicationroot & "logs/hoth");
		HothConfig.setLogPathIsRelative(false);
		HothConfig.setEmailNewExceptions(getConfiguration().exceptiontracker.emailnewexceptions);
		HothConfig.setEmailNewExceptionsTo(getConfiguration().exceptiontracker.emailnewexceptionsto);
		HothConfig.setEmailNewExceptionsFrom(getConfiguration().exceptiontracker.emailnewexceptionsfrom);
		HothConfig.setEmailExceptionsAsHTML(getConfiguration().exceptiontracker.emailexceptionsashtml);
		application.exceptiontracker = new Hoth.HothTracker(HothConfig);

		// setup bean factory
		var beanfactory = new frameworks.org.corfield.ioc("/model", {singletonPattern = "(Service|Gateway)$"});
		setBeanFactory(beanfactory);

		// add validator bean to factory
		var validatorconfig = {definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult"};
		beanFactory.addBean("Validator", new ValidateThis.ValidateThis(validatorconfig));

		// add meta data bean to factory
		beanFactory.addBean("MetaData", new model.content.MetaData());

		// add config bean to factory
		beanFactory.addBean("config", getConfiguration());
	}

	// ------------------------ CALLED WHEN PAGE REQUEST STARTS ------------------------ //

	void function setupRequest(){
		if(this.development && !isNull(url.rebuild)) ORMReload();

		if(this.development) writedump(var="*** Request Start - #TimeFormat(Now(), 'full')# ***", output="console");

		// define base url
		if(CGI.HTTPS eq "on") rc.basehref = "https://";
		else rc.basehref = "http://";
		rc.basehref &= CGI.HTTP_HOST & variables.framework.base;

		// define default meta data
		rc.MetaData = getBeanFactory().getBean("MetaData");

		// store config in request context
		rc.config = getBeanFactory().getBean("Config");
	}

	// ------------------------ CALLED WHEN VIEW RENDERING STARTS ------------------------ //

	void function setupView(){
		// get data needed to build the navigation
		if (getSubsystem() == "public") rc.navigation = getBeanFactory().getBean("ContentService").getNavigation();
	}

	// ------------------------ CALLED WHEN EXCEPTION OCCURS ------------------------ //

	void function onError(Exception, event){
		if(StructKeyExists(application, "exceptiontracker")) application.exceptiontracker.track(arguments.Exception);
		super.onError(arguments.Exception, arguments.event);
	}

	// ------------------------ CALLED WHEN VIEW IS MISSING ------------------------ //

	any function onMissingView(required rc){
		// Note: IIS and Apache report the CGI.PATH_INFO differently
		var slug = LCase(ReReplace(Replace(CGI.PATH_INFO, CGI.SCRIPT_NAME, ""), "^/", "", "one"));
		if (slug == "") slug = rc.config.page.defaultslug; // set default
		rc.Page = getBeanFactory().getBean("ContentService").getPageBySlug(slug);
		if(!rc.Page.isPersisted()){
			var pagecontext = getPageContext().getResponse();
			pagecontext.setStatus(404);
			rc.MetaData.setMetaTitle("Page Not Found");
			return view("public#variables.framework.subsystemDelimiter#main/notfound");
		}else{
			rc.breadcrumbs = getBeanFactory().getBean("ContentService").getNavigationPath(rc.Page.getPageID());
			rc.MetaData.setMetaTitle(rc.Page.getMetaTitle());
			rc.MetaData.setMetaDescription(rc.Page.getMetaDescription());
			rc.MetaData.setMetaKeywords(rc.Page.getMetaKeywords());
			return view("public#variables.framework.subsystemDelimiter#main/missingview");
		}
	}

	// ------------------------ CONFIGURATION ------------------------ //

	private struct function getConfiguration(){
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
			, googleanalyticstrackingid = ""
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
				, defaultslug = "home" // default 'slug' to use to get homepage
			}
			, revision = Hash(Now())
			, security = {
				resetpasswordemailfrom = ""
				, resetpasswordemailsubject = ""
				, whitelist = "^admin#variables.framework.subsystemDelimiter#security,^public#variables.framework.subsystemDelimiter#" // list of unsecure actions - by default all requests require authentication
			}
			, version = "2014.1.7"
		};
		// override config in development mode
		if(config.development){
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
	public string function buildURL(string action = '.', string path = variables.magicBaseURL, any queryString = '') {
		var theurl = super.buildURL(arguments.action, arguments.path, arguments.queryString);
		theurl = ReReplace(theurl, "index\.cfm/#getBeanFactory().getBean("Config").page.defaultslug#$", "");
		return theurl;
	}

	// ------------------------ VIEW HELPERS ------------------------ //

	string function snippet(content, charactercount=100){
		var result = Trim(reReplace(arguments.content, "<[^>]{1,}>", " ", "all"));
		if (Len(result) > arguments.charactercount + 10) return "<p>" & Trim(Left(result, arguments.charactercount)) & "&hellip;</p>";
		else return result;
	}

	string function getTimeInterval(date, datemask="dddd dd mmmm yyyy"){
		var timeinseconds = 0;
		var result = "";
		var interval = "";
		if(IsDate(arguments.date)){
			timeinseconds = DateDiff('s', arguments.date, Now());
			// less than a minute
			if(timeinseconds < 60){
				result = " less than a minute ago";
			}
			// less than an hour
			else if (timeinseconds < 3600){
				interval = Int(timeinseconds / 60);
				// more than 1 minute
				if (interval > 1) result = interval & " minutes ago";
				else result = interval & " minute ago";
			}
			// less than 24 hours
			else if (timeinseconds < (86400) && Hour(Now()) >= Hour(arguments.date)){
				interval = Int(timeinseconds / 3600);
				// more than 1 hour
				if (interval > 1) result = interval & " hours ago";
				else result = interval & " hour ago";
			}
			// less than 48 hours
			else if (timeinseconds < 172800){
				result = "yesterday" & " at " & TimeFormat(arguments.date, "HH:MM");
			}
			// return the date
			else{
				result = DateFormat(arguments.date, arguments.datemask) & " at " & TimeFormat(arguments.date, "HH:MM");
			}
		}
		return result;
	}

	boolean function isRoute(required slug){
		for (var el in getRoutes()){
			if (StructKeyExists(el, arguments.slug)) return true;
		}
		return false;
	}

}

