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
<cfcomponent output="false" name="ClientScriptWriter_jQuery" extends="ValidateThis.client.AbstractClientScriptWriter" hint="I am responsible for generating jQuery Javascript statements to implement validations.">

		
	<cffunction name="generateJSFieldRefence" returntype="any" access="public" output="false" hint="I generate the jQuery selector that references the field name.">
		<cfargument name="fieldname" type="any" required="yes" hint="The field name." />
		<cfargument name="formName" type="Any" required="yes" hint="The form name." />
		
		<cfset var theScript = "" />
		<cfset var safeFormName = getSafeFormName(arguments.formName) />
		
		<cfsavecontent variable="theScript"><cfoutput>fm['#arguments.fieldname#'] = $(":input[name='#arguments.fieldname#']",$form_#safeFormName#);</cfoutput></cfsavecontent>
		<cfreturn theScript>

	</cffunction>
	
	<cffunction name="generateJSIncludeScript" returntype="any" access="public" output="false" hint="I generate the JS to load the required JS libraries.">

		<cfset var theScript = "" />

		<cfsavecontent variable="theScript">
			<cfoutput>
				<script src="//ajax.microsoft.com/ajax/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
				<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
				<!---<script src="ajax.aspnetcdn.com/ajax/jquery.validate/1.9/additional-methods.min.js" type="text/javascript"></script>--->
				<script type="text/javascript">
				/*<![CDATA[*/
				<cfinclude template="JS/jquery.field.min.js">
				/*]]>*/
				</script>
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />

	</cffunction>

	<cffunction name="generateLocaleScript" returntype="any" access="public" output="false" hint="I generate the JS to load the required locale specific JS libraries.">
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />

		<cfsavecontent variable="theScript">
			<cfoutput>
				<cfif Len(arguments.locale) and ListFirst(arguments.locale,"_") NEQ "en">
					<script type="text/javascript">
					/*<![CDATA[*/
					<cfinclude template="JS/localization/messages_#ListFirst(arguments.locale,'_')#.js">
					/*]]>*/
					</script>
				</cfif>
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />

	</cffunction>

	<cffunction name="generateVTSetupScript" returntype="any" access="public" output="false" hint="I generate the JS to do some initial setup.">
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfset var scripter = "" />
		<cfset var theScript = "" />
		<cfset var scripters = this.getRuleScripters()/>

		<cfsavecontent variable="theScript"><cfoutput>
		<script type="text/javascript">
		/*<![CDATA[*/
		jQuery(function($){
			<cfloop collection="#scripters#" item="scripter">
				<cfif structKeyExists(scripters[scripter],"generateInitScript")>
					<!--- strip out JS commentse --->
					#ReReplace( scripters[scripter].generateInitScript(), "//[^\n\r]{1,}", "", "all" )#
				</cfif>
			</cfloop>
		});
		/*]]>*/
		</script>
		</cfoutput>
		</cfsavecontent>
		<!--- strip whitespace --->
		<cfreturn ReReplace( theScript, "[\n\r\t]", "", "all" ) />

	</cffunction>

	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="yes" />

		<cfset var theScript = "" />
		<cfset var valType = arguments.validation.getValType() />

		<!--- Conditional validations can only be generated for "required" type --->
		<cfif (NOT (StructCount(arguments.validation.getCondition()) GT 0 OR
			StructKeyExists(arguments.validation.getParameters(),"DependentPropertyName")) OR valType EQ "required")
			AND StructKeyExists(variables.RuleScripters,valType)>
			<cfset theScript = variables.RuleScripters[valType].generateValidationScript(arguments.validation,arguments.locale,arguments.formName) />
		</cfif>
		
		<cfreturn theScript />
		
	</cffunction>
	
	<cffunction name="generateValidationJSON" returntype="any" access="public" output="false" hint="I generate the JSON rule required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="formName" type="Any" required="yes" />
		<cfset var theValidation = {} />
		<cfset var theJSON = "" />
		<cfset var valType = arguments.validation.getValType() />

		<cfif StructKeyExists(variables.RuleScripters,valType)>
			<cfset theJSON = variables.RuleScripters[valType].generateValidationJSON(arguments.validation,arguments.locale,arguments.formName) />
		</cfif>
		
		<cfreturn theJSON />
	</cffunction>

	<cffunction name="generateConditionJSON" returntype="any" access="public" output="false" hint="I generate the JSON condition required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfset var theValidation = {} />
		<cfset var theJSON = "" />
		<cfset var valType = arguments.validation.getValType() />

		<cfif arguments.validation.hasClientTest()>
			<cfif StructKeyExists(variables.RuleScripters,valType)>
				<cfset theJSON = variables.RuleScripters[valType].generateConditionJSON(arguments.validation,arguments.formName,arguments.locale) />
			</cfif>
		</cfif>

		<cfreturn theJSON />
	</cffunction>


	<cffunction name="generateScriptHeader" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">
		<cfargument name="formName" type="any" required="yes" />
		<cfset var theScript = "" />
		<cfset var safeFormName = getSafeFormName(arguments.formName) />
		<cfsavecontent variable="theScript">
			<cfoutput>
				<script type="text/javascript">
				/*<![CDATA[*/jQuery(function($){var $form_#safeFormName# = $("###arguments.formName#");$form_#safeFormName#.validate({ignore:'.ignore'});
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />
	</cffunction>
	
	<cffunction name="generateScriptFooter" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">
		<cfset var theScript = "" />
		<cfsavecontent variable="theScript">
			<cfoutput>});/*]]>*/</script></cfoutput>
		</cfsavecontent>
		<cfreturn theScript />
	</cffunction>
	
</cfcomponent>


