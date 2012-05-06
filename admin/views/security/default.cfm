<!---
	Xindi - http://www.getxindi.com/
	
	Copyright (c) 2012, Simon Bingham
	
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