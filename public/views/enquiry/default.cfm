<cfoutput>
	<ul class="breadcrumb">
		<li><a href="#rc.basehref#">Home</a> <span class="divider">/</span></li>
		<li class="active">Contact</li>
	</ul>

	<h1>Contact</h1>

	#view("helpers/messages")#

	<form action="#buildURL('enquiry.send')#" method="post" class="form-horizontal" id="enquiry-form">
		<fieldset>
			<div class="control-group <cfif rc.result.hasErrors('name')>error</cfif>">
				<label class="control-label" for="name">Name <cfif rc.Validator.propertyIsRequired("name")>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="name" id="name" value="#HtmlEditFormat(rc.Enquiry.getName())#" maxlength="50" placeholder="Name">
					#view("helpers/failures", {property="name"})#
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors('email')>error</cfif>">
				<label class="control-label" for="email">Email Address <cfif rc.Validator.propertyIsRequired("email")>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="email" id="email" value="#HtmlEditFormat(rc.Enquiry.getEmail())#" maxlength="150" placeholder="Email Address">
					#view("helpers/failures", {property="email"})#
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors('message')>error</cfif>">
				<label class="control-label" for="message">Message <cfif rc.Validator.propertyIsRequired("message")>*</cfif></label>
				<div class="controls">
					<textarea class="input-xlarge" name="message" id="message" placeholder="Message">#HtmlEditFormat(rc.Enquiry.getMessage())#</textarea>
					#view("helpers/failures", {property="message"})#
				</div>
			</div>
		</fieldset>

		<div class="form-actions">
			<input type="submit" name="submit" id="submit" value="Send" class="btn btn-primary">
		</div>
	</form>

	<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
	<script>
	jQuery(function($){
		$.validator.setDefaults({
			errorElement: 'span',
			errorClass: 'error',
			validClass: 'success',
			success: function(element){
				$(element).parent().parent().addClass("success").removeClass("error");
			},
			highlight: function(element){
				$(element).parent().parent().addClass("error").removeClass("success");
			}
		});
	});
	</script>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName="enquiry-form")#
</cfoutput>
