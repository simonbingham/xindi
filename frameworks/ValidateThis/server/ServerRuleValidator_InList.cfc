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
<cfcomponent output="false" name="ServerRuleValidator_InList" extends="AbstractServerRuleValidator" hint="I am responsible for performing the InList validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />

		<cfset var theVal = arguments.validation.getObjectValue()/>
		<cfset var theList = ""/>
		<cfset var theDelim= ","/>
		<cfset var args = [arguments.validation.getPropertyDesc()] />

		<cfif arguments.validation.hasParameter("list")>
			<cfset theList = arguments.validation.getParameterValue("list")/>
		</cfif>

		<cfif arguments.validation.hasParameter("delim")>
			<cfset theDelim= arguments.validation.getParameterValue("delim")/>
		</cfif>

		<cfif shouldTest(arguments.validation) AND (not listLen(theList) or not len(theVal) or not listFindNoCase(theList,theVal,theDelim))>
			<cfset arrayAppend(args,theList) />
			<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_InList",args,arguments.locale)) />
		</cfif>
	</cffunction>
	
</cfcomponent>
