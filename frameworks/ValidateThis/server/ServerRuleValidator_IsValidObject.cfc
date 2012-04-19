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
<cfcomponent output="false" extends="AbstractServerRuleValidator" hint="I am responsible for performing the IsValidObject validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />

		<cfset var parameters = arguments.validation.getParameters() />
		<cfset var theVal = arguments.validation.getObjectValue()/>
		<cfset var context = arguments.validation.getParameterValue("context","*")/>
		<cfset var objectType = arguments.validation.getParameterValue("objectType","") >
		<cfset var toCheck = []/>
		<cfset var theObject = 0/>
		<cfset var theResult = arguments.validation.getValidateThis().newResult()/>
		<cfset var validateArgumentCollection = {context=context,theResult=theResult,objectList=arguments.validation.getObjectList()} />
		<cfset var args = [arguments.validation.getPropertyDesc()] />
		
		<cfif not shouldTest(arguments.validation)><cfreturn/></cfif>

		<cfif isSimpleValue(theVal)> 
			<!--- Maybe this is a JSON string? Can this Handle the case? --->
			<cfif isJSON(theVal)>
				<cfset theVal = deserializeJSON(theVal)/>
			<cfelse>
				<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_IsValidObjectSimpleValue",args,arguments.locale)) />
				<cfreturn/>
			</cfif>
		</cfif> 
				
		<cfif isStruct(theVal) and (not isObject(theVal) and structCount(theVal) eq 0)>
			<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_IsValidObjectEmptyStruct",args,arguments.locale)) />
			<cfreturn/>
		<cfelseif isStruct(theVal) and arguments.validation.hasParameter("objectType")>
			<cfset objectType = arguments.validation.getParameterValue("objectType")>
		</cfif>
		
		<cfif  isArray(theVal) and arrayLen(theVal) eq 0>
			<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_IsValidObjectEmptyArray",args,arguments.locale)) />
			<cfreturn/>
		<cfelseif isArray(theVal)>
			<cfset toCheck = theVal/>
		<cfelse>
			<cfset arrayAppend(toCheck,theVal)/>
		</cfif>
		
		<cfloop array="#toCheck#" index="theObject">
			<!--- try to validate any apparent objects --->
			<cfset validateArgumentCollection.theObject = theObject />
			<cfset validateArgumentCollection.result = theResult />
			<cfif isSimpleValue(objectType) and len(objectType) gt 0>
				<cfset validateArgumentCollection.objectType = objectType />
			</cfif>
			<cfset theResult = arguments.validation.getValidateThis().validate(argumentCollection=validateArgumentCollection) />
			<cfif not theResult.getIsSuccess()>
				<cfset failWithResult(arguments.validation,theResult) />
			</cfif>
		</cfloop>
		
	</cffunction>

</cfcomponent>