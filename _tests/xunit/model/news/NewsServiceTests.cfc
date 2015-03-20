component extends = "tests.xunit.BaseTest" {

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

	// deleteArticle() tests

	private struct function getMocksForDeleteArticleTests() {
		local.mocked = {};
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.mocked.articleObj = variables.mockbox.createEmptyMock("model.news.Article")
			.$("getTitle", "the article title")
			.$("isPersisted", TRUE);
		variables.mocked.newsGatewayObj
			.$("getArticle", variables.mocked.articleObj, FALSE)
			.$("deleteArticle");
		return local.mocked;
	}

	function test_deleteArticle_deletes_article_if_it_is_persisted() {
		local.mocked = getMocksForDeleteArticleTests();
		variables.CUT.deleteArticle(articleid = 111);
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("deleteArticle"));
	}

	function test_deleteArticle_does_not_delete_article_if_it_is_not_persisted() {
		local.mocked = getMocksForDeleteArticleTests();
		variables.mocked.articleObj.$("isPersisted", FALSE);
		variables.CUT.deleteArticle(articleid = 111);
		$assert.isTrue(variables.mocked.newsGatewayObj.$never("deleteArticle"));
	}

	// getArticle() tests

	private struct function getMocksForGetArticleTests() {
		local.mocked = {};
		variables.mocked.articleObj = variables.mockbox.createEmptyMock("model.news.Article");
		variables.mocked.newsGatewayObj.$("getArticle", variables.mocked.articleObj, FALSE);
		return local.mocked;
	}

	function test_getArticle_returns_an_article() {
		local.mocked = getMocksForGetArticleTests();
		local.actual = variables.CUT.getArticle(articleid = 111);
		$assert.instanceOf(local.actual, "model.news.Article");
	}

	// getArticleBySlug() tests

	private struct function getMocksForGetArticleBySlugTests() {
		local.mocked = {};
		variables.mocked.articleObj = variables.mockbox.createEmptyMock("model.news.Article");
		variables.mocked.newsGatewayObj.$("getArticleBySlug", variables.mocked.articleObj, FALSE);
		return local.mocked;
	}

	function test_getArticleBySlug_calls_getArticleBySlug_gateway_method() {
		local.mocked = getMocksForGetArticleBySlugTests();
		local.actual = variables.CUT.getArticleBySlug(slug = "the slug");
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("getArticleBySlug"));
	}

	// getArticleCount() tests

	private struct function getMocksForGetArticleCountTests() {
		local.mocked = {};
		variables.mocked.newsGatewayObj.$("getArticleCount", 111);
		return local.mocked;
	}

	function test_getArticleCount_calls_getArticleCount_gateway_method() {
		local.mocked = getMocksForGetArticleCountTests();
		local.actual = variables.CUT.getArticleCount();
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("getArticleCount"));
	}

	// getArticles() tests

	private struct function getMocksForGetArticlesTests() {
		local.mocked = {};
		variables.mocked.newsGatewayObj.$("getArticles", []);
		return local.mocked;
	}

	function test_getArticles_calls_getArticles_gateway_method() {
		local.mocked = getMocksForGetArticlesTests();
		local.actual = variables.CUT.getArticles();
		$assert.isTrue(variables.mocked.newsGatewayObj.$once("getArticles"));
	}

	// saveArticle() tests

	private struct function getMocksForSaveArticleTests() {
		local.mocked = {};
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
		return local.mocked;
	}

	function test_saveArticle_generates_meta_tags_when_metaGenerated_property_is_true() {
		local.mocked = getMocksForSaveArticleTests();
		local.properties = {metaGenerated = TRUE, title = "", content = "", metaTitle = ""};
		variables.CUT.saveArticle(properties = local.properties, websiteTitle = "");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generatePageTitle"), "Expected generatePageTitle to be called once.");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generateMetaDescription"), "Expected generateMetaDescription to be called once.");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generateMetaKeywords"), "Expected generateMetaKeywords to be called once.");
	}

	function test_saveArticle_sets_success_message_when_no_validation_errors_exist() {
		local.mocked = getMocksForSaveArticleTests();
		local.properties = {title = "", content = "", metaTitle = ""};
		variables.CUT.saveArticle(properties = local.properties, websiteTitle = "");
		$assert.isTrue(variables.mocked.resultObj.$once("setSuccessMessage"));
	}

	function test_saveArticle_sets_error_message_when_validation_errors_exist() {
		local.mocked = getMocksForSaveArticleTests();
		variables.mocked.resultObj.$("hasErrors", TRUE);
		local.properties = {title = "", content = "", metaTitle = ""};
		variables.CUT.saveArticle(properties = local.properties, websiteTitle = "");
		$assert.isTrue(variables.mocked.resultObj.$once("setErrorMessage"));
	}

}
