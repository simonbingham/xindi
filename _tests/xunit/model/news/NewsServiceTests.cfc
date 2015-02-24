component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.newsGatewayObj = variables.mockbox.createEmptyMock("model.news.NewsGateway");
		variables.mocked.metaDataObj = variables.mockbox.createEmptyMock("model.content.MetaData");
		variables.mocked.securityServiceObj = variables.mockbox.createEmptyMock("model.security.SecurityService");
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("ValidateThis.core.ValidationFactory");
	}

	function setup() {
		super.setup("model.news.NewsService");

		variables.CUT
			.$property(propertyName = "NewsGateway", propertyScope = "variables", mock = variables.mocked.newsGatewayObj)
			.$property(propertyName = "MetaData", propertyScope = "variables", mock = variables.mocked.metaDataObj)
			.$property(propertyName = "SecurityService", propertyScope = "variables", mock = variables.mocked.securityServiceObj)
			.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	function test_deleteArticle_deletes_article_if_it_is_persisted() {
		setupDeleteArticleTests();
		variables.mocked.articleObj.$("isPersisted", TRUE);
		variables.CUT.deleteArticle(articleid = 111);
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("deleteArticle"));
	}

	function test_deleteArticle_does_not_delete_article_if_it_is_not_persisted() {
		setupDeleteArticleTests();
		variables.mocked.articleObj.$("isPersisted", FALSE);
		variables.CUT.deleteArticle(articleid = 111);
		$assert.isTrue(variables.mocked.newsGatewayObj.$never("deleteArticle"));
	}

	function test_getArticle_returns_an_article() {
		variables.mocked.articleObj = variables.mockbox.createEmptyMock("model.news.Article");
		variables.mocked.newsGatewayObj.$("getArticle", variables.mocked.articleObj, FALSE);
		local.actual = variables.CUT.getArticle(articleid = 111);
		$assert.instanceOf(local.actual, "model.news.Article");
	}

	function test_getArticleBySlug_calls_getArticleBySlug_gateway_method() {
		variables.mocked.articleObj = variables.mockbox.createEmptyMock("model.news.Article");
		variables.mocked.newsGatewayObj.$("getArticleBySlug", variables.mocked.articleObj, FALSE);
		local.actual = variables.CUT.getArticleBySlug(slug = "the slug");
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("getArticleBySlug"));
	}

	function test_getArticleCount_calls_getArticleCount_gateway_method() {
		variables.mocked.newsGatewayObj.$("getArticleCount", 111);
		local.actual = variables.CUT.getArticleCount();
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("getArticleCount"));
	}

	function test_getArticles_calls_getArticles_gateway_method() {
		variables.mocked.newsGatewayObj.$("getArticles", []);
		local.actual = variables.CUT.getArticles();
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("getArticles"));
	}

	function test_saveArticle_generates_meta_tags_when_metaGenerated_property_is_true() {
		setupSaveArticleTests();
		local.properties = {metaGenerated = TRUE, title = "", content = "", metaTitle = ""};
		variables.CUT.saveArticle(properties = local.properties, websiteTitle = "");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generatePageTitle"), "Expected generatePageTitle to be called once.");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generateMetaDescription"), "Expected generateMetaDescription to be called once.");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generateMetaKeywords"), "Expected generateMetaKeywords to be called once.");
	}

	function test_saveArticle_sets_success_message_when_no_validation_errors_exist() {
		setupSaveArticleTests();
		variables.mocked.resultObj.$("hasErrors", FALSE);
		local.properties = {title = "", content = "", metaTitle = ""};
		variables.CUT.saveArticle(properties = local.properties, websiteTitle = "");
		$assert.isTrue(variables.mocked.resultObj.$once("setSuccessMessage"));
	}

	function test_saveArticle_sets_error_message_when_validation_errors_exist() {
		setupSaveArticleTests();
		variables.mocked.resultObj.$("hasErrors", TRUE);
		local.properties = {title = "", content = "", metaTitle = ""};
		variables.CUT.saveArticle(properties = local.properties, websiteTitle = "");
		$assert.isTrue(variables.mocked.resultObj.$once("setErrorMessage"));
	}

	// Helper Methods

	private function setupDeleteArticleTests() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.mocked.articleObj = variables.mockbox.createEmptyMock("model.news.Article").$("getTitle", "the article title");
		variables.mocked.newsGatewayObj
			.$("getArticle", variables.mocked.articleObj, FALSE)
			.$("deleteArticle");
	}

	private function setupSaveArticleTests() {
		variables.mocked.articleObj = variables.mockbox.createEmptyMock("model.news.Article").$("getTitle");
		variables.mocked.newsGatewayObj
			.$("getArticle", variables.mocked.articleObj, FALSE)
			.$("saveArticle", variables.mocked.articleObj, FALSE);
		variables.mocked.metaDataObj
			.$("generatePageTitle")
			.$("generateMetaDescription")
			.$("generateMetaKeywords");
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User").$("getName");
		variables.mocked.securityServiceObj.$("getCurrentUser");
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("hasErrors", FALSE)
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
		variables.CUT.$("populate");
	}

}
