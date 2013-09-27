<!---
	
	Copyright 2010, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ServerRuleValidator_FutureDate" extends="AbstractServerRuleValidator" hint="I am responsible for performing the future date validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />

        <cfset var theVal = arguments.validation.getObjectValue()/>
		<cfset var theDate = now()/>
		<cfset var parameterMessages = ""/>
		<cfset var args = [arguments.validation.getPropertyDesc()] />
		<cfset var msgKey = "defaultMessage_FutureDate" />

		<cfif arguments.validation.hasParameter("after")>
			<cfset theDate = arguments.validation.getParameterValue("after")/>
			<cfset msgKey = "defaultMessage_FutureDate_WithAfter" />
			<cfset arrayAppend(args,theDate) />
		</cfif>

		<cfif shouldTest(arguments.validation) AND (not isValid("date",theVal) OR (isValid("date",theVal) AND not dateCompare(theVal,theDate) gt 0))>
			<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage(msgKey,args,arguments.locale)) />
		</cfif>
	</cffunction>
	
</cfcomponent>
