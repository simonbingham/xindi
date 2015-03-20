<cfoutput>
	<ul class="breadcrumb">
		<li><a href="#rc.baseHref#">Home</a></li>
		<li class="active">Contact</li>
	</ul>

	<h1>Contact</h1>

	#view("partials/messages")#

	<form action="#buildURL('enquiry.send')#" method="post" id="enquiry-form">
		<fieldset>
			<div class="form-group <cfif rc.result.hasErrors('name')>error</cfif>">
				<label for="name">Name <cfif rc.Validator.propertyIsRequired("name")>*</cfif></label>
				<input class="form-control" type="text" name="name" id="name" value="#HtmlEditFormat(rc.Enquiry.getName())#" maxlength="50">
				#view("partials/failures", {property = "name"})#
			</div>

			<div class="form-group <cfif rc.result.hasErrors('email')>error</cfif>">
				<label for="email">Email Address <cfif rc.Validator.propertyIsRequired("email")>*</cfif></label>
				<input class="form-control" type="text" name="email" id="email" value="#HtmlEditFormat(rc.Enquiry.getEmail())#" maxlength="150">
			</div>

			<div class="form-group <cfif rc.result.hasErrors('message')>error</cfif>">
				<label for="message">Message <cfif rc.Validator.propertyIsRequired("message")>*</cfif></label>
				<textarea class="form-control" name="message" id="message">#HtmlEditFormat(rc.Enquiry.getMessage())#</textarea>
				#view("partials/failures", {property = "message"})#
			</div>
		</fieldset>

		<input type="submit" name="submit" id="submit" value="Send" class="btn btn-primary">
	</form>

	<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
	<script>
		jQuery(function($){
			$.validator.setDefaults({
				errorElement: "span",
				errorClass: "error",
				validClass: "success",
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

	#rc.Validator.getValidationScript(formName = "enquiry-form")#
</cfoutput>
