<cfoutput>
	<div class="page-header hide"><h1>Reset Password</h1></div>

	<form action="#buildURL( 'security/resetpassword' )#" method="post" class="form-horizontal" id="password-form">
	    <fieldset>
	        <legend>Reset Password</legend>
			
			#view( "helpers/messages" )#
			
			<div class="control-group <cfif rc.result.hasErrors( 'username' )>error</cfif>">
				<label class="control-label" for="username">Email or Username</label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="username" id="username">
					#view( "helpers/failures", { property="username" })#
				</div>
			</div>
			
			<div class="form-actions">
				<input type="submit" name="submit" id="submit" value="Reset Password" class="btn btn-primary">
			</div>
		</fieldset>
	</form>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="password-form", context="password" )#
</cfoutput>