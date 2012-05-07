<!---
	Xindi - http://www.getxindi.com/
	
	Copyright (c) 2012, Simon Binghamme.uk/)
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
				<div class="controls"><input class="input-xlarge" type="password" name="password" id="password" value="" maxlength="50"></div>
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
			errorClass: 'error', 
			errorElement: 'span'
		});
	});
	</script>		
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="user-form", context=rc.context )#	
</cfoutput>