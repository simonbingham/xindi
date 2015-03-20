component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("ValidateThis.core.ValidationFactory");
		variables.mocked.metaDataObj = variables.mockbox.createEmptyMock("model.content.MetaData");
	}

	function setup() {
		super.setup("model.abstract.BaseService");

		variables.CUT
			.$property(propertyName = "MetaData", propertyScope = "variables", mock = variables.mocked.metaDataObj)
			.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	// getValidator() tests

	private struct function getMocksForGetValidatorTests() {
		local.mocked = {};
		variables.mocked.validationFactoryObj.$("getValidator");
		return local.mocked;
	}

	function test_getValidator_calls_getValidator_once() {
		local.mocked = getMocksForGetValidatorTests();
		variables.CUT.getValidator(Entity = "");
		$assert.isTrue(variables.mocked.validationFactoryObj.$once("getValidator"));
	}

	// populate() tests

	private struct function getMocksForPopulateTests() {
		local.mocked = {};
		local.mocked.entity = variables.mockbox.createStub().$("setTest");
		return local.mocked;
	}

	function test_populate_sets_property_when_key_is_included_and_setter_exists() {
		local.mocked = getMocksForPopulateTests();
		variables.CUT.populate(Entity = local.mocked.entity, memento = {test = ""}, include = "test");
		$assert.isTrue(local.mocked.entity.$once("setTest"));
	}

	function test_populate_does_not_set_property_when_key_is_excluded() {
		local.mocked = getMocksForPopulateTests();
		variables.CUT.populate(Entity = local.mocked.entity, memento = {test = ""}, exclude = "test");
		$assert.isTrue(local.mocked.entity.$never("setTest"));
	}

	// populateMetaData() tests

	private struct function getMocksForPopulateMetaDataTests() {
		local.mocked = {};
		variables.mocked.metaDataObj
			.$("generateMetaDescription", "")
			.$("generateMetaKeywords", "");
		local.mocked.entity = variables.mockbox.createStub()
			.$("isMetaGenerated", TRUE)
			.$("getContent", "")
			.$("getTitle", "")
			.$("setMetaTitle")
			.$("setMetaDescription")
			.$("setMetaKeywords");
		return local.mocked;
	}

	function test_populateMetaData_sets_meta_title_when_isMetaGenerated_is_true() {
		local.mocked = getMocksForPopulateMetaDataTests();
		variables.CUT.populateMetaData(Entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setMetaTitle"));
	}

	function test_populateMetaData_sets_meta_description_when_isMetaGenerated_is_true() {
		local.mocked = getMocksForPopulateMetaDataTests();
		variables.CUT.populateMetaData(Entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setMetaDescription"));
	}

	function test_populateMetaData_sets_meta_keywords_when_isMetaGenerated_is_true() {
		local.mocked = getMocksForPopulateMetaDataTests();
		variables.CUT.populateMetaData(Entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setMetaKeywords"));
	}

	function test_populateMetaData_does_not_set_meta_data_when_isMetaGenerated_is_false() {
		local.mocked = getMocksForPopulateMetaDataTests();
		local.mocked.entity.$("isMetaGenerated", FALSE);
		variables.CUT.populateMetaData(Entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$never("setMetaDescription"));
		$assert.isTrue(local.mocked.entity.$never("setMetaKeywords"));
		$assert.isTrue(local.mocked.entity.$never("setMetaTitle"));
	}

}
