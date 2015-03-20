component accessors = true extends = "abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "NewsService" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		rc.articles = variables.NewsService.getArticles();
	}

	void function delete(required struct rc) {
		param name = "rc.articleId" default = 0;
		rc.result = variables.NewsService.deleteArticle(articleId = Val(rc.articleId));
		variables.fw.redirect("news", "result");
	}

	void function maintain(required struct rc) {
		param name = "rc.articleId" default = 0;
		if (!StructKeyExists(rc, "Article")) {
			rc.Article = variables.NewsService.getArticle(articleId = Val(rc.articleId));
		}
		rc.Validator = variables.NewsService.getValidator(Entity = rc.Article);
		if (!StructKeyExists(rc, "result")) {
			rc.result = rc.Validator.newResult();
		}
		rc.pageTitle = rc.Article.isPersisted() ? "Edit Article" : "Add Article";
	}

	void function save(required struct rc) {
		param name = "rc.articleId" default = 0;
		param name = "rc.title" default = "";
		param name = "rc.published" default = "";
		param name = "rc.author" default = "";
		param name = "rc.content" default = "";
		param name = "rc.metaGenerated" default = false;
		param name = "rc.metaTitle" default = "";
		param name = "rc.metaDescription" default = "";
		param name = "rc.metaKeywords" default = "";
		param name = "rc.submit" default = "Save & exit";
		rc.result = variables.NewsService.saveArticle(properties = rc, websiteTitle = rc.config.name);
		rc.Article = rc.result.getTheObject();
		if (rc.result.getIsSuccess()) {
			if (rc.submit == "Save & Continue") {
				variables.fw.redirect("news.maintain", "Article,result", "articleId");
			} else {
				variables.fw.redirect("news", "result");
			}
		} else {
			variables.fw.redirect("news.maintain", "Article,result", "articleId");
		}
	}

}
