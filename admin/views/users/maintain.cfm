<cfoutput>
	<div class="page-header clear"><cfif rc.User.isPersisted()><h1>Edit User</h1><cfelse><h1>Add User</h1></cfif></div>
	
	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'users.save' )#" method="post" class="form-horizontal" id="user-form">
		<fieldset>
			<legend>User Details</legend>	
	
			<div class="control-group <cfif rc.result.hasErrors( 'firstname' )>error</cfif>">
				<label class="control-label" for="firstname">First Name <cfif rc.Validator.propertyIsRequired( "firstname", rc.context )>*</cfif></label>
				<div class="controls">
			<input class="input-xlarge" type="text" name="firstname" id="firstname" value="#HtmlEditFormat( rc.User.getFirstName() )#" maxlength="50">
					#view( "helpers/failures",{ property="firstname" })#
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors( 'lastname' )>error</cfif>"">
				<label class="control-label" for="lastname">Last Name <cfif rc.Validator.propertyIsRequired( "lastname", rc.context )>*</cfif></label>
				<div class="controls">
			<input class="input-xlarge" type="text" name="lastname" id="lastname" value="#HtmlEditFormat( rc.User.getLastName() )#" maxlength="50">
					#view( "helpers/failures", { property="lastname" })#
				</div>
			</div>
			
			<div class="control-group <cfif rc.result.hasErrors( 'email' )>error</cfif>"">
				<label class="control-label" for="email">Email Address <cfif rc.Validator.propertyIsRequired( "email", rc.context )>*</cfif></label>
				<div class="controls">
			<input class="input-xlarge" type="text" name="email" id="email" value="#HtmlEditFormat( rc.User.getEmail() )#" maxlength="50">
					#view( "helpers/failures", { property="email" })#
				</div>
			</div>			
			
			<div class="control-group <cfif rc.result.hasErrors( 'username' )>error</cfif>"">
				<label class="control-label" for="username">Username <cfif rc.Validator.propertyIsRequired( "username", rc.context )>*</cfif></label>
				<div class="controls">
			<input class="input-xlarge" type="text" name="username" id="username" value="#HtmlEditFormat( rc.User.getUsername() )#" maxlength="50">
					#view( "helpers/failures", { property="username" })#
				</div>
			</div>			

			<div class="control-group <cfif rc.result.hasErrors( 'password' )>error</cfif>"">
				<label class="control-label" for="password">Password <cfif rc.Validator.propertyIsRequired( "password", rc.context )>*</cfif></label>
				<div class="controls">
			<input class="input-xlarge" type="password" name="password" id="password" value="" maxlength="50">
					#view( "helpers/failures", { property="password" })#
				</div>
			</div>			
		</fieldset>
		
		<div class="form-actions">
	<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
	<input type="submit" name="submit" id="submit" value="Save &amp; exit" class="btn btn-primary">
			<a href="#buildURL( 'users' )#" class="btn cancel">Cancel</a>
		</div>
		
		<input type="hidden" name="userid" id="userid" value="#HtmlEditFormat( rc.User.getUserID() )#">
		<input type="hidden" name="context" id="context" value="#rc.context#">
	</form>	
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="user-form", context=rc.context )#	
</cfoutput>