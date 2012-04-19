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
	<cfif rc.Page.isPersisted()><h1>Edit Page</h1><cfelse><h1>Add Page</h1></cfif>

	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'pages.save' )#" method="post" class="form-horizontal" id="page-form">
		<fieldset>
			<legend>Page Content</legend>	
	
			<div class="control-group">
				<label class="control-label" for="title">Title <cfif rc.Validator.propertyIsRequired( "title" )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="title" id="title" value="#HtmlEditFormat( rc.Page.getTitle() )#" maxlength="100"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="navigationtitle">Navigation Title <cfif rc.Validator.propertyIsRequired( "navigationtitle" )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="navigationtitle" id="navigationtitle" value="#HtmlEditFormat( rc.Page.getNavigationTitle() )#" maxlength="100"></div>
			</div>			
			
			<div class="control-group">
				<label class="control-label" for="page-content">Content <cfif rc.Validator.propertyIsRequired( "content" )>*</cfif></label>
				<div class="controls"><textarea class="input-xlarge" name="content" id="page-content">#HtmlEditFormat( rc.Page.getContent() )#</textarea></div>
			</div>
		</fieldset>                        

		<fieldset>
			<legend>Meta Tags</legend>		
		
			<p>If left blank the meta tags will be generated automatically.</p>
	
			<div class="control-group">
				<label class="control-label" for="metaTitle">Meta Title</label>
				<div class="controls"><input class="input-xlarge" type="text" name="metatitle" id="metatitle" value="#HtmlEditFormat( rc.Page.getMetaTitle() )#" maxlength="100"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="metaDescription">Meta Description</label>
				<div class="controls"><input class="input-xlarge" type="text" name="metadescription" id="metadescription" value="#HtmlEditFormat( rc.Page.getMetaDescription() )#" maxlength="200"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="metaKeywords">Meta Keywords</label>
				<div class="controls"><input class="input-xlarge" type="text" name="metakeywords" id="metakeywords" value="#HtmlEditFormat( rc.Page.getMetaKeywords() )#" maxlength="200"></div>
			</div>
		</fieldset>
		
		<div class="form-actions">
			<input type="submit" name="submit" id="submit" value="Save Page" class="btn btn-primary">
		</div>
		
		<input type="hidden" name="pageid" id="pageid" value="#HtmlEditFormat( rc.Page.getPageID() )#">
		<cfif StructKeyExists( rc, "ancestorid" )><input type="hidden" name="ancestorid" id="ancestorid" value="#HtmlEditFormat( rc.ancestorid )#"></cfif>		
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

	#rc.Validator.getValidationScript( formName="page-form" )#	
</cfoutput>