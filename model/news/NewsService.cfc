/**
 * I am the news service component.
 */
component accessors = true extends = "model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "MetaData" getter = false;
	property name = "NewsGateway" getter = false;
	property name = "SecurityService" getter = false;
	property name = "Validator" getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete an article
	 */
	struct function deleteArticle(required numeric articleId) {
		transaction{
			local.Article = variables.NewsGateway.getArticle(articleId = Val(arguments.articleId));
			local.result = variables.Validator.newResult();
			if (local.Article.isPersisted()) {
				variables.NewsGateway.deleteArticle(theArticle = local.Article);
				local.result.setSuccessMessage("The article &quot;#local.Article.getTitle()#&quot; has been deleted.");
			} else {
				local.result.setErrorMessage("The article could not be deleted.");
			}
		}
		return local.result;
	}

	/**
	 * I return an article matching an id
	 */
	Article function getArticle(required numeric articleId) {
		return variables.NewsGateway.getArticle(articleId = Val(arguments.articleId));
	}

	/**
	 * I return an article matching a unique id
	 */
	Article function getArticleBySlug(required string slug) {
		return variables.NewsGateway.getArticleBySlug(slug = arguments.slug);
	}

	/**
	 * I return the count of articles
	 */
	numeric function getArticleCount() {
		return variables.NewsGateway.getArticleCount();
	}

	/**
	 * I return an array of articles
	 */
	array function getArticles(string searchTerm = "", string sortOrder = "published desc", boolean published = false, numeric maxresults = 0, numeric offset = 0) {
		local.args = Duplicate(arguments);
		local.args.maxResults = Val(local.args.maxResults);
		local.args.offset = Val(local.args.offset);
		return variables.NewsGateway.getArticles(argumentCollection = local.args);
	}

	/**
	 * I validate and save an article
	 */
	struct function saveArticle(required struct properties, required string websiteTitle) {
		transaction{
			local.args = Duplicate(arguments);
			param name = "local.args.properties.articleId" default = 0;
			param name = "local.args.properties.metaGenerated" default = false;
			local.Article = variables.NewsGateway.getArticle(articleId = Val(local.args.properties.articleId));
			if (local.args.properties.metagenerated) {
				local.args.properties.metatitle = variables.MetaData.generatePageTitle(websiteTitle = local.args.websiteTitle, pageTitle = local.args.properties.title);
				local.args.properties.metadescription = variables.MetaData.generateMetaDescription(content = local.args.properties.content);
				local.args.properties.metakeywords = variables.MetaData.generateMetaKeywords(content = local.args.properties.title);
			}
			local.User = variables.SecurityService.getCurrentUser();
			if (!IsNull(local.User)) {
				local.args.properties.updatedBy = local.User.getName();
			}
			populate(Entity = local.Article, memento = local.args.properties);
			local.result = variables.Validator.validate(theObject = local.Article);
			if (!local.result.hasErrors()) {
				variables.NewsGateway.saveArticle(theArticle = local.Article);
				local.result.setSuccessMessage("The article &quot;#local.Article.getTitle()#&quot; has been saved.");
			} else {
				local.result.setErrorMessage("Your article could not be saved. Please amend the highlighted fields.");
			}
		}
		return local.result;
	}

}
