<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfparam name="successMessage" default="" />
<cfparam name="form.context" default="" />

<cfscript>
	UniFormErrors = {};
</cfscript>

<!--- Are we displaying a form or processing a form? --->
<cfif StructKeyExists(Form,"Processing")>
	<!--- Populate the object from the form scope --->
	<cfloop collection="#form#" item="fld">
		<cfif StructKeyExists(user,"set" & fld)>
			<cfinvoke component="#user#" method="set#fld#">
				<cfinvokeargument name="#fld#" value="#form[fld]#" />
			</cfinvoke>
		</cfif>
	</cfloop>
	<cfset Result = application.ValidateThis.validate(theObject=user,context=form.context) />
	<cfset UniFormErrors = Result.getFailuresForUniForm() />
	<cfset SuccessMessage = Result.getSuccessMessage() />
	<cfset user = Result.getTheObject() />
<cfelse>
	<cfset user = createObject("component","User").init(userGroup="") />
</cfif>

<!--- If we want JS validations turned on, get the Script blocks to initialize the libraries and for the validations themselves, and include them in the <head> --->
<cfif NOT Form.NoJS>
	<cfset ValInit = application.ValidateThis.getInitializationScript() />
	<cfhtmlhead text="#ValInit#" />
	<!--- Some formatting rules specific to this form --->
	<cfsavecontent variable="headJS">
		<script type="text/javascript">
		// to allow Selenium to detect errors
		window.onerror=function(msg){
			jQuery("body").attr("JSError",msg);
		}

		jQuery(document).ready(function($) {
			jQuery.validator.setDefaults({ 
				errorClass: 'errorField', 
				errorElement: 'p', 
				errorPlacement: function(error, element) { 
					error.prependTo( element.parents('div.ctrlHolder') ) 
				}, 
				highlight: function() {}
			});
		});
		</script>
	</cfsavecontent>	
	<cfhtmlhead text="#headJS#" />
</cfif>

<cfoutput>
<h1>ValidateThis End-to-End Test - Two Forms One Object</h1>
<h3>JavaScript Validations are <cfif Form.NoJS>OFF<cfelse>ON</cfif></h3>
<cfif Len(SuccessMessage)><h3>#SuccessMessage#</h3></cfif>
<cfset theContext = "Register" />
<cfinclude template="theForm.cfm" />
<cfset theContext = "Profile" />
<cfinclude template="theForm.cfm" />
</cfoutput>

<!--- These UDFs are only required to make the demo look pretty --->
<cffunction name="isRequired" returntype="any" output="false" hint="I am used to display an asterisk for required fields.  I only exist for this demo page - there are much better ways of doing this!">
	<cfargument name="fieldName" type="any" required="yes" />
	<cfif StructKeyExists(RequiredFields,arguments.fieldName)>
		<cfreturn "<em>*</em> " />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>

<cffunction name="isErrorMsg" returntype="any" output="false" hint="I am used to display error messages for a field.  I only exist for this demo page - there are much better ways of doing this!">
	<cfargument name="fieldName" type="any" required="yes" />
	<cfif StructKeyExists(UniFormErrors,arguments.fieldName)>
		<cfreturn '<p id="error-UserName" class="errorField bold">#UniFormErrors[arguments.fieldName]#</p>' />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>


