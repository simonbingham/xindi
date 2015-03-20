component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.contentGatewayObj = variables.mockbox.createEmptyMock("model.content.ContentGateway");
		variables.mocked.metaDataObj = variables.mockbox.createEmptyMock("model.content.MetaData");
		variables.mocked.securityServiceObj = variables.mockbox.createEmptyMock("model.security.SecurityService");
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("ValidateThis.core.ValidationFactory");
	}

	function setup() {
		super.setup("model.content.ContentService");

		variables.CUT
			.$property(propertyName = "ContentGateway", propertyScope = "variables", mock = variables.mocked.contentGatewayObj)
			.$property(propertyName = "MetaData", propertyScope = "variables", mock = variables.mocked.metaDataObj)
			.$property(propertyName = "SecurityService", propertyScope = "variables", mock = variables.mocked.securityServiceObj)
			.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	// deletePage() tests

	private struct function getMocksForDeletePageTests() {
		local.mocked = {};
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page")
			.$("getTitle", "the page title")
			.$("isPersisted", TRUE);
		variables.mocked.contentGatewayObj
			.$("getPage", variables.mocked.pageObj, FALSE)
			.$("deletePage");
		return local.mocked;
	}

	function test_deletePage_deletes_page_if_it_is_persisted() {
		local.mocked = getMocksForDeletePageTests();
		variables.CUT.deletePage(pageid = 111);
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("deletePage"));
	}

	function test_deletePage_does_not_delete_page_if_it_is_not_persisted() {
		local.mocked = getMocksForDeletePageTests();
		variables.mocked.pageObj.$("isPersisted", FALSE);
		variables.CUT.deletePage(pageid = 111);
		$assert.isTrue(variables.mocked.contentGatewayObj.$never("deletePage"));
	}

	// findContentBySearchTerm() tests

	private struct function getMocksForFindContentBySearchTermTests() {
		local.mocked = {};
		variables.mocked.contentGatewayObj.$("findContentBySearchTerm", querySim(""));
		return local.mocked;
	}

	function test_findContentBySearchTerm_calls_findContentBySearchTerm_gateway_method() {
		local.mocked = getMocksForFindContentBySearchTermTests();
		local.actual = variables.CUT.findContentBySearchTerm(searchTerm = "the search term");
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("findContentBySearchTerm"));
	}

	// getChildren() tests

	private struct function getMocksForGetChildrenTests() {
		local.mocked = {};
		variables.mocked.contentGatewayObj.$("getChildren", querySim(""));
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page")
			.$("getLeftValue", 111)
			.$("getRightValue", 222);
		return local.mocked;
	}

	function test_getChildren_calls_getChildren_gateway_method() {
		local.mocked = getMocksForGetChildrenTests();
		local.actual = variables.CUT.getChildren(Page = variables.mocked.pageObj);
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("getChildren"));
	}

	// getPage() tests

	private struct function getMocksForGetPageTests() {
		local.mocked = {};
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.mocked.contentGatewayObj.$("getPage", variables.mocked.pageObj, FALSE);
		return local.mocked;
	}

	function test_getPage_returns_a_page() {
		local.mocked = getMocksForGetPageTests();
		local.actual = variables.CUT.getPage(pageid = 111);
		$assert.instanceOf(local.actual, "model.content.Page");
	}

	// getPageBySlug() tests

	private struct function getMocksForGetPageBySlugTests() {
		local.mocked = {};
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.mocked.contentGatewayObj.$("getPageBySlug", variables.mocked.pageObj, FALSE);
		return local.mocked;
	}

	function test_getPageBySlug_calls_getPageBySlug_gateway_method() {
		local.mocked = getMocksForGetPageBySlugTests();
		local.actual = variables.CUT.getPageBySlug(slug = "the slug");
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("getPageBySlug"));
	}

	// getPages() tests

	private struct function getMocksForGetPagesTests() {
		local.mocked = {};
		variables.mocked.contentGatewayObj.$("getPages", []);
		return local.mocked;
	}

	function test_getPages_calls_getPages_gateway_method() {
		local.mocked = getMocksForGetPagesTests();
		local.actual = variables.CUT.getPages();
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("getPages"));
	}

	// getNavigation() tests

	private struct function getMocksForGetNavigationTests() {
		local.mocked = {};
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page")
			.$("getLeftValue", 111)
			.$("getRightValue", 222);
		variables.mocked.contentGatewayObj.$("getNavigation", querySim(""));
		return local.mocked;
	}

	function test_getNavigation_calls_getNavigation_gateway_method() {
		local.mocked = getMocksForGetNavigationTests();
		local.actual = variables.CUT.getNavigation();
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("getNavigation"));
	}

	function test_getNavigation_sets_left_and_right_params_when_page_argument_exists() {
		local.mocked = getMocksForGetNavigationTests();
		variables.CUT.getNavigation(Page = variables.mocked.pageObj);
		local.result = variables.mocked.contentGatewayObj.$calllog().getNavigation[1];
		$assert.isEqual(local.result.left, 111, "Expected left value to be 111.");
		$assert.isEqual(local.result.right, 222, "Expected right value to be 222.");
	}

	function test_getNavigation_sets_depth_param_when_depth_argument_exists() {
		local.mocked = getMocksForGetNavigationTests();
		variables.CUT.getNavigation(depth = 111);
		local.result = variables.mocked.contentGatewayObj.$calllog().getNavigation[1];
		$assert.isEqual(local.result.depth, 111, "Expected depth to be 111.");
	}

	// getNavigationPath() tests

	private struct function getMocksForGetNavigationPathTests() {
		local.mocked = {};
		variables.mocked.contentGatewayObj.$("getNavigationPath", querySim(""));
		return local.mocked;
	}

	function test_getNavigationPath_calls_getNavigationPath_gateway_method() {
		local.mocked = getMocksForGetNavigationPathTests();
		local.actual = variables.CUT.getNavigationPath(pageId = 111);
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("getNavigationPath"));
	}

	// getRoot() tests

	private struct function getMocksForGetRootTests() {
		local.mocked = {};
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.mocked.contentGatewayObj.$("getRoot", variables.mocked.pageObj, FALSE);
		return local.mocked;
	}

	function test_getRoot_calls_getRoot_gateway_method() {
		local.mocked = getMocksForGetRootTests();
		local.actual = variables.CUT.getRoot();
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("getRoot"));
	}

	// savePage() tests

	private struct function getMocksForSavePageTests() {
		local.mocked = {};
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getTitle");
		variables.mocked.contentGatewayObj
			.$("getPage", variables.mocked.pageObj, FALSE)
			.$("savePage", variables.mocked.pageObj, FALSE);
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

	function test_savePage_generates_meta_tags_when_metaGenerated_property_is_true() {
		local.mocked = getMocksForSavePageTests();
		local.properties = {metaGenerated = TRUE, title = "", content = "", metaTitle = ""};
		variables.CUT.savePage(properties = local.properties, ancestorId = 111, context = "", websiteTitle = "", defaultSlug = "");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generatePageTitle"), "Expected generatePageTitle to be called once.");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generateMetaDescription"), "Expected generateMetaDescription to be called once.");
		$assert.isTrue(variables.mocked.metaDataObj.$once("generateMetaKeywords"), "Expected generateMetaKeywords to be called once.");
	}

	function test_savePage_sets_success_message_when_no_validation_errors_exist() {
		local.mocked = getMocksForSavePageTests();
		local.properties = {title = "", content = "", metaTitle = ""};
		variables.CUT.savePage(properties = local.properties, ancestorId = 111, context = "", websiteTitle = "", defaultSlug = "");
		$assert.isTrue(variables.mocked.resultObj.$once("setSuccessMessage"));
	}

	function test_savePage_sets_error_message_when_validation_errors_exist() {
		local.mocked = getMocksForSavePageTests();
		variables.mocked.resultObj.$("hasErrors", TRUE);
		local.properties = {title = "", content = "", metaTitle = ""};
		variables.CUT.savePage(properties = local.properties, ancestorId = 111, context = "", websiteTitle = "", defaultSlug = "");
		$assert.isTrue(variables.mocked.resultObj.$once("setErrorMessage"));
	}

	// saveSortOrder() tests

	private struct function getMocksForSaveSortOrderTests() {
		local.mocked = {};
		variables.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page")
			.$("getLeftValue", 1)
			.$("getPageId", 222)
			.$("getRightValue", 2)
			.$("getTitle")
			.$("isPersisted", TRUE);
		variables.mocked.contentGatewayObj
			.$("getNavigation", querySim(""))
			.$("shiftPages");
		variables.CUT.$("getPage", variables.mocked.pageObj, FALSE);
		return local.mocked;
	}

	function test_saveSortOrder_returns_false_when_page_is_not_persisted() {
		local.mocked = getMocksForSaveSortOrderTests();
		variables.mocked.pageObj.$("isPersisted", FALSE);
		local.actual = variables.CUT.saveSortOrder(pages = [{pageid = 111}]);
		$assert.isFalse(local.actual);
	}

	function test_saveSortOrder_calls_getNavigation_when_page_is_being_moved() {
		local.mocked = getMocksForSaveSortOrderTests();
		variables.CUT.saveSortOrder(pages = [{pageid = 111, left = 3, right = 4}]);
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("getNavigation"));
	}

	function test_saveSortOrder_calls_shiftPages_when_page_is_being_moved() {
		local.mocked = getMocksForSaveSortOrderTests();
		variables.CUT.saveSortOrder(pages = [{pageid = 111, left = 3, right = 4}]);
		$assert.isTrue(variables.mocked.contentGatewayObj.$once("shiftPages"));
	}

}
