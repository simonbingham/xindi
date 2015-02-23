component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.notificationServiceObj = variables.mockbox.createEmptyMock("model.utility.NotificationService");
		variables.mocked.userGatewayObj = variables.mockbox.createEmptyMock("model.user.UserGateway");
		variables.mocked.userServiceObj = variables.mockbox.createEmptyMock("model.user.UserService");
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("framework.ValidateThis.core.ValidationFactory");
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

	function test_deleteCurrentUser_deletes_current_user_when_user_is_in_storage() {
		setupDeleteCurrentUserTests();
		variables.CUT
			.$("hasCurrentUser", TRUE)
			.deleteCurrentUser();
		$assert.isTrue(variables.CUT.$once("getCurrentStorage"));
	}

	function test_deleteCurrentUser_does_not_delete_current_user_when_user_is_not_in_storage() {
		setupDeleteCurrentUserTests();
		variables.CUT
			.$("hasCurrentUser", FALSE)
			.deleteCurrentUser();
		$assert.isTrue(variables.CUT.$never("getCurrentStorage"));
	}

	function test_getCurrentStorage_returns_a_structure() {
		local.actual = variables.CUT.getCurrentStorage();
		$assert.typeOf("struct", local.actual);
	}

	function test_getCurrentUser_returns_current_user_when_user_is_in_storage() {
		setupGetCurrentUserTests();
		variables.CUT
			.$("hasCurrentUser", TRUE)
			.getCurrentUser();
		$assert.isTrue(variables.mocked.userGatewayObj.$once("getUser"));
	}

	function test_getCurrentUser_returns_current_user_when_user_is_not_in_storage() {
		setupGetCurrentUserTests();
		variables.CUT
			.$("hasCurrentUser", FALSE)
			.getCurrentUser();
		$assert.isTrue(variables.mocked.userGatewayObj.$never("getUser"));
	}

	function test_hasCurrentUser_returns_true_when_user_is_in_storage() {
		variables.CUT
			.$("getCurrentStorage", {the_user_key = ""})
			.$property(propertyName = "userKey", propertyScope = "variables", mock = "the_user_key");
		local.actual = variables.CUT.hasCurrentUser();
		$assert.isTrue(local.actual);
	}

	function test_hasCurrentUser_returns_false_when_user_is_not_in_storage() {
		variables.CUT
			.$("getCurrentStorage", {})
			.$property(propertyName = "userKey", propertyScope = "variables", mock = "the_user_key");
		local.actual = variables.CUT.hasCurrentUser();
		$assert.isFalse(local.actual);
	}

	function test_isAllowed_returns_true_when_user_is_not_in_storage_and_page_is_whitelisted() {
		variables.CUT
			.$property(propertyName = "config.security", propertyScope = "variables", mock = {whitelist = "the action"})
			.$("hasCurrentUser", FALSE);
		local.actual = variables.CUT.isAllowed(action = "the action");
		$assert.isTrue(local.actual);
	}

	function test_isAllowed_returns_false_when_user_is_not_in_storage_and_page_is_not_whitelisted() {
		variables.CUT
			.$property(propertyName = "config.security", propertyScope = "variables", mock = {whitelist = ""})
			.$("hasCurrentUser", FALSE);
		local.actual = variables.CUT.isAllowed(action = "the action");
		$assert.isFalse(local.actual);
	}

	function test_isAllowed_returns_true_when_user_is_in_storage() {
		variables.CUT
			.$property(propertyName = "config.security", propertyScope = "variables", mock = {whitelist = ""})
			.$("hasCurrentUser", TRUE);
		local.actual = variables.CUT.isAllowed(action = "the action");
		$assert.isTrue(local.actual);
	}

	function test_loginUser_adds_user_to_storage_when_user_is_persisted() {
		setupLoginUserTests();
		variables.mocked.userObj.$("isPersisted", TRUE);
		variables.CUT.loginUser(properties = {email = "", password = ""});
		$assert.isTrue(variables.CUT.$once("setCurrentUser"));

	}

	function test_loginUser_does_not_add_user_to_storage_when_user_is_not_persisted() {
		setupLoginUserTests();
		variables.mocked.userObj.$("isPersisted", FALSE);
		variables.CUT.loginUser(properties = {email = "", password = ""});
		$assert.isTrue(variables.CUT.$never("setCurrentUser"));
	}

	function test_resetPassword_resets_password_when_user_is_persisted() {
		setupResetPasswordTests();
		variables.mocked.userObj.$("isPersisted", TRUE);
		variables.CUT.resetPassword(properties = {email = ""}, name = "", config = {resetPasswordEmailSubject = "", resetPasswordEmailFrom = ""}, emailTemplatePath = "../../admin/views/security/email.cfm");
		$assert.isTrue(variables.mocked.userObj.$once("setPassword"));

	}

	function test_resetPassword_does_not_reset_password_when_user_is_not_persisted() {
		setupResetPasswordTests();
		variables.mocked.userObj.$("isPersisted", FALSE);
		variables.CUT.resetPassword(properties = {email = ""}, name = "", config = {resetPasswordEmailSubject = "", resetPasswordEmailFrom = ""}, emailTemplatePath = "../../admin/views/security/email.cfm");
		$assert.isTrue(variables.mocked.userObj.$never("setPassword"));
	}

	function test_setCurrentUser_adds_user_to_storage() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User").$("getUserId", 111);
		variables.CUT
			.$property(propertyName = "userKey", propertyScope = "variables", mock = "the_user_key")
			.$("getCurrentStorage", {})
			.setCurrentUser(User = variables.mocked.userObj);
		$assert.isTrue(variables.CUT.$once("getCurrentStorage"));
	}

	// Helper Methods

	private function setupDeleteCurrentUserTests() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.CUT.$("getCurrentStorage", {});
	}

	private function setupGetCurrentUserTests() {
		variables.CUT
			.$("getCurrentStorage", {the_user_key = "the user key"})
			.$property(propertyName = "userKey", propertyScope = "variables", mock = "the_user_key");
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj.$("getUser", variables.mocked.userObj, FALSE);
	}

	private function setupLoginUserTests() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User");
		variables.mocked.userGatewayObj
			.$("newUser", variables.mocked.userObj, FALSE)
			.$("getUserByCredentials", variables.mocked.userObj, FALSE);
		variables.CUT
			.$("populate")
			.$("setCurrentUser");
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("addFailure")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
	}

	private function setupResetPasswordTests() {
		variables.mocked.userObj = variables.mockbox.createEmptyMock("model.user.User").$("setPassword");
		variables.mocked.userGatewayObj
			.$("newUser", variables.mocked.userObj, FALSE)
			.$("getUserByEmail", variables.mocked.userObj, FALSE);
		variables.mocked.userServiceObj.$("newPassword", "");
		variables.CUT
			.$("populate")
			.$("setCurrentUser");
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("addFailure")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
		variables.mocked.notificationServiceObj.$("send");
	}

}
