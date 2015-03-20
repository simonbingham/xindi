<cfoutput>
	<div class="page-header clear">
		<h1>#rc.pageTitle#</h1>
	</div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('users')#" class="btn"><i class="glyphicon glyphicon-arrow-left"></i> Back to User Accounts</a>
		<cfif rc.User.getUserId() neq rc.CurrentUser.getUserId() and rc.User.isPersisted()>
			<a href="#buildURL('users.delete')#/userid/#rc.User.getUserId()#" title="Delete" class="btn btn-danger"><i class="glyphicon glyphicon-trash glyphicon-white"></i> Delete</a>
		</cfif>
	</div>

	<div class="clear"></div>

	#view("partials/messages")#

	<form action="#buildURL('users.save')#" method="post" class="form-horizontal" id="user-form">
		<fieldset>
			<legend>User Details</legend>

			<div class="form-group <cfif rc.result.hasErrors('name')>error</cfif>">
				<label for="name">Name <cfif rc.Validator.propertyIsRequired("name", rc.context)>*</cfif></label>
				<input class="form-control" type="text" name="name" id="name" value="#HtmlEditFormat(rc.User.getName())#" maxlength="50">
				#view("partials/failures",{property = "name"})#
			</div>

			<div class="form-group <cfif rc.result.hasErrors('email')>error</cfif>">
				<label for="email">Email Address <cfif rc.Validator.propertyIsRequired("email", rc.context)>*</cfif></label>
				<input class="form-control" type="text" name="email" id="email" value="#HtmlEditFormat(rc.User.getEmail())#" maxlength="50">
				#view("partials/failures", {property = "email"})#
			</div>

			<div class="form-group <cfif rc.result.hasErrors('password')>error</cfif>">
				<label for="password">Password <cfif rc.Validator.propertyIsRequired("password", rc.context)>*</cfif></label>
				<input class="form-control" type="password" name="password" id="password" value="" maxlength="50" placeholder="Password">
				#view("partials/failures", {property = "password"})#
			</div>
		</fieldset>

		<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
		<input type="submit" name="submit" id="submit" value="Save &amp; exit" class="btn btn-primary">
		<a href="#buildURL('users')#" class="btn cancel">Cancel</a>

		<input type="hidden" name="userid" id="userid" value="#HtmlEditFormat(rc.User.getUserId())#">
		<input type="hidden" name="context" id="context" value="#rc.context#">
	</form>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName = "user-form", context = rc.context)#
</cfoutput>
