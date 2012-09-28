<cfoutput>
	<div class="page-header clear"><cfif rc.User.isPersisted()><h1>Edit User</h1><cfelse><h1>Add User</h1></cfif></div>
	
	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'users.save' )#" method="post" class="form-horizontal" id="user-form">
		<fieldset>
			<legend>User Details</legend>	
	
			<div class="control-group <cfif rc.result.hasErrors( 'name' )>error</cfif>">
				<label class="control-label" for="name">Name <cfif rc.Validator.propertyIsRequired( "name", rc.context )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="name" id="name" value="#HtmlEditFormat( rc.User.getName() )#" maxlength="50">
					#view( "helpers/failures",{ property="name" })#
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