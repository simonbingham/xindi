<!---
   Copyright 2012, Simon Bingham

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<cfoutput>
	<div class="page-header"><cfif rc.User.isPersisted()><h1>Edit User</h1><cfelse><h1>Add User</h1></cfif></div>

	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'users.save' )#" method="post" class="form-horizontal" id="user-form">
		<fieldset>
			<legend>User Details</legend>	
	
			<div class="control-group">
				<label class="control-label" for="firstname">First Name <cfif rc.Validator.propertyIsRequired( "firstname", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="firstname" id="firstname" value="#HtmlEditFormat( rc.User.getFirstName() )#" maxlength="50"></div>
			</div>

			<div class="control-group">
				<label class="control-label" for="lastname">Last Name <cfif rc.Validator.propertyIsRequired( "lastname", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="lastname" id="lastname" value="#HtmlEditFormat( rc.User.getLastName() )#" maxlength="50"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="email">Email Address <cfif rc.Validator.propertyIsRequired( "email", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="email" id="email" value="#HtmlEditFormat( rc.User.getEmail() )#" maxlength="50"></div>
			</div>			
			
			<div class="control-group">
				<label class="control-label" for="username">Username <cfif rc.Validator.propertyIsRequired( "username", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="username" id="username" value="#HtmlEditFormat( rc.User.getUsername() )#" maxlength="50"></div>
			</div>			

			<div class="control-group">
				<label class="control-label" for="password">Password <cfif rc.Validator.propertyIsRequired( "password", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="password" name="password" id="password" value="#HtmlEditFormat( rc.User.getPassword() )#" maxlength="50"></div>
			</div>			
		</fieldset>
		
		<div class="form-actions">
			<input type="submit" name="submit" id="submit" value="Save User" class="btn btn-primary">
		</div>
		
		<input type="hidden" name="userid" id="userid" value="#HtmlEditFormat( rc.User.getUserID() )#">
		<input type="hidden" name="context" id="context" value="#rc.context#">
	</form>
	
	<script>
	$(document).ready(function(){
		$.validator.setDefaults({
			errorClass: 'help-inline error', 
			errorElement: 'span'
		});
	});
	</script>		
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="user-form", context=rc.context )#	
</cfoutput>