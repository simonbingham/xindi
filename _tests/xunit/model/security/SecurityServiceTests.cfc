component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.notificationServiceObj = variables.mockbox.createEmptyMock("model.utility.NotificationService");
		variables.mocked.userGatewayObj = variables.mockbox.createEmptyMock("model.user.UserGateway");
		variables.mocked.userServiceObj = variables.mockbox.createEmptyMock("model.user.UserService");
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("ValidateThis.core.ValidationFactory");
		variables.mocked.config = {};
	}

	function setup() {
		super.setup("model.security.SecurityService");

		variables.CUT
			.$property(propertyName = "NotificationService", propertyScope = "variables", mock = variables.mocked.notificationServiceObj)
			.$property(propertyName = "UserGateway", propertyScope = "variables", mock = variables.mocked.userGatewayObj)
			.$property(propertyName = "UserService", propertyScope = "variables", mock = variables.mocked.userServiceObj)
			.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj)
			.$property(propertyName = "config", propertyScope = "variables", mock = variables.mocked.config);
	}

	// Tests

	// deleteCurrentUser() tests

	private struct function getMocksForDeleteCurrentUserTests() {
		local.mocked = {};
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.CUT
			.$("getCurrentStorage", {})
			.$("hasCurrentUser", TRUE);
		return local.mocked;
	}

	function test_deleteCurrentUser_deletes_current_user_when_user_is_in_storage() {
		local.mocked = getMocksForDeleteCurrentUserTests();
		variables.CUT.deleteCurrentUser();
		$assert.isTrue(variables.CUT.$once("getCurrentStorage"));
	}

	function test_deleteCurrentUser_does_not_delete_current_user_when_user_is_not_in_storage() {
		local.mocked = getMocksForDeleteCurrentUserTests();
		variables.CUT
			.$("hasCurrentUser", FALSE)
			.deleteCurrentUser();
		$assert.isTrue(variables.CUT.$never("getCurrentStorage"));
	}

	// getCurrentStorage() tests

	function test_getCurrentStorage_returns_a_structure() {
		local.actual = variables.CUT.getCurrentStorage();
		$assert.typeOf("struct", local.actual);
	}

	// getCurrentUser() tests

	private struct function getMocksForGetCurrentUserTests() {
		local.mocked = {};
		variables.CUT
			.$("getCurrentStorage", {the_user_key = "the user key"})
			.$("hasCurrentUser", TRUE)
			.$property(propertyName = "USER_KEY", propertyScope = "variables", mock = "the_user_key");
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUser", variables.mocked.userObj, FALSE);
		return local.mocked;
	}

	function test_getCurrentUser_returns_current_user_when_user_is_in_storage() {
		local.mocked = getMocksForGetCurrentUserTests();
		variables.CUT.getCurrentUser();
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUser"));
	}

	function test_getCurrentUser_returns_current_user_when_user_is_not_in_storage() {
		local.mocked = getMocksForGetCurrentUserTests();
		variables.CUT
			.$("hasCurrentUser", FALSE)
			.getCurrentUser();
		$assert.isTrue(variables.mocked.userGatewayObj.$never("getUser"));
	}

	// hasCurrentUser() tests

	private struct function getMocksForHasCurrentUserTests() {
		local.mocked = {};
		variables.CUT
			.$("getCurrentStorage", {the_user_key = ""})
			.$property(propertyName = "USER_KEY", propertyScope = "variables", mock = "the_user_key");
		return local.mocked;
	}

	function test_hasCurrentUser_returns_true_when_user_is_in_storage() {
		local.mocked = getMocksForHasCurrentUserTests();
		local.actual = variables.CUT.hasCurrentUser();
		$assert.isTrue(local.actual);
	}

	function test_hasCurrentUser_returns_false_when_user_is_not_in_storage() {
		local.mocked = getMocksForHasCurrentUserTests();
		variables.CUT.$("getCurrentStorage", {});
		local.actual = variables.CUT.hasCurrentUser();
		$assert.isFalse(local.actual);
	}

	// isAllowed() tests

	private struct function getMocksForIsAllowedTests() {
		local.mocked = {};
		variables.CUT
			.$property(propertyName = "config.security", propertyScope = "variables", mock = {whitelist = ""})
			.$("hasCurrentUser", FALSE);
		return local.mocked;
	}

	function test_isAllowed_returns_true_when_user_is_not_in_storage_and_page_is_whitelisted() {
		local.mocked = getMocksForIsAllowedTests();
		variables.CUT.$property(propertyName = "config.security", propertyScope = "variables", mock = {whitelist = "the action"});
		local.actual = variables.CUT.isAllowed(action = "the action");
		$assert.isTrue(local.actual);
	}

	function test_isAllowed_returns_false_when_user_is_not_in_storage_and_page_is_not_whitelisted() {
		local.mocked = getMocksForIsAllowedTests();
		local.actual = variables.CUT.isAllowed(action = "the action");
		$assert.isFalse(local.actual);
	}

	function test_isAllowed_returns_true_when_user_is_in_storage() {
		local.mocked = getMocksForIsAllowedTests();
		variables.CUT.$("hasCurrentUser", TRUE);
		local.actual = variables.CUT.isAllowed(action = "the action");
		$assert.isTrue(local.actual);
	}

	// loginUser() tests

	private struct function getMocksForLoginUserTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User")
			.$("getName")
			.$("isPersisted", TRUE);
		variables.mocked.userGatewayObj
			.$("newUser", variables.mocked.userObj, FALSE)
			.$("getUserByCredentials", variables.mocked.userObj, FALSE);
		variables.CUT
			.$("populate")
			.$("setCurrentUser");
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("addFailure")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
		return local.mocked;
	}

	function test_loginUser_adds_user_to_storage_when_user_is_persisted() {
		local.mocked = getMocksForLoginUserTests();
		variables.CUT.loginUser(properties = {email = "", password = ""});
		$assert.isTrue(variables.CUT.$once("setCurrentUser"));
	}

	function test_loginUser_does_not_add_user_to_storage_when_user_is_not_persisted() {
		local.mocked = getMocksForLoginUserTests();
		variables.mocked.userObj.$("isPersisted", FALSE);
		variables.CUT.loginUser(properties = {email = "", password = ""});
		$assert.isTrue(variables.CUT.$never("setCurrentUser"));
	}

	// resetPassword() tests

	private struct function getMocksForResetPasswordTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User")
			.$("getEmail")
			.$("isPersisted", TRUE)
			.$("setPassword");
		variables.mocked.userGatewayObj
			.$("newUser", variables.mocked.userObj, FALSE)
			.$("getUserByEmail", variables.mocked.userObj, FALSE);
		variables.mocked.userServiceObj.$("newPassword", "");
		variables.CUT
			.$("populate")
			.$("setCurrentUser");
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("addFailure")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
		variables.mocked.notificationServiceObj.$("send");
		return local.mocked;
	}

	function test_resetPassword_resets_password_when_user_is_persisted() {
		local.mocked = getMocksForResetPasswordTests();
		variables.CUT.resetPassword(properties = {email = ""}, name = "", config = {resetPasswordEmailSubject = "", resetPasswordEmailFrom = ""}, emailTemplatePath = "../../admin/views/security/email.cfm");
		$assert.isTrue(variables.mocked.userObj.$once("setPassword"));

	}

	function test_resetPassword_does_not_reset_password_when_user_is_not_persisted() {
		local.mocked = getMocksForResetPasswordTests();
		variables.mocked.userObj.$("isPersisted", FALSE);
		variables.CUT.resetPassword(properties = {email = ""}, name = "", config = {resetPasswordEmailSubject = "", resetPasswordEmailFrom = ""}, emailTemplatePath = "../../admin/views/security/email.cfm");
		$assert.isTrue(variables.mocked.userObj.$never("setPassword"));
	}

	// setCurrentUser() tests

	private struct function getMocksForSetCurrentUserTests() {
		local.mocked = {};
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User").$("getUserId", 111);
		variables.CUT
			.$property(propertyName = "USER_KEY", propertyScope = "variables", mock = "the_user_key")
			.$("getCurrentStorage", {});
		return local.mocked;
	}

	function test_setCurrentUser_adds_user_to_storage() {
		local.mocked = getMocksForSetCurrentUserTests();
		variables.CUT.setCurrentUser(User = variables.mocked.userObj);
		$assert.isTrue(variables.CUT.$once("getCurrentStorage"));
	}

	private function setupResetPasswordTests() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User")
			.$("getEmail")
			.$("setPassword");
		variables.mocked.userGatewayObj
			.$("newUser", variables.mocked.userObj, FALSE)
			.$("getUserByEmail", variables.mocked.userObj, FALSE);
		variables.mocked.userServiceObj.$("newPassword", "");
		variables.CUT
			.$("populate")
			.$("setCurrentUser");
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("addFailure")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
		variables.mocked.notificationServiceObj.$("send");
	}

}
