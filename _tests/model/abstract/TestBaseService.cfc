component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function getValidator() {
		var Page = EntityNew("Page");
		result = CUT.getValidator(Page);
		assertTrue(IsObject(result));
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.abstract.BaseService();
		var validatorconfig = {definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult"};
		var Validator = new ValidateThis.ValidateThis(validatorconfig);
		CUT.setValidator(Validator);
	}

	/**
	* this will run after every single test in this test case
	*/
	function tearDown() {}

	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests() {}

	/**
	* this will run once after all tests have been run
	*/
	function afterTests() {}

}
