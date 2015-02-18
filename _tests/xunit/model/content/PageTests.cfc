component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.content.Page");
	}

	// Tests

	function test_getDescendentPageIDList_returns_expected_result() {
		local.mocked.firstPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 111);
		local.mocked.secondPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 222);
		variables.CUT.$("getDescendents", [local.mocked.firstPageObj, local.mocked.secondPageObj]);
		local.expected = "111,222";
		local.actual = variables.CUT.getDescendentPageIDList();
		$assert.isEqual(local.expected, local.actual);
	}

	function test_hasChild_returns_true_when_child_exists() {
		local.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.CUT.$("getFirstChild", local.mocked.pageObj);
		local.actual = variables.CUT.hasChild();
		$assert.isTrue(local.actual);
	}

	function test_hasChild_returns_false_when_child_does_not_exist() {
		variables.CUT.$("getFirstChild");
		local.actual = variables.CUT.hasChild();
		$assert.isFalse(local.actual);
	}

	function test_hasNextSibling_returns_true_when_next_sibling_exists() {
		local.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.CUT.$("getNextSibling", local.mocked.pageObj);
		local.actual = variables.CUT.hasNextSibling();
		$assert.isTrue(local.actual);
	}

	function test_hasNextSibling_returns_false_when_next_sibling_does_not_exist() {
		variables.CUT.$("getNextSibling");
		local.actual = variables.CUT.hasNextSibling();
		$assert.isFalse(local.actual);
	}

	function test_hasMetaDescription_returns_true_when_meta_description_exists() {
		variables.CUT.$property(propertyName = "metaDescription", propertyScope = "variables", mock = "the meta description");
		local.actual = variables.CUT.hasMetaDescription();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaDescription_returns_false_when_no_meta_description_exists() {
		variables.CUT.$property(propertyName = "metaDescription", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaDescription();
		$assert.isFalse(local.actual);
	}

	function test_hasMetaKeywords_returns_true_when_meta_keywords_exist() {
		variables.CUT.$property(propertyName = "metaKeywords", propertyScope = "variables", mock = "the meta keywords");
		local.actual = variables.CUT.hasMetaKeywords();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaKeywords_returns_false_when_no_meta_keywords_exist() {
		variables.CUT.$property(propertyName = "metaKeywords", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaKeywords();
		$assert.isFalse(local.actual);
	}

	function test_hasMetaTitle_returns_true_when_meta_title_exists() {
		variables.CUT.$property(propertyName = "metaTitle", propertyScope = "variables", mock = "the meta title");
		local.actual = variables.CUT.hasMetaTitle();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaTitle_returns_false_when_no_meta_title_exists() {
		variables.CUT.$property(propertyName = "metaTitle", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaTitle();
		$assert.isFalse(local.actual);
	}

	function test_hasPageIdInPath_returns_true_when_page_id_is_in_page_id_list() {
		variables.CUT.$property(propertyName = "pageId", propertyScope = "variables", mock = 111);
		local.actual = variables.CUT.hasPageIdInPath(pageIdList = "111,222,333");
		$assert.isTrue(local.actual);
	}

	function test_hasPageIdInPath_returns_true_when_page_id_is_in_path() {
		local.mocked.firstPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 111);
		local.mocked.secondPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 222);
		variables.CUT
			.$property(propertyName = "pageId", propertyScope = "variables", mock = "")
			.$("getPath", [local.mocked.firstPageObj, local.mocked.secondPageObj]);
		local.actual = variables.CUT.hasPageIdInPath(pageIdList = "111");
		$assert.isTrue(local.actual);
	}

	function test_hasPageIdInPath_returns_false_when_page_id_is_not_in_path() {
		local.mocked.firstPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 111);
		local.mocked.secondPageObj = variables.mockbox.createEmptyMock("model.content.Page").$("getPageId", 222);
		variables.CUT
			.$property(propertyName = "pageId", propertyScope = "variables", mock = "")
			.$("getPath", [local.mocked.firstPageObj, local.mocked.secondPageObj]);
		local.actual = variables.CUT.hasPageIdInPath(pageIdList = "333");
		$assert.isFalse(local.actual);
	}

	function test_hasPreviousSibling_returns_true_when_previous_sibling_exists() {
		local.mocked.pageObj = variables.mockbox.createEmptyMock("model.content.Page");
		variables.CUT.$("getPreviousSibling", local.mocked.pageObj);
		local.actual = variables.CUT.hasPreviousSibling();
		$assert.isTrue(local.actual);
	}

	function test_hasPreviousSibling_returns_false_when_previous_sibling_does_not_exist() {
		variables.CUT.$("getPreviousSibling");
		local.actual = variables.CUT.hasPreviousSibling();
		$assert.isFalse(local.actual);
	}

	function test_hasRoute_returns_true_when_a_page_has_a_fw1_route() {
		variables.CUT.$("getSlug", "the_slug");
		local.actual = variables.CUT.hasRoute(routes = [{the_slug = ""}]);
		$assert.isTrue(local.actual);
	}

	function test_hasRoute_returns_false_when_a_page_does_not_have_a_fw1_route() {
		variables.CUT.$("getSlug", "the_slug");
		local.actual = variables.CUT.hasRoute();
		$assert.isFalse(local.actual);
	}

	function test_isLeaf_returns_true_if_a_page_is_a_leaf() {
		variables.CUT.$("getDescendentCount", 0);
		local.actual = variables.CUT.isLeaf();
		$assert.isTrue(local.actual);
	}

	function test_isLeaf_returns_false_if_a_page_is_not_a_leaf() {
		variables.CUT.$("getDescendentCount", 1);
		local.actual = variables.CUT.isLeaf();
		$assert.isFalse(local.actual);
	}

	function test_isMetaGenerated_returns_true_when_meta_data_is_generated() {
		variables.CUT.$property(propertyName = "metaGenerated", propertyScope = "variables", mock = TRUE);
		local.actual = variables.CUT.isMetaGenerated();
		$assert.isTrue(local.actual);
	}

	function test_isMetaGenerated_returns_false_when_meta_data_is_not_generated() {
		variables.CUT.$property(propertyName = "metaGenerated", propertyScope = "variables", mock = FALSE);
		local.actual = variables.CUT.isMetaGenerated();
		$assert.isFalse(local.actual);
	}

	function test_isPersisted_returns_true_when_page_is_persisted() {
		variables.CUT.$property(propertyName = "pageId", propertyScope = "variables", mock = 111);
		local.actual = variables.CUT.isPersisted();
		$assert.isTrue(local.actual);
	}

	function test_isRoot_returns_true_if_a_page_is_root() {
		variables.CUT.$property(propertyName = "leftValue", propertyScope = "variables", mock = 1);
		local.actual = variables.CUT.isRoot();
		$assert.isTrue(local.actual);
	}

	function test_isRoot_returns_false_if_a_page_is_not_root() {
		variables.CUT.$property(propertyName = "leftValue", propertyScope = "variables", mock = 222);
		local.actual = variables.CUT.isRoot();
		$assert.isFalse(local.actual);
	}

}
