component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("framework.ValidateThis.core.ValidationFactory");
	}

	function setup() {
		super.setup("model.utility.FileManagerService");

		variables.CUT.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	function test_deleteFile_deletes_file_if_it_exists() {
		setupDeleteFileTests();
		variables.CUT
			.$("isFile", TRUE)
			.deleteFile(file = "");
		local.actual = variables.CUT.$once("getFile");
		$assert.isTrue(local.actual);
	}

	function test_deleteFile_does_not_delete_file_if_it_does_not_exist() {
		setupDeleteFileTests();
		variables.CUT
			.$("isFile", FALSE)
			.deleteFile(file = "");
		local.actual = variables.CUT.$never("getFile");
		$assert.isTrue(local.actual);
	}

	function test_isDirectory_returns_true_if_directory_exists() {
		variables.CUT.$("getFile", variables.mockbox.createStub().$("isDirectory", TRUE));
		local.actual = variables.CUT.isDirectory(directory = "");
		$assert.isTrue(local.actual);
	}

	function test_isDirectory_returns_false_if_directory_does_not_exist() {
		variables.CUT.$("getFile", variables.mockbox.createStub().$("isDirectory", FALSE));
		local.actual = variables.CUT.isDirectory(directory = "");
		$assert.isFalse(local.actual);
	}

	// Helper Methods

	private function setupDeleteFileTests() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.CUT.$("getFile", variables.mockbox.createStub().$("delete"));
	}

}
