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
<cfcomponent output="false" name="ServerRuleValidator_Custom" extends="AbstractServerRuleValidator" hint="I am responsible for performing a custom validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />
		<cfset var customResult = 0 />
		<cfset var failureMessage = "A custom validator failed." />
		<cfset var theObject = arguments.validation.getTheObject() />
		<cfset var theMethod = ""/>
		<cfset var fileContent = ""/>
		
		<cfif arguments.validation.hasParameter("methodName") and arguments.validation.hasParameter("remoteURL") and arguments.validation.getParameterValue("proxied",false)>
			<cfif isValid("url",arguments.validation.getParameterValue("remoteURL"))>
				<cfset theMethod = arguments.validation.getParameterValue("remoteURL")>
			<cfelseif structKeyExists(cgi,"http_host") and len(cgi.http_host) gt 0>
				<cfset theMethod = CGI.http_host & arguments.validation.getParameterValue("remoteURL")>
			</cfif>	
			<cfif len(theMethod) gt 0>
				<cfhttp method="post" url="#theMethod#" result="customResult">
					<cfhttpparam type="url" name="method" value="#arguments.validation.getParameterValue('methodName')#">
					<cfhttpparam type="url" name="#arguments.validation.getClientFieldName()#" value="#arguments.validation.getObjectValue()#">
				</cfhttp>
				
				<cfif isStruct(customResult) and isSimpleValue(customResult.fileContent)>
					<cfset fileContent = customResult.fileContent/>
					<cfset customResult = evaluate(fileContent.toString())/>
					<cfset failureMessage = failureMessage & " (#arguments.validation.getPropertyName()#=#arguments.validation.getObjectValue()# - valid: #customResult#)"/>
				</cfif>	
			</cfif>
		<cfelseif arguments.validation.hasParameter("methodName")>
			<cfset theMethod = arguments.validation.getParameterValue("methodname") />
			<cfset customResult = evaluate("theObject.#theMethod#()") />
		</cfif>

		<cfif !IsDefined("customResult") or (isBoolean(customResult) and customResult) or (isStruct(customResult) and (structKeyExists(customResult,"IsSuccess") and customResult.IsSuccess))>
			<cfreturn />
		</cfif>
		
		<cfif isStruct(customResult) and structKeyExists(customResult,"failureMessage")>
			<cfset failureMessage = customResult.failureMessage />
		<cfelseif len(arguments.validation.getFailureMessage()) GT 0>
			<cfset failureMessage = arguments.validation.getFailureMessage() /> 
		</cfif>
		
		<cfset fail(arguments.validation,failureMessage) />
		
	</cffunction>

</cfcomponent>
	
