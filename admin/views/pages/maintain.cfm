<cfoutput>
	<div class="page-header clear"><cfif rc.Page.isPersisted()><h1>Edit Page</h1><cfelse><h1>Add Page</h1></cfif></div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('pages')#" class="btn"><i class="glyphicon glyphicon-arrow-left"></i> Back to Pages</a>
		<cfif
			rc.config.page.enableadddelete and
			rc.Page.isPersisted() and
			!rc.Page.hasChild() and
			!ListFind(rc.config.page.suppressdeletepage, rc.Page.getPageID())
			>
			<a href="#buildURL('pages.delete')#/pageid/#rc.Page.getPageID()#" title="Delete" class="btn btn-danger"><i class="glyphicon glyphicon-trash glyphicon-white"></i> Delete</a>
		</cfif>
	</div>

	<div class="clear"></div>

	#view("partials/messages")#

	<form action="#buildURL('pages.save')#" method="post" class="form-horizontal" id="page-form">
		<fieldset>
			<legend>Page Content</legend>

			<div class="form-group <cfif rc.result.hasErrors('title')>error</cfif>">
				<label for="title">Title <cfif rc.Validator.propertyIsRequired("title", rc.context)>*</cfif></label>
				<input class="form-control" type="text" name="title" id="title" value="#HtmlEditFormat(rc.Page.getTitle())#" maxlength="100" placeholder="Title">
				#view("partials/failures", {property="title"})#
			</div>

			<div class="form-group <cfif rc.result.hasErrors('content')>error</cfif>">
				<label for="page-content">Content <cfif rc.Validator.propertyIsRequired("content", rc.context)>*</cfif></label>
				<textarea class="form-control ckeditor" name="content" id="page-content">#HtmlEditFormat(rc.Page.getContent())#</textarea>
				#view("partials/failures", {property="content"})#
			</div>
		</fieldset>

		<fieldset>
			<legend>Meta Tags</legend>

			<div class="form-group <cfif rc.result.hasErrors('metagenerated')>error</cfif>">
				<label>&nbsp;</label>
				<label class="checkbox">
					<input type="checkbox" name="metagenerated" id="metagenerated" value="true" <cfif rc.Page.getMetaGenerated()>checked="checked"</cfif>>
					Generate automatically <cfif rc.Validator.propertyIsRequired("metagenerated")>*</cfif>
					#view("partials/failures", {property="metagenerated"})#
				</label>
			</div>

			<div class="metatags">
				<div class="form-group <cfif rc.result.hasErrors('metatitle')>error</cfif>">
					<label for="metatitle">Title <cfif rc.Validator.propertyIsRequired("metatitle", rc.context)>*</cfif></label>
					<input class="form-control" type="text" name="metatitle" id="metatitle" value="#HtmlEditFormat(rc.Page.getMetaTitle())#" maxlength="100" placeholder="Meta title">
					#view("partials/failures", {property="metatitle"})#
				</div>

				<div class="form-group <cfif rc.result.hasErrors('metadescription')>error</cfif>">
					<label for="metadescription">Description <cfif rc.Validator.propertyIsRequired("metadescription", rc.context)>*</cfif></label>
					<input class="form-control" type="text" name="metadescription" id="metadescription" value="#HtmlEditFormat(rc.Page.getMetaDescription())#" maxlength="200" placeholder="Meta description">
					#view("partials/failures", {property="metadescription"})#
				</div>

				<div class="form-group <cfif rc.result.hasErrors('metakeywords')>error</cfif>">
					<label for="metakeywords">Keywords <cfif rc.Validator.propertyIsRequired("metakeywords", rc.context)>*</cfif></label>
					<input class="form-control" type="text" name="metakeywords" id="metakeywords" value="#HtmlEditFormat(rc.Page.getMetaKeywords())#" maxlength="200" placeholder="Meta keywords">
					#view("partials/failures", {property="metakeywords"})#
				</div>
			</div>
		</fieldset>

		<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
		<input type="submit" name="submit" value="Save &amp; exit" class="btn btn-primary">
		<a href="#buildURL('pages')#" class="btn cancel">Cancel</a>

		<input type="hidden" name="pageid" id="pageid" value="#HtmlEditFormat(rc.Page.getPageID())#">
		<cfif StructKeyExists(rc, "ancestorid")><input type="hidden" name="ancestorid" id="ancestorid" value="#HtmlEditFormat(rc.ancestorid)#"></cfif>
		<input type="hidden" name="context" id="context" value="#HtmlEditFormat(rc.context)#">
	</form>

	<p>* this field is required</p>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName="page-form", context=rc.context)#
</cfoutput>
