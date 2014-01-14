<cfoutput>
	<div class="page-header clear">		
		<h1>#rc.Form.getName()#</h1>
		<cfif rc.Section.isPersisted()><h2>Edit Section</h2><cfelse><h2>Add Section</h2></cfif>
	</div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('forms')#" class="btn"><i class="icon-arrow-left"></i> Back to Forms</a>
		<cfif rc.Section.isPersisted()><a href="#buildURL( 'formsections.delete' )#/sectionid/#rc.Section.getSectionID()#" title="Delete" class="btn btn-danger"><i class="icon-trash icon-white"></i> Delete</a></cfif>
	</div>

	<div class="clear"></div>

	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'formsections.save' )#" method="post" class="form-horizontal" id="form-section">
		<fieldset>
			<legend>Form Section Information</legend>	
	
			<div class="control-group <cfif rc.result.hasErrors( 'name' )>error</cfif>">
				<label class="control-label" for="name">Name <cfif rc.Validator.propertyIsRequired( "name" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="name" id="name" value="#HtmlEditFormat( rc.Section.getName() )#" maxlength="150" placeholder="Name">
					#view( "helpers/failures", { property="name" })#
				</div>
			</div>
		</fieldset>                        
		
		<div class="form-actions">
			<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
			<input type="submit" name="submit" id="submit" value="Save &amp; exit" class="btn btn-primary">
			<a href="#buildURL( 'forms' )#" class="btn cancel">Cancel</a>
		</div>
		
		<input type="hidden" name="sectionid" id="sectionid" value="#HtmlEditFormat( rc.Section.getSectionID() )#">
		<input type="hidden" name="formid" id="formid" value="#HtmlEditFormat( rc.formid )#">
	</form>
	
	<p>* this field is required</p>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="form-section" )#	
</cfoutput>