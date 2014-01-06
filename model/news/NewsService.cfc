component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="MetaData" getter="false";
	property name="NewsGateway" getter="false";
	property name="SecurityService" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete an article
	 */
	struct function deleteArticle(required articleid) {
		transaction{
			var Article = variables.NewsGateway.getArticle(Val(arguments.articleid));
			var result = variables.Validator.newResult();
			if(Article.isPersisted()) {
				variables.NewsGateway.deleteArticle(Article);
				result.setSuccessMessage("The article &quot;#Article.getTitle()#&quot; has been deleted.");
			}else{
				result.setErrorMessage("The article could not be deleted.");
			}
		}
		return result;
	}

	/**
	 * I return an article matching an id
	 */
	Article function getArticle(required articleid) {
		return variables.NewsGateway.getArticle(Val(arguments.articleid));
	}

	/**
	 * I return an article matching a unique id
	 */
	Article function getArticleBySlug(required string slug) {
		return variables.NewsGateway.getArticleBySlug(argumentCollection=arguments);
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
	array function getArticles(string searchterm="", string sortorder="published desc", boolean published=false, maxresults=0, offset=0) {
		arguments.maxresults = Val(arguments.maxresults);
		arguments.offset = Val(arguments.offset);
		return variables.NewsGateway.getArticles(argumentCollection=arguments);
	}

	/**
	 * I validate and save an article
	 */
	struct function saveArticle(required struct properties, required string websitetitle) {
		transaction{
			param name="arguments.properties.articleid" default="0";
			param name="arguments.properties.metagenerated" default="false";
			var Article = variables.NewsGateway.getArticle(Val(arguments.properties.articleid));
			if(arguments.properties.metagenerated) {
				arguments.properties.metatitle = variables.MetaData.generatePageTitle(arguments.websitetitle, arguments.properties.title);
				arguments.properties.metadescription = variables.MetaData.generateMetaDescription(arguments.properties.content);
				arguments.properties.metakeywords = variables.MetaData.generateMetaKeywords(arguments.properties.title);
			}
			var User = variables.SecurityService.getCurrentUser();
			if(!IsNull(User)) arguments.properties.updatedby = User.getName();
			populate(Article, arguments.properties);
			var result = variables.Validator.validate(theObject=Article);
			if(!result.hasErrors()) {
				variables.NewsGateway.saveArticle(Article);
				result.setSuccessMessage("The article &quot;#Article.getTitle()#&quot; has been saved.");
			}else{
				result.setErrorMessage("Your article could not be saved. Please amend the highlighted fields.");
			}
		}
		return result;
	}

}

