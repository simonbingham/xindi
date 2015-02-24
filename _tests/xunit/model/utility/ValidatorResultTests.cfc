component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.utility.ValidatorResult");
	}

	// Tests

	function test_getMessageType_returns_message_type() {
		variables.CUT.$property(propertyName = "messageType", propertyScope = "variables", mock = "the message type");
		local.expected = "the message type";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	function test_hasMessage_returns_true_if_message_exists() {
		variables.CUT.$("getMessage", "the message");
		local.actual = variables.CUT.hasMessage();
		$assert.isTrue(local.actual);
	}

	function test_hasMessage_returns_false_if_message_does_not_exist() {
		variables.CUT.$("getMessage", "");
		local.actual = variables.CUT.hasMessage();
		$assert.isFalse(local.actual);
	}

	function test_setErrorMessage_sets_error_message() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result").$("setIsSuccess");
		variables.CUT
			.$property(propertyName = "message", propertyScope = "variables", mock = "")
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "")
			.$property(propertyName = "super", propertyScope = "variables", mock = variables.mocked.resultObj)
			.setErrorMessage(message = "the message");
		local.expected = "error";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	function test_setInfoMessage_sets_info_message() {
		variables.CUT
			.$property(propertyName = "message", propertyScope = "variables", mock = "")
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "")
			.setInfoMessage(message = "the message");
		local.expected = "info";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	function test_setSuccessMessage_sets_success_message() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setIsSuccess")
			.$("setSuccessMessage");
		variables.CUT
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "")
			.$property(propertyName = "super", propertyScope = "variables", mock = variables.mocked.resultObj)
			.setSuccessMessage(message = "the message");
		local.expected = "success";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	function test_setWarningMessage_sets_warning_message() {
		variables.CUT
			.$property(propertyName = "message", propertyScope = "variables", mock = "")
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "")
			.setWarningMessage(message = "the message");
		local.expected = "warning";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

}
