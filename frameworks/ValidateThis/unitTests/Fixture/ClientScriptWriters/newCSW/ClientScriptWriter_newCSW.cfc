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

	<cffunction name="generateJSIncludeScript" returntype="any" access="public" output="false" hint="I generate the JS to load the required JS libraries.">

		<cfset var theScript = "" />
		<cfset var JSRoot = variables.validateThisConfig.JSRoot />

		<cfsavecontent variable="theScript">
			<cfoutput>
				<script src="#JSRoot#jquery-1.3.2.min.js" type="text/javascript"></script>
				<script src="#JSRoot#jquery.field.min.js" type="text/javascript"></script>
				<script src="#JSRoot#jquery.validate.min.js" type="text/javascript"></script>
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />

	</cffunction>

	<cffunction name="generateLocaleScript" returntype="any" access="public" output="false" hint="I generate the JS to load the required locale specific JS libraries.">
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />
		<cfset var JSRoot = variables.validateThisConfig.JSRoot />

		<cfsavecontent variable="theScript">
			<cfoutput>
				<cfif Len(arguments.locale) and ListFirst(arguments.locale,"_") NEQ "en">
					<script src="#JSRoot#messages_#ListFirst(arguments.locale,'_')#.js" type="text/javascript"></script>
				</cfif>
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />

	</cffunction>

	<cffunction name="generateVTSetupScript" returntype="any" access="public" output="false" hint="I generate the JS to do some initial setup.">

		<cfset var theScript = "" />

		<cfsavecontent variable="theScript">
			<cfoutput>
				<script type="text/javascript">
					jQuery(document).ready(function($) {
						$.validator.addMethod("regex",function(v,e,p) {
							var re = param;
							return this.optional(element) || re.test(value);
						}, jQuery.format("The value entered does not match the specified pattern ({0})"));
						jQuery.validator.addMethod("boolean", function(value, element) {
							return this.optional(element) || isCFBoolean(value);
						}, jQuery.format("The value entered must be a boolean"));
					});
					function isCFBoolean( value )
					{
						if ( value==null )
						{
							return false
						}
						else 
						{
							var tocheck = value.toString();
							var pattern = /^((-){0,1}[0-9]{1,}(\.([0-9]{1,})){0,1}|true|false|yes|no)$/gi;
							return tocheck.match( pattern ) == null ? false : true;
						}
					}
				</script>
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />

	</cffunction>

	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theScript = "" />

		<!--- Conditional validations can only be generated for "required" type --->
		<cfif (NOT (StructCount(arguments.validation.Condition) GT 0 OR
			StructKeyExists(arguments.validation.Parameters,"DependentPropertyName")) OR arguments.validation.ValType EQ "required")
			AND StructKeyExists(variables.RuleScripters,arguments.validation.ValType)>
			<cfset theScript = variables.RuleScripters[arguments.validation.ValType].generateValidationScript(arguments.validation,arguments.locale) />
		</cfif>
		
		<cfreturn theScript />
		
	</cffunction>

	<cffunction name="generateScriptHeader" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">
		<cfargument name="formName" type="any" required="yes" />
		<cfset var theScript = "" />
		<cfsavecontent variable="theScript">
			<cfoutput>
				<script type="text/javascript">jQuery(document).ready(function($) {
					$("###arguments.formName#").validate();
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />
	</cffunction>
	
	<cffunction name="generateScriptFooter" returntype="any" access="public" output="false" hint="I generate the JS script required at the top of the script block.">
		<cfset var theScript = "" />
		<cfsavecontent variable="theScript">
			<cfoutput>
					
				});</script>
			</cfoutput>
		</cfsavecontent>
		<cfreturn theScript />
	</cffunction>
	
</cfcomponent>


