<cfoutput>
	<div class="page-header hide">
		<h1>Login</h1>
	</div>

	<form action="#buildURL('security/login')#" method="post" class="form-horizontal" id="login-form">
		<fieldset>
			<legend>Login Form</legend>

			#view("partials/messages")#

			<div class="form-group <cfif rc.result.hasErrors('email')>error</cfif>">
				<label for="email">Email Address</label>
				<input class="form-control" type="text" name="email" id="email">
				#view("partials/failures", {property = "email"})#
			</div>

			<div class="form-group <cfif rc.result.hasErrors('password')>error</cfif>">
				<label for="password">Password</label>
				<input class="form-control" type="password" name="password" id="password">
				#view("partials/failures", {property = "password"})#
				<p class="help-block"><a href="#buildURL('security/password')#">Forgotten your password?</a></p>
			</div>

			<input type="submit" name="login" id="login" value="Login" class="btn btn-primary">
		</fieldset>
	</form>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName = "login-form", context = "login")#
</cfoutput>
