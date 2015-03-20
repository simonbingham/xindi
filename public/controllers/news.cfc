component accessors = true extends = "abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "NewsService" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function article(required struct rc) {
		param name = "rc.slug" default = "";
		rc.Article = variables.NewsService.getArticleBySlug(slug = rc.slug);
		if (rc.Article.isPersisted()) {
			rc.MetaData.setMetaTitle(rc.Article.getMetaTitle());
			rc.MetaData.setMetaDescription(rc.Article.getMetaDescription());
			rc.MetaData.setMetaKeywords(rc.Article.getMetaKeywords());
			rc.MetaData.setMetaAuthor(rc.Article.getAuthor());
		} else {
			variables.fw.redirect("main.notfound");
		}
	}

	void function default(required struct rc) {
		param name = "rc.maxResults" default = rc.config.news.recordsPerPage;
		param name = "rc.offset" default = 0;
		rc.articles = variables.NewsService.getArticles(published = true, maxResults = Val(rc.maxResults), offset = Val(rc.offset));
		rc.articlecount = variables.NewsService.getArticleCount();
		rc.MetaData.setMetaTitle("News");
		rc.MetaData.setMetaDescription("");
		rc.MetaData.setMetaKeywords("");
	}

	void function rss(required struct rc) {
		rc.articles = variables.NewsService.getArticles(published = true);
	}

}
