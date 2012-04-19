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
<cfcomponent output="false" name="AbstractServerRuleValidator" hint="I am an abstract validator responsible for performing one specific type of validation.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ServerRuleValidator">
		<cfargument name="messageHelper" type="any" required="true" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />

		<cfset variables.messageHelper = arguments.messageHelper />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />

		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" returntype="void" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object being used to perform the validation." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />

		<cfthrow type="validatethis.server.AbstractServerRuleValidator.methodnotdefined"
				message="I am an abstract object, hence the validate method must be overriden in a concrete object." />

		<!---
		<cfif false>
			<cfset fail(arguments.validation,"Failure Message") />
		</cfif>
		--->
	</cffunction>
	
	<cffunction name="fail" returntype="void" access="private" output="false" hint="I do what needs to be done when a validation fails.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object being used to perform the validation." />
		<cfargument name="FailureMessage" type="any" required="yes" hint="A Failure message to store." />
	
		<cfset arguments.validation.fail(arguments.FailureMessage) />
	</cffunction>

	<cffunction name="failWithResult" returntype="void" access="private" output="false" hint="I do what needs to be done when a validation fails.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object being used to perform the validation." />
		<cfargument name="result" type="any" required="yes" hint="A Result to store." />
	
		<cfset arguments.validation.failWithResult(arguments.result) />
	</cffunction>

	<cffunction name="propertyIsRequired" returntype="boolean" access="private" output="false" hint="I determine whether the current property is required.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object being used to perform the validation." />
	
		<cfreturn arguments.validation.getIsRequired() />
	</cffunction>

	<cffunction name="shouldTest" returntype="boolean" access="private" output="false" hint="I determine whether the test should be performed, based on optionality and empty value.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object being used to perform the validation." />
	
		<cfreturn (arguments.validation.propertyHasValue() OR propertyIsRequired(arguments.validation)) />
	</cffunction>

</cfcomponent>
	

