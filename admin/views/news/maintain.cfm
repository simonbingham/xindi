<cfoutput>
	<div class="page-header clear">
		<h1>#rc.pageTitle#</h1>
	</div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('news')#" class="btn"><i class="glyphicon glyphicon-arrow-left"></i> Back to Articles</a>
		<cfif rc.Article.isPersisted()>
			<a href="#buildURL('news.delete')#/articleid/#rc.Article.getArticleId()#" title="Delete" class="btn btn-danger"><i class="glyphicon glyphicon-trash glyphicon-white"></i> Delete</a>
		</cfif>
	</div>

	<div class="clear"></div>

	#view("partials/messages")#

	<form action="#buildURL('news.save')#" method="post" class="form-horizontal" id="article-form">
		<fieldset>
			<legend>Article Content</legend>

			<div class="form-group <cfif rc.result.hasErrors('title')>error</cfif>">
				<label for="title">Title <cfif rc.Validator.propertyIsRequired("title")>*</cfif></label>
				<input class="form-control" type="text" name="title" id="title" value="#HtmlEditFormat(rc.Article.getTitle())#" maxlength="100" placeholder="Title">
				#view("partials/failures", {property = "title"})#
			</div>

			<div class="form-group <cfif rc.result.hasErrors('author')>error</cfif>">
				<label for="author">Author <cfif rc.Validator.propertyIsRequired("author")>*</cfif></label>
				<input class="form-control" type="text" name="author" id="author" value="#HtmlEditFormat(rc.Article.getAuthor())#" maxlength="100" placeholder="Author">
				#view("partials/failures", {property = "author"})#
			</div>

			<div class="form-group <cfif rc.result.hasErrors('published')>error</cfif>">
				<label for="published">Date <cfif rc.Validator.propertyIsRequired("published")>*</cfif></label>
				<input class="form-control datepicker" type="text" name="published" id="published" value="<cfif IsDate(rc.Article.getPublished())>#HtmlEditFormat(DateFormat(rc.Article.getPublished(), 'mm/dd/yyyy'))#</cfif>" title="The date the article is to be published" placeholder="Date">
				#view("partials/failures", {property = "published"})#
				<noscript><p class="help-block">Enter in 'mm/dd/yyyy' format.</p></noscript>
			</div>

			<div class="form-group <cfif rc.result.hasErrors('content')>error</cfif>">
				<label for="article-content">Content <cfif rc.Validator.propertyIsRequired("content")>*</cfif></label>
				<textarea class="form-control ckeditor" name="content" id="article-content">#HtmlEditFormat(rc.Article.getContent())#</textarea>
				#view("partials/failures", {property = "content"})#
			</div>
		</fieldset>

		<fieldset>
			<legend>Meta Tags</legend>

			<div class="form-group <cfif rc.result.hasErrors('metaGenerated')>error</cfif>">
				<label>&nbsp;</label>
				<label class="checkbox">
					<input type="checkbox" name="metagenerated" id="metagenerated" value="true" <cfif rc.Article.getMetaGenerated()>checked="checked"</cfif>>
					Generate automatically <cfif rc.Validator.propertyIsRequired("metaGenerated")>*</cfif>
					#view("partials/failures", {property = "metaGenerated"})#
				</label>
			</div>

			<div class="metatags">
				<div class="form-group <cfif rc.result.hasErrors('metaTitle')>error</cfif>">
					<label for="metatitle">Title <cfif rc.Validator.propertyIsRequired("metaTitle")>*</cfif></label>
					<input class="form-control" type="text" name="metatitle" id="metatitle" value="#HtmlEditFormat(rc.Article.getMetaTitle())#" maxlength="100" placeholder="Meta title">
					#view("partials/failures", {property = "metaTitle"})#
				</div>

				<div class="form-group <cfif rc.result.hasErrors('metaDescription')>error</cfif>">
					<label for="metadescription">Description <cfif rc.Validator.propertyIsRequired("metaDescription")>*</cfif></label>
					<input class="form-control" type="text" name="metadescription" id="metadescription" value="#HtmlEditFormat(rc.Article.getMetaDescription())#" maxlength="200" placeholder="Meta description">
					#view("partials/failures", {property = "metaDescription"})#
				</div>

				<div class="form-group <cfif rc.result.hasErrors('metaKeywords')>error</cfif>">
					<label for="metakeywords">Keywords <cfif rc.Validator.propertyIsRequired("metaKeywords")>*</cfif></label>
					<input class="form-control" type="text" name="metakeywords" id="metakeywords" value="#HtmlEditFormat(rc.Article.getMetaKeywords())#" maxlength="200" placeholder="Meta keywords">
					#view("partials/failures", {property = "metaKeywords"})#
				</div>
			</div>
		</fieldset>

		<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
		<input type="submit" name="submit" id="submit" value="Save &amp; exit" class="btn btn-primary">
		<a href="#buildURL('news')#" class="btn cancel">Cancel</a>

		<input type="hidden" name="articleid" id="articleid" value="#HtmlEditFormat(rc.Article.getArticleId())#">
	</form>

	<p>* this field is required</p>

	<script>
		jQuery(function($){
			$(".datepicker").datepicker();
		});
	</script>

	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript(formName = "article-form")#
</cfoutput>
