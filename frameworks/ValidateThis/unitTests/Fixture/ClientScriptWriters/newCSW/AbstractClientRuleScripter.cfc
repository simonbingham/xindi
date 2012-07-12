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
<cfcomponent output="false" name="AbstractClientRuleScripter" hint="I am a base object which all concrete ClientRuleScripters extend.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientRuleScripter">
		<cfargument name="Translator" type="Any" required="yes" />
		<cfset variables.Translator = arguments.Translator />
		<cfreturn this />
	</cffunction>

	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "if ($(""###arguments.validation.ClientFieldName#"").length) { " />

		<cfset var customMessage = "" />
		<cfif StructKeyExists(arguments.validation,"failureMessage")>
			<cfset customMessage = arguments.validation.failureMessage />
		</cfif>

		<cfset theScript &= generateRuleScript(argumentCollection=arguments,customMessage=customMessage) />

		<cfset theScript &= "}" />

		<cfreturn theScript />
		
	</cffunction>

	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="customMessage" type="Any" required="no" default="" />

		<cfreturn generateAddRule(argumentCollection=arguments) />
		
	</cffunction>

	<cffunction name="generateAddRule" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="customMessage" type="Any" required="no" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var paramName = "" />
		<cfset var paramList = "" />
		<cfset var ruleDef = getRuleDef(arguments.validation) />
		
		<cfif len(ruleDef) GT 0>
			<cfif len(arguments.customMessage) GT 0>
				<cfset arguments.customMessage = ", messages: {#ListFirst(ruleDef,':')#: '#JSStringFormat(variables.Translator.translate(arguments.customMessage,arguments.locale))#'}" />
			</cfif>
			<cfreturn "$(""###arguments.validation.ClientFieldName#"").rules('add',{#ruleDef##arguments.customMessage#});" />
		</cfif>
		
	</cffunction>

	<cffunction name="getRuleDef" returntype="any" access="private" output="false" hint="I return just the rule definition which is required for the generateAddRule method.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />

		<cfset var paramName = "" />
		<cfset var paramList = "" />
		<cfset var ruleDef = lCase(arguments.validation.ValType) & ": " />

		<cfif structKeyExists(arguments.validation,"Parameters") AND structCount(arguments.validation.Parameters) GT 0>
			<cfif structCount(arguments.validation.Parameters) EQ 1>
				<cfset paramName = structKeyArray(arguments.validation.Parameters) />
				<cfset paramName = paramName[1] />
				<cfset ruleDef &= arguments.validation.Parameters[paramName] />
			<cfelse>
				<cfset ruleDef &= "[" />
				<cfloop collection="#arguments.validation.Parameters#" item="paramName">
					<cfset paramList = listAppend(paramList,arguments.validation.Parameters[paramName]) />
				</cfloop>
				<cfset ruleDef &= paramList & "]" />
			</cfif>
		<cfelse>
			<cfset ruleDef &= "true" />
		</cfif>

		<cfreturn ruleDef />
		
	</cffunction>

	<cffunction name="generateAddMethod" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="theCondition" type="any" required="yes" hint="The conditon to test." />
		<cfargument name="customMessage" type="any" required="no" default="" hint="A custom message to display on failure." />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfset var fieldName = arguments.validation.ClientFieldName />
		<cfset var valType = arguments.validation.ValType />
		<cfset var messageScript = "" />
		<cfif Len(arguments.customMessage) GT 0>
			<cfset messageScript = ', "' & variables.Translator.translate(arguments.customMessage,arguments.locale) & '"' />
		</cfif>

		<cfsavecontent variable="theScript">
			<cfoutput>
				$.validator.addMethod("#fieldName##valType#", $.validator.methods.#valType##messageScript#);
				$.validator.addClassRules("#fieldName##valType#", {#fieldName##valType#: #arguments.theCondition#});
				$("###fieldName#").addClass('#fieldName##valType#');
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />
		
	</cffunction>

</cfcomponent>


