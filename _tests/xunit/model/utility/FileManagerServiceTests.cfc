component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("ValidateThis.core.ValidationFactory");
	}

	function setup() {
		super.setup("model.utility.FileManagerService");

		variables.CUT.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	// deleteFile() tests

	private struct function getMocksForDeleteFileTests() {
		local.mocked = {};
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.CUT
			.$("getFile", variables.mockbox.createStub().$("delete"))
			.$("isFile", TRUE);
		return local.mocked;
	}

	function test_deleteFile_deletes_file_if_it_exists() {
		local.mocked = getMocksForDeleteFileTests();
		variables.CUT.deleteFile(file = "");
		local.actual = variables.CUT.$once("getFile");
		$assert.isTrue(local.actual);
	}

	function test_deleteFile_does_not_delete_file_if_it_does_not_exist() {
		local.mocked = getMocksForDeleteFileTests();
		variables.CUT
			.$("isFile", FALSE)
			.deleteFile(file = "");
		local.actual = variables.CUT.$never("getFile");
		$assert.isTrue(local.actual);
	}

	// isDirectory() tests

	private struct function getMocksForIsDirectoryTests() {
		local.mocked = {};
		variables.CUT.$("getFile", variables.mockbox.createStub().$("isDirectory", TRUE));
		return local.mocked;
	}

	function test_isDirectory_returns_true_if_directory_exists() {
		local.mocked = getMocksForIsDirectoryTests();
		local.actual = variables.CUT.isDirectory(directory = "");
		$assert.isTrue(local.actual);
	}

	function test_isDirectory_returns_false_if_directory_does_not_exist() {
		local.mocked = getMocksForIsDirectoryTests();
		variables.CUT.$("getFile", variables.mockbox.createStub().$("isDirectory", FALSE));
		local.actual = variables.CUT.isDirectory(directory = "");
		$assert.isFalse(local.actual);
	}

}
