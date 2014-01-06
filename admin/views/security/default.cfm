<cfoutput>
	<div class="page-header hide"><h1>Login</h1></div>

	<form action="#buildURL('security/login')#" method="post" class="form-horizontal" id="login-form">
		<fieldset>
			<legend>Login Form</legend>

			#view("helpers/messages")#

			<div class="control-group <cfif rc.result.hasErrors('email')>error</cfif>">
				<label class="control-label" for="email">Email Address</label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="email" id="email" placeholder="Email Address">
					#view("helpers/failures", {property="email"})#
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors('password')>error</cfif>">
				<label class="control-label" for="password">Password</label>
				<div class="controls">
					<input class="input-xlarge" type="password" name="password" id="password" placeholder="Password">
					#view("helpers/failures", {property="password"})#
					<p class="help-block"><a href="#buildURL('security/password')#">Forgotten your password?</a></p>
				</div>
			</div>

			<div class="form-actions">
				<input type="submit" name="login" id="login" value="Login" class="btn btn-primary">
			</div>
		</fieldset>
	</form>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName="login-form", context="login")#
</cfoutput>
