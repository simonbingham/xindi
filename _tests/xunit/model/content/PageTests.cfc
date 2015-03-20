component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.content.Page");
	}

	// Tests

	// getDescendentPageIDList() tests

	private struct function getMocksForGetDescendentPageIDListTests() {
		local.mocked = {};
		local.mocked.firstPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 111);
		local.mocked.secondPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 222);
		variables.CUT.$("getDescendents", [local.mocked.firstPageObj, local.mocked.secondPageObj]);
		return local.mocked;
	}

	function test_getDescendentPageIDList_returns_expected_result() {
		local.mocked = getMocksForGetDescendentPageIDListTests();
		local.expected = "111,222";
		local.actual = variables.CUT.getDescendentPageIDList();
		$assert.isEqual(local.expected, local.actual);
	}

	// hasChild() tests

	private struct function getMocksForHasChildTests() {
		local.mocked = {};
		local.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.CUT.$("getFirstChild", local.mocked.pageObj);
		return local.mocked;
	}

	function test_hasChild_returns_true_when_child_exists() {
		local.mocked = getMocksForHasChildTests();
		local.actual = variables.CUT.hasChild();
		$assert.isTrue(local.actual);
	}

	function test_hasChild_returns_false_when_child_does_not_exist() {
		local.mocked = getMocksForHasChildTests();
		variables.CUT.$("getFirstChild");
		local.actual = variables.CUT.hasChild();
		$assert.isFalse(local.actual);
	}

	// hasNextSibling() tests

	private struct function getMocksForHasNextSiblingTests() {
		local.mocked = {};
		local.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.CUT.$("getNextSibling", local.mocked.pageObj);
		return local.mocked;
	}

	function test_hasNextSibling_returns_true_when_next_sibling_exists() {
		local.mocked = getMocksForHasNextSiblingTests();
		local.actual = variables.CUT.hasNextSibling();
		$assert.isTrue(local.actual);
	}

	function test_hasNextSibling_returns_false_when_next_sibling_does_not_exist() {
		local.mocked = getMocksForHasNextSiblingTests();
		variables.CUT.$("getNextSibling");
		local.actual = variables.CUT.hasNextSibling();
		$assert.isFalse(local.actual);
	}

	// hasMetaDescription() tests

	private struct function getMocksForHasMetaDescriptionTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "metaDescription", propertyScope = "variables", mock = "the meta description");
		return local.mocked;
	}

	function test_hasMetaDescription_returns_true_when_meta_description_exists() {
		local.mocked = getMocksForHasMetaDescriptionTests();
		local.actual = variables.CUT.hasMetaDescription();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaDescription_returns_false_when_no_meta_description_exists() {
		local.mocked = getMocksForHasMetaDescriptionTests();
		variables.CUT.$property(propertyName = "metaDescription", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaDescription();
		$assert.isFalse(local.actual);
	}

	// hasMetaKeywords() tests

	private struct function getMocksForHasMetaKeywordsTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "metaKeywords", propertyScope = "variables", mock = "the meta keywords");
		return local.mocked;
	}

	function test_hasMetaKeywords_returns_true_when_meta_keywords_exist() {
		local.mocked = getMocksForHasMetaKeywordsTests();
		local.actual = variables.CUT.hasMetaKeywords();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaKeywords_returns_false_when_no_meta_keywords_exist() {
		local.mocked = getMocksForHasMetaKeywordsTests();
		variables.CUT.$property(propertyName = "metaKeywords", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaKeywords();
		$assert.isFalse(local.actual);
	}

	// hasMetaTitle() tests

	private struct function getMocksForHasMetaTitleTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "metaTitle", propertyScope = "variables", mock = "the meta title");
		return local.mocked;
	}

	function test_hasMetaTitle_returns_true_when_meta_title_exists() {
		local.mocked = getMocksForHasMetaTitleTests();
		local.actual = variables.CUT.hasMetaTitle();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaTitle_returns_false_when_no_meta_title_exists() {
		local.mocked = getMocksForHasMetaTitleTests();
		variables.CUT.$property(propertyName = "metaTitle", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaTitle();
		$assert.isFalse(local.actual);
	}

	// hasPageIdInPath() tests

	private struct function getMocksForHasPageIdInPathTests() {
		local.mocked = {};
		local.mocked.firstPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 111);
		local.mocked.secondPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 222);
		variables.CUT
			.$property(propertyName = "pageId", propertyScope = "variables", mock = "")
			.$("getPath", [local.mocked.firstPageObj, local.mocked.secondPageObj]);
		return local.mocked;
	}

	function test_hasPageIdInPath_returns_true_when_page_id_is_in_page_id_list() {
		local.mocked = getMocksForHasPageIdInPathTests();
		variables.CUT.$property(propertyName = "pageId", propertyScope = "variables", mock = 111);
		local.actual = variables.CUT.hasPageIdInPath(pageIdList = "111,222,333");
		$assert.isTrue(local.actual);
	}

	function test_hasPageIdInPath_returns_true_when_page_id_is_in_path() {
		local.mocked = getMocksForHasPageIdInPathTests();
		local.actual = variables.CUT.hasPageIdInPath(pageIdList = "111");
		$assert.isTrue(local.actual);
	}

	function test_hasPageIdInPath_returns_false_when_page_id_is_not_in_path() {
		local.mocked = getMocksForHasPageIdInPathTests();
		local.actual = variables.CUT.hasPageIdInPath(pageIdList = "333");
		$assert.isFalse(local.actual);
	}

	// hasPreviousSibling() tests

	private struct function getMocksForHasPreviousSiblingTests() {
		local.mocked = {};
		local.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.CUT.$("getPreviousSibling", local.mocked.pageObj);
		return local.mocked;
	}

	function test_hasPreviousSibling_returns_true_when_previous_sibling_exists() {
		local.mocked = getMocksForHasPreviousSiblingTests();
		local.actual = variables.CUT.hasPreviousSibling();
		$assert.isTrue(local.actual);
	}

	function test_hasPreviousSibling_returns_false_when_previous_sibling_does_not_exist() {
		local.mocked = getMocksForHasPreviousSiblingTests();
		variables.CUT.$("getPreviousSibling");
		local.actual = variables.CUT.hasPreviousSibling();
		$assert.isFalse(local.actual);
	}

	// hasRoute() tests

	private struct function getMocksForHasRouteTests() {
		local.mocked = {};
		variables.CUT.$("getSlug", "the_slug");
		return local.mocked;
	}

	function test_hasRoute_returns_true_when_a_page_has_a_fw1_route() {
		local.mocked = getMocksForHasRouteTests();
		local.actual = variables.CUT.hasRoute(routes = [{the_slug = ""}]);
		$assert.isTrue(local.actual);
	}

	function test_hasRoute_returns_false_when_a_page_does_not_have_a_fw1_route() {
		local.mocked = getMocksForHasRouteTests();
		local.actual = variables.CUT.hasRoute();
		$assert.isFalse(local.actual);
	}

	// isLeaf() tests

	private struct function getMocksForIsLeafTests() {
		local.mocked = {};
		variables.CUT.$("getDescendentCount", 0);
		return local.mocked;
	}

	function test_isLeaf_returns_true_if_a_page_is_a_leaf() {
		local.mocked = getMocksForIsLeafTests();
		local.actual = variables.CUT.isLeaf();
		$assert.isTrue(local.actual);
	}

	function test_isLeaf_returns_false_if_a_page_is_not_a_leaf() {
		local.mocked = getMocksForIsLeafTests();
		variables.CUT.$("getDescendentCount", 1);
		local.actual = variables.CUT.isLeaf();
		$assert.isFalse(local.actual);
	}

	// isMetaGenerated() tests

	private struct function getMocksForIsMetaGeneratedTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "metaGenerated", propertyScope = "variables", mock = TRUE);
		return local.mocked;
	}

	function test_isMetaGenerated_returns_true_when_meta_data_is_generated() {
		local.mocked = getMocksForIsMetaGeneratedTests();
		local.actual = variables.CUT.isMetaGenerated();
		$assert.isTrue(local.actual);
	}

	function test_isMetaGenerated_returns_false_when_meta_data_is_not_generated() {
		local.mocked = getMocksForIsMetaGeneratedTests();
		variables.CUT.$property(propertyName = "metaGenerated", propertyScope = "variables", mock = FALSE);
		local.actual = variables.CUT.isMetaGenerated();
		$assert.isFalse(local.actual);
	}

	// isPersisted() tests

	private struct function getMocksForIsPersistedTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "pageId", propertyScope = "variables", mock = 111);
		return local.mocked;
	}

	function test_isPersisted_returns_true_when_page_is_persisted() {
		local.mocked = getMocksForIsPersistedTests();
		local.actual = variables.CUT.isPersisted();
		$assert.isTrue(local.actual);
	}

	// isRoot() tests

	private struct function getMocksForIsRootTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "leftValue", propertyScope = "variables", mock = 1);
		return local.mocked;
	}

	function test_isRoot_returns_true_if_a_page_is_root() {
		local.mocked = getMocksForIsRootTests();
		local.actual = variables.CUT.isRoot();
		$assert.isTrue(local.actual);
	}

	function test_isRoot_returns_false_if_a_page_is_not_root() {
		local.mocked = getMocksForIsRootTests();
		variables.CUT.$property(propertyName = "leftValue", propertyScope = "variables", mock = 222);
		local.actual = variables.CUT.isRoot();
		$assert.isFalse(local.actual);
	}

}
