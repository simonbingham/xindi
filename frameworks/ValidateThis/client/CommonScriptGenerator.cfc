<!---
	
	Copyright 2009, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->

<cfcomponent output="false" name="CommonScriptGenerator" hint="I generate JS that is not specific to a Business Object (generally setup script).">
	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new BOValidator">
		<cfargument name="ClientValidator" type="any" required="true" />
		<cfset variables.ClientValidator = arguments.ClientValidator />
		<cfreturn this />
	</cffunction>

	<cffunction name="getInitializationScript" access="public" output="false" returntype="Any" hint="Asks the Client Validator to return some JS.">
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="JSIncludes" type="Any" required="no" default="true" />
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfargument name="format" type="Any" required="no" default="default" />

		<cfset var theScript = "" />
		
		<cfswitch expression="#arguments.format#">
			<cfcase value="remote">
				<cfif arguments.JSIncludes>
					<cfset theScript = variables.ClientValidator.getGeneratedJavaScript(JSLib=arguments.JSLib,scriptType="JSInclude") />
				</cfif>
				<cfif Len(arguments.locale)>
					<cfset theScript = theScript & variables.ClientValidator.getGeneratedJavaScript(JSLib=arguments.JSLib,scriptType="Locale",locale=arguments.locale) />
				</cfif>
			</cfcase>
			<cfcase value="json">
				<cfset theScript = theScript & variables.ClientValidator.getGeneratedJavaScript(JSLib=arguments.JSLib,scriptType="VTSetup") />
			</cfcase>
			<cfdefaultcase>
				<cfif arguments.JSIncludes>
					<cfset theScript = variables.ClientValidator.getGeneratedJavaScript(JSLib=arguments.JSLib,scriptType="JSInclude") />
				</cfif>
				<cfif Len(arguments.locale)>
					<cfset theScript = theScript & variables.ClientValidator.getGeneratedJavaScript(JSLib=arguments.JSLib,scriptType="Locale",locale=arguments.locale) />
				</cfif>
				<cfset theScript = theScript & variables.ClientValidator.getGeneratedJavaScript(JSLib=arguments.JSLib,scriptType="VTSetup") />
			</cfdefaultcase>
		</cfswitch>
		
		<cfreturn theScript />
	</cffunction>

</cfcomponent>