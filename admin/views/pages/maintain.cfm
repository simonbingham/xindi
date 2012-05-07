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
	<div class="page-header"><cfif rc.Page.isPersisted()><h1>Edit Page</h1><cfelse><h1>Add Page</h1></cfif></div>

	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'pages.save' )#" method="post" class="form-horizontal" id="page-form">
		<fieldset>
			<legend>Page Content</legend>	
	
			<div class="control-group">
				<label class="control-label" for="title">Title <cfif rc.Validator.propertyIsRequired( "title", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="title" id="title" value="#HtmlEditFormat( rc.Page.getTitle() )#" maxlength="100"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="navigationtitle">Navigation Title <cfif rc.Validator.propertyIsRequired( "navigationtitle", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="navigationtitle" id="navigationtitle" value="#HtmlEditFormat( rc.Page.getNavigationTitle() )#" maxlength="100"></div>
			</div>			
		
			<div class="control-group">
				<label class="control-label" for="page-content">Content <cfif rc.Validator.propertyIsRequired( "content", rc.context )>*</cfif></label>
				<div class="controls"><textarea class="input-xlarge ckeditor" name="content" id="page-content">#HtmlEditFormat( rc.Page.getContent() )#</textarea></div>
			</div>
		</fieldset>                        

		<fieldset>
			<legend>Meta Tags</legend>		
		
	    	<div class="alert alert-info">If you leave these fields empty the meta tags will be generated automatically.</div>		
		
			<div class="control-group">
				<label class="control-label" for="metatitle">Title <cfif rc.Validator.propertyIsRequired( "metatitle", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="metatitle" id="metatitle" value="#HtmlEditFormat( rc.Page.getMetaTitle() )#" maxlength="100"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="metadescription">Description <cfif rc.Validator.propertyIsRequired( "metadescription", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="metadescription" id="metadescription" value="#HtmlEditFormat( rc.Page.getMetaDescription() )#" maxlength="200"></div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="metakeywords">Keywords <cfif rc.Validator.propertyIsRequired( "metakeywords", rc.context )>*</cfif></label>
				<div class="controls"><input class="input-xlarge" type="text" name="metakeywords" id="metakeywords" value="#HtmlEditFormat( rc.Page.getMetaKeywords() )#" maxlength="200"></div>
			</div>
		</fieldset>
		
		<div class="form-actions">
			<input type="submit" name="submit" id="submit" value="Save Page" class="btn btn-primary">
		</div>
		
		<input type="hidden" name="pageid" id="pageid" value="#HtmlEditFormat( rc.Page.getPageID() )#">
		<cfif StructKeyExists( rc, "ancestorid" )><input type="hidden" name="ancestorid" id="ancestorid" value="#HtmlEditFormat( rc.ancestorid )#"></cfif>
		<input type="hidden" name="context" id="context" value="#HtmlEditFormat( rc.context )#">			
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

	#rc.Validator.getValidationScript( formName="page-form", context=rc.context )#	
</cfoutput>