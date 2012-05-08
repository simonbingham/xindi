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
	<div class="page-header"><h1>Contact Us</h1></div>

	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'enquiry.send' )#" method="post" class="form-horizontal" id="enquiry-form">
		<fieldset>
			<legend>Enquiry Form</legend>	
	
			<div class="control-group">
				<label class="control-label" for="firstname">First Name <cfif rc.Validator.propertyIsRequired( "firstname" )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="firstname" id="firstname" value="#HtmlEditFormat( rc.Enquiry.getFirstName() )#" maxlength="50"></div>
			</div>

			<div class="control-group">
				<label class="control-label" for="lastname">Last Name <cfif rc.Validator.propertyIsRequired( "lastname" )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="lastname" id="lastname" value="#HtmlEditFormat( rc.Enquiry.getLastName() )#" maxlength="50"></div>
			</div>

			<div class="control-group">
				<label class="control-label" for="email">Email Address <cfif rc.Validator.propertyIsRequired( "email" )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="email" id="email" value="#HtmlEditFormat( rc.Enquiry.getEmail() )#" maxlength="150"></div>
			</div>
		
			<div class="control-group">
				<label class="control-label" for="message">Message <cfif rc.Validator.propertyIsRequired( "message" )>*</cfif></label>
				<div class="controls"><textarea class="input-xlarge ckeditor" name="message" id="message">#HtmlEditFormat( rc.Enquiry.getMessage() )#</textarea></div>
			</div>
		</fieldset>                        
		
		<div class="form-actions">
			<input type="submit" name="submit" id="submit" value="Send" class="btn btn-primary">
		</div>
	</form>
	
	<p>* this field is required</p>
	
	<script>
	$(document).ready(function(){
		$.validator.setDefaults({
			errorClass: 'error', 
			errorElement: 'span'
		});
		
		$( "form" ).bind( "submit", function(){
			if( typeof CKEDITOR != "undefined" ){
				for( instance in CKEDITOR.instances ){
					CKEDITOR.instances[ instance ].updateElement();
				}
			}
		});		
	});
	</script>		
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="enquiry-form" )#	
</cfoutput>