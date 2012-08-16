<cfcomponent output="false">

	<cfsetting requesttimeout="200" />
	<cfset this.name = "ValidateThisTestFixtureQUnit" />
	<cfset this.applicationtimeout = "#CreateTimeSpan(10,0,0,0)#" />
	<cfset this.clientmanagement = false />
	<cfset this.sessionmanagement = true />
	<cfset this.setclientcookies = true />
	<cfset this.sessiontimeout = CreateTimeSpan( 0, 0, 20, 0 ) />
	<cfset this.mappings["/validatethis"] = ReReplaceNoCase( CGI.CF_TEMPLATE_PATH, "unitTests.*", "" ) />
	
</cfcomponent>