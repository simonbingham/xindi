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