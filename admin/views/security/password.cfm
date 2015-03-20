<cfoutput>
	<div class="page-header hide">
		<h1>Reset Password</h1>
	</div>

	<form action="#buildURL('security/resetpassword')#" method="post" class="form-horizontal" id="password-form">
		<fieldset>
			<legend>Reset Password</legend>

			#view("partials/messages")#

			<div class="form-group <cfif rc.result.hasErrors('email')>error</cfif>">
				<label for="email">Email Address</label>
				<input class="form-control" type="text" name="email" id="email" placeholder="Email Address">
				#view("partials/failures", {property = "email"})#
			</div>

			<input type="submit" name="submit" id="submit" value="Reset Password" class="btn btn-primary">
		</fieldset>
	</form>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName = "password-form", context = "password")#
</cfoutput>
