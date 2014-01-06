<cfoutput>
	<div class="page-header clear"><cfif rc.Page.isPersisted()><h1>Edit Page</h1><cfelse><h1>Add Page</h1></cfif></div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('pages')#" class="btn"><i class="icon-arrow-left"></i> Back to Pages</a>
		<cfif
			rc.config.page.enableadddelete and
			rc.Page.isPersisted() and
			!rc.Page.hasChild() and
			!ListFind(rc.config.page.suppressdeletepage, rc.Page.getPageID())
			>
			<a href="#buildURL('pages.delete')#/pageid/#rc.Page.getPageID()#" title="Delete" class="btn btn-danger"><i class="icon-trash icon-white"></i> Delete</a>
		</cfif>
	</div>

	<div class="clear"></div>

	#view("helpers/messages")#

	<form action="#buildURL('pages.save')#" method="post" class="form-horizontal" id="page-form">
		<fieldset>
			<legend>Page Content</legend>

			<div class="control-group <cfif rc.result.hasErrors('title')>error</cfif>">
				<label class="control-label" for="title">Title <cfif rc.Validator.propertyIsRequired("title", rc.context)>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="title" id="title" value="#HtmlEditFormat(rc.Page.getTitle())#" maxlength="100" placeholder="Title">
					#view("helpers/failures", {property="title"})#
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors('content')>error</cfif>">
				<label class="control-label" for="page-content">Content <cfif rc.Validator.propertyIsRequired("content", rc.context)>*</cfif></label>
				<div class="controls">
					<textarea class="input-xlarge ckeditor" name="content" id="page-content">#HtmlEditFormat(rc.Page.getContent())#</textarea>
					#view("helpers/failures", {property="content"})#
				</div>
			</div>
		</fieldset>

		<fieldset>
			<legend>Meta Tags</legend>

			<div class="control-group <cfif rc.result.hasErrors('metagenerated')>error</cfif>">
				<label>&nbsp;</label>
				<div class="controls">
					<label class="checkbox">
						<input type="checkbox" name="metagenerated" id="metagenerated" value="true" <cfif rc.Page.getMetaGenerated()>checked="checked"</cfif>>
						Generate automatically <cfif rc.Validator.propertyIsRequired("metagenerated")>*</cfif>
						#view("helpers/failures", {property="metagenerated"})#
					</label>
				</div>
			</div>

			<div class="metatags">
				<div class="control-group <cfif rc.result.hasErrors('metatitle')>error</cfif>">
					<label class="control-label" for="metatitle">Title <cfif rc.Validator.propertyIsRequired("metatitle", rc.context)>*</cfif></label>
					<div class="controls">
						<input class="input-xlarge" type="text" name="metatitle" id="metatitle" value="#HtmlEditFormat(rc.Page.getMetaTitle())#" maxlength="100" placeholder="Meta title">
						#view("helpers/failures", {property="metatitle"})#
					</div>
				</div>

				<div class="control-group <cfif rc.result.hasErrors('metadescription')>error</cfif>">
					<label class="control-label" for="metadescription">Description <cfif rc.Validator.propertyIsRequired("metadescription", rc.context)>*</cfif></label>
					<div class="controls">
						<input class="input-xlarge" type="text" name="metadescription" id="metadescription" value="#HtmlEditFormat(rc.Page.getMetaDescription())#" maxlength="200" placeholder="Meta description">
						#view("helpers/failures", {property="metadescription"})#
					</div>
				</div>

				<div class="control-group <cfif rc.result.hasErrors('metakeywords')>error</cfif>">
					<label class="control-label" for="metakeywords">Keywords <cfif rc.Validator.propertyIsRequired("metakeywords", rc.context)>*</cfif></label>
					<div class="controls">
						<input class="input-xlarge" type="text" name="metakeywords" id="metakeywords" value="#HtmlEditFormat(rc.Page.getMetaKeywords())#" maxlength="200" placeholder="Meta keywords">
						#view("helpers/failures", {property="metakeywords"})#
					</div>
				</div>
			</div>
		</fieldset>

		<div class="form-actions">
			<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
			<input type="submit" name="submit" value="Save &amp; exit" class="btn btn-primary">
			<a href="#buildURL('pages')#" class="btn cancel">Cancel</a>
		</div>

		<input type="hidden" name="pageid" id="pageid" value="#HtmlEditFormat(rc.Page.getPageID())#">
		<cfif StructKeyExists(rc, "ancestorid")><input type="hidden" name="ancestorid" id="ancestorid" value="#HtmlEditFormat(rc.ancestorid)#"></cfif>
		<input type="hidden" name="context" id="context" value="#HtmlEditFormat(rc.context)#">
	</form>

	<p>* this field is required</p>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName="page-form", context=rc.context)#
</cfoutput>
