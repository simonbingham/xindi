component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.aop.GlobalEventHandler");
	}

	// Tests

	function test_preInsert_calls_setCreated_when_method_exists() {
		local.mocked.entity = variables.mockbox.createStub().$("setCreated");
		variables.CUT.preInsert(entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setCreated"));
	}

	function test_preInsert_calls_setUpdated_when_method_exists() {
		local.mocked.entity = variables.mockbox.createStub().$("setUpdated");
		variables.CUT.preInsert(entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setUpdated"));
	}

	function test_preUpdate_calls_setUpdated_when_method_exists() {
		local.mocked.entity = variables.mockbox.createStub().$("setUpdated");
		variables.CUT.preUpdate(entity = local.mocked.entity);
		$assert.isTrue(local.mocked.entity.$once("setUpdated"));
	}

}
