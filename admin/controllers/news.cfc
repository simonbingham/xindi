component accessors="true" extends="abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="NewsService" setter="true" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		rc.articles = variables.NewsService.getArticles();
	}

	void function delete(required struct rc) {
		param name="rc.articleid" default="0";
		rc.result = variables.NewsService.deleteArticle(rc.articleid);
		variables.fw.redirect("news", "result");
	}

	void function maintain(required struct rc) {
		param name="rc.articleid" default="0";
		if(!StructKeyExists(rc, "Article")) rc.Article = variables.NewsService.getArticle(rc.articleid);
		rc.Validator = variables.NewsService.getValidator(rc.Article);
		if(!StructKeyExists(rc, "result")) rc.result = rc.Validator.newResult();
	}

	void function save(required struct rc) {
		param name="rc.articleid" default="0";
		param name="rc.title" default="";
		param name="rc.published" default="";
		param name="rc.author" default="";
		param name="rc.content" default="";
		param name="rc.metagenerated" default="false";
		param name="rc.metatitle" default="";
		param name="rc.metadescription" default="";
		param name="rc.metakeywords" default="";
		param name="rc.submit" default="Save & exit";
		rc.result = variables.NewsService.saveArticle(rc, rc.config.name);
		rc.Article = rc.result.getTheObject();
		if(rc.result.getIsSuccess()) {
			if(rc.submit == "Save & Continue") variables.fw.redirect("news.maintain", "Article,result", "articleid");
			else variables.fw.redirect("news", "result");
		}else{
			variables.fw.redirect("news.maintain", "Article,result", "articleid");
		}
	}

}
