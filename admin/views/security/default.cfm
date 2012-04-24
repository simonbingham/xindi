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
	<div class="page-header hide"><h1>Login</h1></div>

	<form action="#buildURL( 'security/login' )#" method="post" class="form-horizontal" id="login-form">
	    <fieldset>
	        <legend>Login Form</legend>
			
			#view( "helpers/messages" )#
			
			<div class="control-group">
				<label class="control-label" for="username">Username</label>
				<div class="controls"><input class="input-xlarge" type="text" name="username" id="username"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="password">Password</label>
				<div class="controls"><input class="input-xlarge" type="password" name="password" id="password"></div>
			</div>
			
			<div class="form-actions">
				<input type="submit" name="login" id="login" value="Login" class="btn btn-primary">
			</div>
		</fieldset>
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

	#rc.Validator.getValidationScript( formName="login-form", context="login" )#
</cfoutput>