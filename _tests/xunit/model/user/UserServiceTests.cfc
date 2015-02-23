component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.userGatewayObj = variables.mockbox.createEmptyMock("model.user.UserGateway");
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("framework.ValidateThis.core.ValidationFactory");
	}

	function setup() {
		super.setup("model.user.UserService");

		variables.CUT
			.$property(propertyName = "UserGateway", propertyScope = "variables", mock = variables.mocked.userGatewayObj)
			.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	function test_deleteUser_calls_deleteUser_gateway_method_when_user_is_persisted() {
		setupDeleteUserTests();
		variables.mocked.userObj.$("isPersisted", TRUE);
		variables.CUT.deleteUser(userId = 111);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("deleteUser"));
	}

	function test_deleteUser_does_not_call_deleteUser_gateway_method_when_user_is_not_persisted() {
		setupDeleteUserTests();
		variables.mocked.userObj.$("isPersisted", FALSE);
		variables.CUT.deleteUser(userId = 111);
		$assert.isTrue(variables.mocked.userGatewayObj.$never("deleteUser"));
	}

	function test_getUser_calls_getUser_gateway_method() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUser", variables.mocked.userObj);
		local.actual = variables.CUT.getUser(userId = 111);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUser"));
	}

	function test_getUserByCredentials_calls_getUserByCredentials_gateway_method() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUserByCredentials", variables.mocked.userObj);
		local.actual = variables.CUT.getUserByCredentials(theUser = variables.mocked.userObj);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUserByCredentials"));
	}

	function test_getUserByEmail_calls_getUserByEmail_gateway_method() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUserByEmail", variables.mocked.userObj);
		local.actual = variables.CUT.getUserByEmail(theUser = variables.mocked.userObj);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUserByEmail"));
	}

	function test_getUsers_calls_getUsers_gateway_method() {
		variables.mocked.userGatewayObj.$("getUsers", []);
		local.actual = variables.CUT.getUsers();
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUsers"));
	}

	function test_newPassword_returns_password_with_length_of_8_characters() {
		local.actual = variables.CUT.newPassword();
		$assert.isEqual(8, len(local.actual));
	}

	function test_newUser_calls_newUser_gateway_method() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("newUser", variables.mocked.userObj);
		local.actual = variables.CUT.newUser();
		$assert.isTrue(variables.mocked.userGatewayObj.$once("newUser"));
	}

	function test_saveUser_calls_saveUser_gateway_method_when_valid_user() {
		setupSaveUserTests();
		variables.mocked.resultObj.$("hasErrors", FALSE);
		local.actual = variables.CUT.saveUser(properties = {}, context = "");
		$assert.isTrue(variables.mocked.userGatewayObj.$once("saveUser"));
	}

	function test_saveUser_does_not_call_saveUser_gateway_method_when_invalid_user() {
		setupSaveUserTests();
		variables.mocked.resultObj.$("hasErrors", TRUE);
		local.actual = variables.CUT.saveUser(properties = {}, context = "");
		$assert.isTrue(variables.mocked.userGatewayObj.$never("saveUser"));
	}

	// Helper Methods

	private function setupDeleteUserTests() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj
			.$("deleteUser")
			.$("getUser", variables.mocked.userObj);
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
	}

	private function setupSaveUserTests() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj
			.$("getUser", variables.mocked.userObj)
			.$("populate")
			.$("saveUser", variables.mocked.userObj, FALSE);
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
	}

}
