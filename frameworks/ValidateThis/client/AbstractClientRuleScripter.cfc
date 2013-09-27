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
<cfcomponent output="false" name="AbstractClientRuleScripter" hint="I am an abstract scripter responsible for generating JS code for one specific type of validation.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientRuleScripter">
		<cfargument name="Translator" type="Any" required="yes" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />

		<cfset variables.Translator = arguments.Translator />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />
		<cfreturn this />
	</cffunction>

	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="yes" />

		<cfthrow type="validatethis.client.AbstractClientRuleScripter.methodnotdefined"
				message="I am an abstract object, hence the generateValidationScript method must be overriden in a concrete object." />

		<!--- <cfreturn JSScript /> --->
		
	</cffunction>

</cfcomponent>






