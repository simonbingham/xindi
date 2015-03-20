component accessors = true extends = "abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "ContentService" setter = true getter = false;
	property name = "NewsService" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function map(required struct rc) {
		rc.Page = variables.ContentService.getRoot(); // required for breadcrumb trail
		rc.MetaData.setMetaTitle("Site Map");
		rc.MetaData.setMetaDescription("");
		rc.MetaData.setMetaKeywords("");
	}

	void function xml(required struct rc) {
		rc.sesOmitIndex = variables.fw.getConfig().sesOmitIndex;
		if (rc.config.news.enabled) {
			rc.articles = variables.NewsService.getArticles(published = true);
		}
	}

}
