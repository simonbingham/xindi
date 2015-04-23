component extends = "framework.one" {

	// ------------------------ CONSTANTS ------------------------ //

	variables.HTTP_STATUS_CODES = {
		NOT_FOUND = 404
	};

	// ------------------------ APPLICATION SETTINGS ------------------------ //

	this.applicationRoot = getDirectoryFromPath(getCurrentTemplatePath());
	this.name = Lcase(ReReplace(this.applicationroot, "[\W]", "", "all"));
	this.sessionManagement = true;
	// note: IsLocalHost on CF returns YES|NO which can't be passed to hibernate
	this.development = IsLocalHost(CGI.REMOTE_ADDR) ? true : false;

	// prevent bots creating lots of sessions
	if (structKeyExists(cookie, "CFTOKEN")) {
		this.sessionTimeout = createTimeSpan(0, 0, 20, 0);
	} else {
		this.sessionTimeout = createTimeSpan(0, 0, 0, 1);
	}
	this.mappings["/hoth"] = this.applicationRoot & "framework/hoth/";
	this.mappings["/model"] = this.applicationRoot & "model/";
	this.mappings["/ValidateThis"] = this.applicationRoot & "framework/ValidateThis/";
	this.datasource = ListLast(this.applicationRoot, "\/");
	this.ormEnabled = true;
	this.ormSettings = {
		flushAtRequestEnd = false
		, autoManageSession = false
		, cfcLocation = this.mappings["/model"]
		, eventHandling = true
		, eventHandler = "model.aop.GlobalEventHandler"
		, logSql = this.development
		, secondaryCacheEnabled = server.coldfusion.productName != "Lucee" ? true : false // throws an error if enabled on Lucee
	};

	// create database and populate when the application starts in development environment
	// you might want to comment out this code after the initial install
	if (this.development && !isNull(url.rebuild)) {
		this.ormSettings.dbCreate = "dropcreate";
		this.ormSettings.sqlScript = "_install/setup.sql";
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
			{"news" = "news", hint = "Redirect to news feature"}
			, {"enquiry" = "enquiry", hint = "Redirect to enquiry feature"}
		]
		, trace = false
		, diLocations = "public/controllers"
	};

	/*
	There is a known issue with Apache on a Windows server and colons, if you have this issue, change the subsystemDelimiter setting to something like "~"
	You will also need to update admin/Application.cfc
	*/

	// ------------------------ CALLED WHEN APPLICATION STARTS ------------------------ //

	void function setupApplication() {
		// add exception tracker to application scope
		local.HothConfig = new hoth.config.HothConfig();
		local.HothConfig.setApplicationName(getConfiguration().name);
		local.HothConfig.setLogPath(this.applicationRoot & "logs/hoth");
		local.HothConfig.setLogPathIsRelative(false);
		local.HothConfig.setEmailNewExceptions(getConfiguration().exceptionTracker.emailNewExceptions);
		local.HothConfig.setEmailNewExceptionsTo(getConfiguration().exceptionTracker.emailNewExceptionsTo);
		local.HothConfig.setEmailNewExceptionsFrom(getConfiguration().exceptionTracker.emailNewExceptionsFrom);
		local.HothConfig.setEmailExceptionsAsHTML(getConfiguration().exceptionTracker.emailExceptionsAsHtml);
		application.exceptionTracker = new Hoth.HothTracker(local.HothConfig);

		// setup bean factory
		local.beanFactory = new framework.ioc("/model", {singletonPattern = "(Service|Gateway)$"});
		setBeanFactory(local.beanFactory);

		// add validator bean to factory
		local.validatorConfig = {
			definitionPath = "/model/",
			JSIncludes = false,
			resultPath = "model.utility.ValidatorResult"
		};
		local.beanFactory.addBean("Validator", new ValidateThis.ValidateThis(local.validatorConfig));

		// add meta data bean to factory
		local.beanFactory.addBean("MetaData", new model.content.MetaData());

		// add config bean to factory
		local.beanFactory.addBean("config", getConfiguration());
	}

	// ------------------------ CALLED WHEN PAGE REQUEST STARTS ------------------------ //

	void function before(required rc) {
		if (this.development && !isNull(url.rebuild)) {
			ORMReload();
		}

		if (this.development) {
			writedump(var = "*** Request Start - #TimeFormat(Now(), 'full')# ***", output = "console");
		}

		// define base url
		rc.basehref = CGI.HTTPS eq "on" ? "https://" : "http://";
		rc.basehref &= CGI.HTTP_HOST & variables.framework.base;

		// define default meta data
		rc.MetaData = getBeanFactory().getBean("MetaData");

		// store config in request context
		rc.config = getBeanFactory().getBean("Config");
	}

	// ------------------------ CALLED WHEN VIEW RENDERING STARTS ------------------------ //

	void function setupView(required rc) {
		// get data needed to build the navigation
		if (getSubsystem() == "public") {
			rc.navigation = getBeanFactory().getBean("ContentService").getNavigation();
		}
	}

	// ------------------------ CALLED WHEN EXCEPTION OCCURS ------------------------ //

	void function onError(Exception, event) {
		if (StructKeyExists(application, "exceptionTracker")) {
			application.exceptionTracker.track(arguments.Exception);
		}
		super.onError(arguments.Exception, arguments.event);
	}

	// ------------------------ CALLED WHEN VIEW IS MISSING ------------------------ //

	any function onMissingView(required rc) {
		// Note: IIS and Apache report the CGI.PATH_INFO differently
		local.slug = LCase(ReReplace(Replace(CGI.PATH_INFO, CGI.SCRIPT_NAME, ""), "^/", "", "one"));
		if (local.slug == "") {
			local.slug = rc.config.page.defaultSlug; // set default
		}
		rc.Page = getBeanFactory().getBean("ContentService").getPageBySlug(slug = local.slug);
		if (!rc.Page.isPersisted()) {
			local.pageContext = getPageContext().getResponse();
			local.pageContext.setStatus(variables.HTTP_STATUS_CODES.NOT_FOUND);
			rc.MetaData.setMetaTitle("Page Not Found");
			return view("public#variables.framework.subsystemDelimiter#main/notfound");
		} else {
			rc.breadcrumbs = getBeanFactory().getBean("ContentService").getNavigationPath(pageId = rc.Page.getPageId());
			rc.MetaData.setMetaTitle(rc.Page.getMetaTitle());
			rc.MetaData.setMetaDescription(rc.Page.getMetaDescription());
			rc.MetaData.setMetaKeywords(rc.Page.getMetaKeywords());
			return view("public#variables.framework.subsystemDelimiter#main/missingview");
		}
	}

	// ------------------------ CONFIGURATION ------------------------ //

	private struct function getConfiguration() {
		local.config = {
			development = this.development
			, enquiry = {
				enabled = true
				, subject = "Enquiry"
				, emailto = ""
			}
			, exceptionTracker = {
				emailNewExceptions = true
				, emailNewExceptionsTo = ""
				, emailNewExceptionsFrom = ""
				, emailExceptionsAsHtml = true
			}
			, fileManager = {
				allowedExtensions = "txt,gif,jpg,png,wav,mpeg3,pdf,zip,mp3,jpeg"
			}
			, googleAnalyticsTrackingId = ""
			, name = ""
			, news = {
				enabled = true
				, recordsPerPage = 10
				, rssTitle = ""
				, rssDescription = ""
			}
			, page = {
				enableAddDelete = true
				, maxLevels = 2 // number of page tiers that can be added - Bootstrap dropdown supports a maximum of 2
				, suppressAddPage = "" // comma delimited list of page ids for pages that cannot have child pages added
				, suppressDeletePage = "1" // comma delimited list of page ids for pages that cannot be deleted
				, defaultSlug = "home" // default 'slug' to use to get homepage
			}
			, revision = Hash(Now())
			, security = {
				resetPasswordEmailFrom = ""
				, resetPasswordEmailSubject = ""
				, whitelist = "^admin#variables.framework.subsystemDelimiter#security,^public#variables.framework.subsystemDelimiter#" // list of unsecure actions - by default all requests require authentication
			}
			, version = "2015.4.23"
		};
		// override config in development mode
		if (local.config.development) {
			local.config.enquiry.emailTo = "";
			local.config.exceptionTracker.emailNewExceptions = false;
			local.config.security.resetPasswordEmailFrom = "";
		}
		return local.config;
	}

	// ------------------------ FRAMEWORK HELPERS ------------------------ //

	/**
	* I override the FW/1 buildURL method to clean up the homepage URLs *
	**/
	public string function buildURL(string action = ".", string path = variables.magicBaseURL, any queryString = "") {
		local.theUrl = super.buildURL(arguments.action, arguments.path, arguments.queryString);
		return ReReplace(local.theUrl, "index\.cfm/#getBeanFactory().getBean("Config").page.defaultSlug#$", "");
	}

	// ------------------------ VIEW HELPERS ------------------------ //

	string function snippet(required string content, numeric characterCount = 100) {
		local.result = Trim(reReplace(arguments.content, "<[^>]{1,}>", " ", "all"));
		if (Len(local.result) > arguments.characterCount + 10) {
			return "<p>" & Trim(Left(local.result, arguments.characterCount)) & "&hellip;</p>";
		} else {
			return local.result;
		}
	}

	string function getTimeInterval(required date theDate, string dateMask = "dddd dd mmmm yyyy") {
		local.result = "";
		if (IsDate(arguments.theDate)) {
			local.timeInSeconds = DateDiff("s", arguments.theDate, Now());
			// less than a minute
			if (local.timeInSeconds < 60) {
				local.result = " less than a minute ago";
			}
			// less than an hour
			else if (local.timeInSeconds < 3600) {
				local.interval = Int(local.timeInSeconds / 60);
				// more than 1 minute
				if (local.interval > 1) {
					local.result = local.interval & " minutes ago";
				} else {
					local.result = local.interval & " minute ago";
				}
			}
			// less than 24 hours
			else if (local.timeInSeconds < (86400) && Hour(Now()) >= Hour(arguments.theDate)) {
				local.interval = Int(local.timeInSeconds / 3600);
				// more than 1 hour
				if (local.interval > 1) {
					local.result = local.interval & " hours ago";
				} else {
					local.result = local.interval & " hour ago";
				}
			}
			// less than 48 hours
			else if (local.timeInSeconds < 172800) {
				local.result = "yesterday" & " at " & TimeFormat(arguments.theDate, "HH:MM");
			}
			// return the date
			else {
				local.result = DateFormat(arguments.theDate, arguments.dateMask) & " at " & TimeFormat(arguments.theDate, "HH:MM");
			}
		}
		return local.result;
	}

	boolean function isRoute(required string slug) {
		for (local.el in getRoutes()) {
			if (StructKeyExists(local.el, arguments.slug)) {
				return true;
			}
		}
		return false;
	}

}

