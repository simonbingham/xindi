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
<cfcomponent output="false" name="AbstractClientScriptWriter" hint="I am an abstract class responsible for generating script for a particular JS implementation (e.g., qForms, jQuery, etc.).">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ClientScriptWriter">
		<cfargument name="childObjectFactory" type="any" required="true" />
		<cfargument name="Translator" type="any" required="true" />
		<cfargument name="messageHelper" type="any" required="true" />
		<cfargument name="JSRoot" type="string" required="true" />
		<cfargument name="extraClientScriptWriterComponentPaths" type="string" required="true" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />
		<cfargument name="vtFolder" type="string" required="true" />
		<cfset variables.childObjectFactory = arguments.childObjectFactory />
		<cfset variables.Translator = arguments.Translator />
		<cfset variables.messageHelper = arguments.messageHelper />
		<cfset variables.JSRoot = arguments.JSRoot />
		<cfset variables.extraClientScriptWriterComponentPaths = arguments.extraClientScriptWriterComponentPaths />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />
		<cfset variables.vtFolder = arguments.vtFolder />

		<cfset setRuleScripters() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="yes" />

		<cfthrow type="validatethis.client.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateValidationScript method must be overriden in a concrete object." />

	</cffunction>

	<cffunction name="generateScriptHeader" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">
		<cfargument name="formName" type="any" required="yes" />

		<cfthrow type="validatethis.client.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateScriptHeader method must be overriden in a concrete object." />

	</cffunction>
	
	<cffunction name="generateScriptFooter" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">

		<cfthrow type="validatethis.client.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateScriptFooter method must be overriden in a concrete object." />

	</cffunction>
	
	<cffunction name="generateJSFieldRefence" returntype="any" access="public" output="false" hint="I generate the JS script that references the field name.">
		<cfargument name="fieldname" type="any" required="yes" hint="The field name." />
		<cfargument name="formName" type="Any" required="yes" hint="The form name." />

		<cfthrow type="validatethis.client.AbstractClientScriptWriter.generateJSFieldRefence"
				message="I am an abstract object, hence the generateJSFieldRefence method must be overriden in a concrete object." />

	</cffunction>
	
	<cffunction name="generateJSIncludeScript" returntype="any" access="public" output="false" hint="I generate the JS to load the required JS libraries.">

		<cfthrow type="validatethis.client.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateJSIncludeScript method must be overriden in a concrete object." />

	</cffunction>

	<cffunction name="generateLocaleScript" returntype="any" access="public" output="false" hint="I generate the JS to load the required locale specific JS libraries.">
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfthrow type="validatethis.client.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateJSLocaleIncludeScript method must be overriden in a concrete object." />

	</cffunction>

	<cffunction name="generateVTSetupScript" returntype="any" access="public" output="false" hint="I generate the JS to do some initial setup.">

		<cfthrow type="validatethis.client.AbstractClientScriptWriter.methodnotdefined"
				message="I am an abstract object, hence the generateSetupScript method must be overriden in a concrete object." />

	</cffunction>

	<cffunction name="getSafeFormName" returntype="any" access="public" output="false" hint="I generate a form name that is safe to use as part of a JS variable.">
		<cfargument name="formName" type="Any" required="yes" />

		<cfreturn reReplace(arguments.formName,"[\W]","","all") />

	</cffunction>

	<cffunction name="getRuleScripters" access="public" output="false" returntype="any">
		<cfreturn variables.RuleScripters />
	</cffunction>
	<cffunction name="setRuleScripters" returntype="void" access="private" output="false" hint="I create rule validator objects from a list of component paths">
		<cfset var dirName = listLast(listLast(getMetadata(this).Name,"."),"_") />
		<cfset var initArgs = {translator=variables.translator,messageHelper=variables.messageHelper,defaultFailureMessagePrefix=variables.defaultFailureMessagePrefix,vtFolder=variables.vtFolder} />
		<cfset variables.RuleScripters = variables.childObjectFactory.loadChildObjects(variables.vtFolder & ".client.#dirName#" & "," & variables.extraClientScriptWriterComponentPaths,"ClientRuleScripter_",structNew(),initArgs) />
	</cffunction>

</cfcomponent>
	

