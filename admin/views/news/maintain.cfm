<cfoutput>
	<div class="page-header clear"><cfif rc.Article.isPersisted()><h1>Edit Article</h1><cfelse><h1>Add Article</h1></cfif></div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('news')#" class="btn"><i class="icon-arrow-left"></i> Back to Articles</a>
		<cfif rc.Article.isPersisted()><a href="#buildURL('news.delete')#/articleid/#rc.Article.getArticleID()#" title="Delete" class="btn btn-danger"><i class="icon-trash icon-white"></i> Delete</a></cfif>
	</div>

	<div class="clear"></div>

	#view("helpers/messages")#

	<form action="#buildURL('news.save')#" method="post" class="form-horizontal" id="article-form">
		<fieldset>
			<legend>Article Content</legend>

			<div class="control-group <cfif rc.result.hasErrors('title')>error</cfif>">
				<label class="control-label" for="title">Title <cfif rc.Validator.propertyIsRequired("title")>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="title" id="title" value="#HtmlEditFormat(rc.Article.getTitle())#" maxlength="100" placeholder="Title">
					#view("helpers/failures", {property="title"})#
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors('author')>error</cfif>">
				<label class="control-label" for="author">Author <cfif rc.Validator.propertyIsRequired("author")>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="author" id="author" value="#HtmlEditFormat(rc.Article.getAuthor())#" maxlength="100" placeholder="Author">
					#view("helpers/failures", {property="author"})#
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors('published')>error</cfif>">
				<label class="control-label" for="published">Date <cfif rc.Validator.propertyIsRequired("published")>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge datepicker" type="text" name="published" id="published" value="<cfif IsDate(rc.Article.getPublished())>#HtmlEditFormat(DateFormat(rc.Article.getPublished(), 'mm/dd/yyyy'))#</cfif>" title="The date the article is to be published" placeholder="Date">
					#view("helpers/failures", {property="published"})#
					<noscript><p class="help-block">Enter in 'mm/dd/yyyy' format.</p></noscript>
				</div>
			</div>

			<div class="control-group <cfif rc.result.hasErrors('content')>error</cfif>">
				<label class="control-label" for="article-content">Content <cfif rc.Validator.propertyIsRequired("content")>*</cfif></label>
				<div class="controls">
					<textarea class="input-xlarge ckeditor" name="content" id="article-content">#HtmlEditFormat(rc.Article.getContent())#</textarea>
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
						<input type="checkbox" name="metagenerated" id="metagenerated" value="true" <cfif rc.Article.getMetaGenerated()>checked="checked"</cfif>>
						Generate automatically <cfif rc.Validator.propertyIsRequired("metagenerated")>*</cfif>
						#view("helpers/failures", {property="metagenerated"})#
					</label>
				</div>
			</div>

			<div class="metatags">
				<div class="control-group <cfif rc.result.hasErrors('metatitle')>error</cfif>">
					<label class="control-label" for="metatitle">Title <cfif rc.Validator.propertyIsRequired("metatitle")>*</cfif></label>
					<div class="controls">
						<input class="input-xlarge" type="text" name="metatitle" id="metatitle" value="#HtmlEditFormat(rc.Article.getMetaTitle())#" maxlength="100" placeholder="Meta title">
						#view("helpers/failures", {property="metatitle"})#
					</div>
				</div>

				<div class="control-group <cfif rc.result.hasErrors('metadescription')>error</cfif>">
					<label class="control-label" for="metadescription">Description <cfif rc.Validator.propertyIsRequired("metadescription")>*</cfif></label>
					<div class="controls">
						<input class="input-xlarge" type="text" name="metadescription" id="metadescription" value="#HtmlEditFormat(rc.Article.getMetaDescription())#" maxlength="200" placeholder="Meta description">
						#view("helpers/failures", {property="metadescription"})#
					</div>
				</div>

				<div class="control-group <cfif rc.result.hasErrors('metakeywords')>error</cfif>">
					<label class="control-label" for="metakeywords">Keywords <cfif rc.Validator.propertyIsRequired("metakeywords")>*</cfif></label>
					<div class="controls">
						<input class="input-xlarge" type="text" name="metakeywords" id="metakeywords" value="#HtmlEditFormat(rc.Article.getMetaKeywords())#" maxlength="200" placeholder="Meta keywords">
						#view("helpers/failures", {property="metakeywords"})#
					</div>
				</div>
			</div>
		</fieldset>

		<div class="form-actions">
			<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
			<input type="submit" name="submit" id="submit" value="Save &amp; exit" class="btn btn-primary">
			<a href="#buildURL('news')#" class="btn cancel">Cancel</a>
		</div>

		<input type="hidden" name="articleid" id="articleid" value="#HtmlEditFormat(rc.Article.getArticleID())#">
	</form>

	<p>* this field is required</p>

	<script>
	jQuery(function($){
		$(".datepicker").datepicker();
	});
	</script>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName="article-form")#
</cfoutput>
