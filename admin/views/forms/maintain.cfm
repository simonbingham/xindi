<cfoutput>
	<div class="page-header clear"><cfif rc.Form.isPersisted()><h1>Edit Form</h1><cfelse><h1>Add Form</h1></cfif></div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('forms')#" class="btn"><i class="icon-arrow-left"></i> Back to Forms</a>
		<cfif rc.Form.isPersisted()><a href="#buildURL( 'forms.delete' )#/formid/#rc.Form.getFormID()#" title="Delete" class="btn btn-danger"><i class="icon-trash icon-white"></i> Delete</a></cfif>
	</div>

	<div class="clear"></div>

	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'forms.save' )#" method="post" class="form-horizontal" id="form-form">
		<fieldset>
			<legend>Form Information</legend>	
	
			<div class="control-group <cfif rc.result.hasErrors( 'name' )>error</cfif>">
				<label class="control-label" for="name">Name <cfif rc.Validator.propertyIsRequired( "name" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="name" id="name" value="#HtmlEditFormat( rc.Form.getName() )#" maxlength="150" placeholder="Name">
					#view( "helpers/failures", { property="name" })#
					<p class="text-info">Used for navigation and menus</p>
				</div>
			</div>
			
			<div class="control-group <cfif rc.result.hasErrors( 'longname' )>error</cfif>">
				<label class="control-label" for="name">Long Name <cfif rc.Validator.propertyIsRequired( "longname" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="longname" id="longname" value="#HtmlEditFormat( rc.Form.getLongName() )#" maxlength="250" placeholder="Long Name">
					#view( "helpers/failures", { property="longname" })#
					<p class="text-info">Full form name displayed as the title </p>
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors( 'ispublished' )>error</cfif>">
				<label class="control-label" for="ispublished">Published <cfif rc.Validator.propertyIsRequired( "ispublished" )>*</cfif></label>
				<div class="controls">
					<div class="btn-group" data-input="ispublished" data-toggle="buttons-radio" >
					  <button type="button" value="0" class="btn" data-toggle="button">No</button>
					  <button type="button" value="1" class="btn" data-toggle="button">Yes</button>
					  <input type="hidden" name="ispublished" value="#rc.Form.isPublishedVal()#" />
					</div>
					  #view( "helpers/failures", { property="ispublished" })#
					  <p class="text-info">Sets whether to make the form visible to visitors</p>
				</div>
			</div>
			
			<div class="control-group <cfif rc.result.hasErrors( 'instructions' )>error</cfif>">
				<label class="control-label" for="form-content">Instructions <cfif rc.Validator.propertyIsRequired( "instructions" )>*</cfif></label>
				<div class="controls">
					<textarea class="input ckeditor" name="instructions" id="form-instructions">#HtmlEditFormat( rc.Form.getInstructions() )#</textarea>
					#view( "helpers/failures", { property="instructions" })#
					<p class="text-info"> &nbsp;Form instructions to display at the start of the form (max 4000 chars)</p>
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors( 'submitmessage' )>error</cfif>">
				<label class="control-label" for="form-content">Submit Message <cfif rc.Validator.propertyIsRequired( "submitmessage" )>*</cfif></label>
				<div class="controls">
					<textarea class="input ckeditor" name="submitmessage" id="form-submitmessage">#HtmlEditFormat( rc.Form.getSubmitMessage() )#</textarea>
					#view( "helpers/failures", { property="submitmessage" })#
					<p class="text-info"> &nbsp;Message to display to users after submitting the form (max 4000 chars)</p>
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors( 'sendemail' )>error</cfif>">
				<label class="control-label" for="sendemail">Send Email? <cfif rc.Validator.propertyIsRequired( "sendemail" )>*</cfif></label>
				<div class="controls">
					<div class="btn-group" data-input="sendemail" data-toggle="buttons-radio" >
					  <button type="button" value="0" class="btn" data-toggle="button">No</button>
					  <button type="button" value="1" class="btn" data-toggle="button">Yes</button>
					  <input type="hidden" name="sendemail" value="#rc.Form.sendEmailVal()#" />
					</div>
					  #view( "helpers/failures", { property="sendemail" })#
					  <p class="text-info">For the Form Submissions</p>
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors( 'emailto' )>error</cfif>">
				<label class="control-label" for="name">Send Email(s) To <cfif rc.Validator.propertyIsRequired( "emailto" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="emailto" id="emailto" value="#HtmlEditFormat( rc.Form.getEmailTo() )#" maxlength="250" placeholder="Enter Email Addreess(es)">
					#view( "helpers/failures", { property="emailto" })#
					<p class="text-info">For the Form Submissions</p>
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors( 'css_id' )>error</cfif>">
				<label class="control-label" for="name">Form CSS ID <cfif rc.Validator.propertyIsRequired( "css_id" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="css_id" id="css_id" value="#HtmlEditFormat( rc.Form.getCSS_ID() )#" maxlength="150" placeholder="CSS ID">
					#view( "helpers/failures", { property="css_id" })#
					<p class="text-info">(For Designers)</p>
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors( 'css_class' )>error</cfif>">
				<label class="control-label" for="name">Form CSS Class <cfif rc.Validator.propertyIsRequired( "css_class" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="css_class" id="css_class" value="#HtmlEditFormat( rc.Form.getCSS_Class() )#" maxlength="150" placeholder="CSS Class">
					#view( "helpers/failures", { property="css_class" })#
					<p class="text-info">(For Designers)</p>
				</div>
			</div>
		</fieldset>                        
		
		<div class="form-actions">
			<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
			<input type="submit" name="submit" id="submit" value="Save &amp; exit" class="btn btn-primary">
			<a href="#buildURL( 'forms' )#" class="btn cancel">Cancel</a>
		</div>
		
		<input type="hidden" name="formid" id="formid" value="#HtmlEditFormat( rc.Form.getFormID() )#">
	</form>
	
	<p>* this field is required</p>
	
	<script type="text/javascript">
		CKEDITOR.replace( 'instructions', {
		    height: 150
		});
		CKEDITOR.replace( 'submitmessage', {
		    height: 100
		});
			 
		//handles the on/off switches
		jQuery(function($){	
			$('.btn-group[data-input]').each(function() {
				var hidden = $('[name="' + $(this).data('input') + '"]');
				$(this).on('click', '.btn', function() {
					hidden.val($(this).val());
				}).find('.btn').each(function() {
					$(this).toggleClass('active', $(this).val() == hidden.val())
				});
			});
		});
	</script>		
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="form-form" )#	
</cfoutput>