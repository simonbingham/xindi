<!---
	
	Copyright 2009, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfparam name="successMessage" default="" />

<cfscript>
	if (form.context EQ "Profile") {
		pageHeading = "Editing an existing User";
		loadStruct = {id=1,firstName="Bob",lastName="Silverberg"};
	} else {
		pageHeading = "Registering a new User";
		loadStruct = {id=0,firstName="",lastName=""};
	}
	user = createObject("component",url.type).init(argumentCollection=loadStruct);
</cfscript>

<!--- Default the validation failures to an empty struct --->
<cfset uniFormErrors = {} />
<!--- Are we processing the form? --->
<cfif StructKeyExists(form,"processing")>
	<!--- Populate the object from the form scope --->
	<cfloop collection="#form#" item="fld">
		<cfif StructKeyExists(user,"set" & fld)>
			<cfinvoke component="#user#" method="set#fld#">
				<cfinvokeargument name="#fld#" value="#form[fld]#" />
			</cfinvoke>
		</cfif>
	</cfloop>
	<!--- Validate the object using ValidateThis --->
	<cfset result = application.ValidateThis.validate(objectType=url.type,theObject=user,Context=Form.Context) />
	<cfset uniFormErrors = result.getFailuresForUniForm() />
	<!--- If validations passed, save the record --->
	<cfif result.getIsSuccess()>
		<cfset successMessage = "The User has been saved!" />
	<cfelse>
		<cfset successMessage = "" />
	</cfif>
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
			$("body").attr("JSError",msg);
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
	<cfset ValidationScript = application.ValidateThis.getValidationScript(objectType=url.type,Context=Form.Context) />
	<cfhtmlhead text="#ValidationScript#" />
</cfif>

<cfoutput>
<h1>ValidateThis End-to-End Test Fixture</h1>
<h3>#PageHeading# (JavaScript Validations are <cfif Form.NoJS>OFF<cfelse>ON</cfif>)</h3>
<cfif Len(successMessage)><h3>#successMessage#</h3></cfif>
<div class="formContainer">
<form action="index.cfm?type=#url.type#" id="frmMain" method="post" name="frmMain" class="uniForm">
	<input type="hidden" name="Context" id="Context" value="#Form.Context#" />
	<input type="hidden" name="NoJS" id="NoJS" value="#Form.NoJS#" />
	<input type="hidden" name="processing" id="processing" value="true" />

	<fieldset class="inlineLabels">
		<legend>User Information</legend>
		<div class="ctrlHolder">
			#isErrorMsg("firstName")#
			<label for="firstName">First Name</label>
			<input name="firstName" id="firstName" value="#user.getFirstName()#" size="35" maxlength="50" type="text" class="textInput" />
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("lastName")#
			<label for="lastName">Last Name</label>
			<input name="lastName" id="lastName" value="#user.getLastName()#" size="35" maxlength="50" type="text" class="textInput" />
		</div>
	</fieldset>

	<div class="buttonHolder">
		<button type="submit" class="submitButton"> Submit </button>
	</div>
</form> 

</div>
</cfoutput>

<!--- These UDFs are only required to make the demo look pretty --->

<cffunction name="isErrorMsg" returntype="any" output="false" hint="I am used to display error messages for a field.  I only exist for this demo page - there are much better ways of doing this!">
	<cfargument name="fieldName" type="any" required="yes" />
	<cfif StructKeyExists(uniFormErrors,arguments.fieldName)>
		<cfreturn '<p id="error-UserName" class="errorField bold">#uniFormErrors[arguments.fieldName]#</p>' />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>
