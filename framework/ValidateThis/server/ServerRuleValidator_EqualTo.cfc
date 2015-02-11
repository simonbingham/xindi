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
<cfcomponent output="false" name="ServerRuleValidator_EqualTo" extends="AbstractServerRuleValidator" hint="I am responsible for performing the EqualTo validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />


		<cfset var otherPropertyName = arguments.validation.getParameterValue("ComparePropertyName") />
		<cfset var otherVal = arguments.validation.getObjectValue(otherPropertyName) />
		<cfset var otherDesc = arguments.validation.getParameterValue("ComparePropertyDesc","") />
		<cfset var args = [arguments.validation.getPropertyDesc(),lCase(variables.defaultFailureMessagePrefix)] />

		<cfif len(otherDesc) eq 0>
			<cfset otherDesc = arguments.validation.getValidateThis().getPropertyDescription(objectType=arguments.validation.getObjectType(),propertyName="otherPropertyName") />
		</cfif>
		<cfif arguments.validation.getObjectValue() NEQ otherVal>
			<cfset arrayAppend(args,otherDesc) />
			<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_EqualTo",args,arguments.locale)) />
		</cfif>
	</cffunction>

</cfcomponent>
	

