<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false">

	<cferror exception="any" type="exception" template="ThrowError.cfm" />

	<cfsetting requesttimeout="200" />
	<cfset this.name = "ValidateThisFacadeDemo" />
	<cfset this.applicationtimeout = "#CreateTimeSpan(10,0,0,0)#" />
	<cfset this.clientmanagement = false />
	<cfset this.sessionmanagement = true />
	<cfset this.setclientcookies = true />
	<cfset this.sessiontimeout = CreateTimeSpan( 0, 0, 20, 0 ) />
	<cfset this.mappings["/model"]=GetDirectoryFromPath( GetCurrentTemplatePath() ) & "model" />
	<cfset this.mappings["/ValidateThis"]=ReReplace(CGI.CF_TEMPLATE_PATH, "functionalTests.*", "", "one" ) />
</cfcomponent>
