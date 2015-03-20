component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.userGatewayObj = variables.mockbox.createEmptyMock("model.user.UserGateway");
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("ValidateThis.core.ValidationFactory");
	}

	function setup() {
		super.setup("model.user.UserService");

		variables.CUT
			.$property(propertyName = "UserGateway", propertyScope = "variables", mock = variables.mocked.userGatewayObj)
			.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	// deleteUser() tests

	private struct function getMocksForDeleteUserTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User")
			.$("getName")
			.$("isPersisted", TRUE);
		variables.mocked.userGatewayObj
			.$("deleteUser")
			.$("getUser", variables.mocked.userObj);
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		return local.mocked;
	}

	function test_deleteUser_calls_deleteUser_gateway_method_when_user_is_persisted() {
		local.mocked = getMocksForDeleteUserTests();
		variables.CUT.deleteUser(userId = 111);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("deleteUser"));
	}

	function test_deleteUser_does_not_call_deleteUser_gateway_method_when_user_is_not_persisted() {
		local.mocked = getMocksForDeleteUserTests();
		variables.mocked.userObj.$("isPersisted", FALSE);
		variables.CUT.deleteUser(userId = 111);
		$assert.isTrue(variables.mocked.userGatewayObj.$never("deleteUser"));
	}

	// getUser() tests

	private struct function getMocksForGetUserTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUser", variables.mocked.userObj);
		return local.mocked;
	}

	function test_getUser_calls_getUser_gateway_method() {
		local.mocked = getMocksForGetUserTests();
		local.actual = variables.CUT.getUser(userId = 111);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUser"));
	}

	// getUserByCredentials() tests

	private struct function getMocksForGetUserByCredentialsTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUserByCredentials", variables.mocked.userObj);
		return local.mocked;
	}

	function test_getUserByCredentials_calls_getUserByCredentials_gateway_method() {
		local.mocked = getMocksForGetUserByCredentialsTests();
		local.actual = variables.CUT.getUserByCredentials(theUser = variables.mocked.userObj);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUserByCredentials"));
	}

	// getUserByEmail() tests

	private struct function getMocksForGetUserByEmailTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUserByEmail", variables.mocked.userObj);
		return local.mocked;
	}

	function test_getUserByEmail_calls_getUserByEmail_gateway_method() {
		local.mocked = getMocksForGetUserByEmailTests();
		local.actual = variables.CUT.getUserByEmail(theUser = variables.mocked.userObj);
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUserByEmail"));
	}

	// getUsers() tests

	private struct function getMocksForGetUsersTests() {
		local.mocked = {};
		variables.mocked.userGatewayObj.$("getUsers", []);
		return local.mocked;
	}

	function test_getUsers_calls_getUsers_gateway_method() {
		local.mocked = getMocksForGetUsersTests();
		local.actual = variables.CUT.getUsers();
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUsers"));
	}

	// newPassword() tests

	function test_newPassword_returns_password_with_length_of_8_characters() {
		local.mocked = getMocksForGetUsersTests();
		local.actual = variables.CUT.newPassword();
		$assert.isEqual(8, len(local.actual));
	}

	// newUser() tests

	private struct function getMocksForNewUserTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("newUser", variables.mocked.userObj);
		return local.mocked;
	}

	function test_newUser_calls_newUser_gateway_method() {
		local.mocked = getMocksForNewUserTests();
		local.actual = variables.CUT.newUser();
		$assert.isTrue(variables.mocked.userGatewayObj.$once("newUser"));
	}

	// saveUser() tests

	private struct function getMocksForSaveUserTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User").$("getName");
		variables.mocked.userGatewayObj
			.$("getUser", variables.mocked.userObj)
			.$("populate")
			.$("saveUser", variables.mocked.userObj, FALSE);
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("hasErrors", FALSE)
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
		return local.mocked;
	}

	function test_saveUser_calls_saveUser_gateway_method_when_valid_user() {
		local.mocked = getMocksForSaveUserTests();
		local.actual = variables.CUT.saveUser(properties = {}, context = "");
		$assert.isTrue(variables.mocked.userGatewayObj.$once("saveUser"));
	}

	function test_saveUser_does_not_call_saveUser_gateway_method_when_invalid_user() {
		local.mocked = getMocksForSaveUserTests();
		variables.mocked.resultObj.$("hasErrors", TRUE);
		local.actual = variables.CUT.saveUser(properties = {}, context = "");
		$assert.isTrue(variables.mocked.userGatewayObj.$never("saveUser"));
	}

}
