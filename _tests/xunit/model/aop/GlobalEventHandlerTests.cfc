component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.aop.GlobalEventHandler");
	}

	// Tests

	// preInsert() tests

	private struct function getMocksForPreInsertTests() {
		local.mocked = {};
		local.mocked.entity = variables.mockbox.createStub()
			.$("setCreated")
			.$("setUpdated");
		return local.mocked;
	}

	function test_preInsert_calls_setCreated_when_method_exists() {
		local.mocked = getMocksForPreInsertTests();
		variables.CUT.preInsert(entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setCreated"));
	}

	function test_preInsert_calls_setUpdated_when_method_exists() {
		local.mocked = getMocksForPreInsertTests();
		variables.CUT.preInsert(entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setUpdated"));
	}

	// preUpdate() tests

	private struct function getMocksForPreUpdateTests() {
		local.mocked = {};
		local.mocked.entity = variables.mockbox.createStub().$("setUpdated");
		return local.mocked;
	}

	function test_preUpdate_calls_setUpdated_when_method_exists() {
		local.mocked = getMocksForPreUpdateTests();
		variables.CUT.preUpdate(entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setUpdated"));
	}

}
