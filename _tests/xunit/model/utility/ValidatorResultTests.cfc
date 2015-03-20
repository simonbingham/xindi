component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.utility.ValidatorResult");
	}

	// Tests

	// getMessageType() tests

	private struct function getMocksForGetMessageTypeTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "messageType", propertyScope = "variables", mock = "the message type");
		return local.mocked;
	}

	function test_getMessageType_returns_message_type() {
		local.mocked = getMocksForGetMessageTypeTests();
		local.expected = "the message type";
		local.actual = variables.CUT.getMessageType();
		$assert.isEqual(local.expected, local.actual);
	}

	// hasMessage() tests

	private struct function getMocksForHasMessageTests() {
		local.mocked = {};
		variables.CUT.$("getMessage", "the message");
		return local.mocked;
	}

	function test_hasMessage_returns_true_if_message_exists() {
		local.mocked = getMocksForHasMessageTests();
		local.actual = variables.CUT.hasMessage();
		$assert.isTrue(local.actual);
	}

	function test_hasMessage_returns_false_if_message_does_not_exist() {
		local.mocked = getMocksForHasMessageTests();
		variables.CUT.$("getMessage", "");
		local.actual = variables.CUT.hasMessage();
		$assert.isFalse(local.actual);
	}

	// setErrorMessage() tests

	private struct function getMocksForSetErrorMessageTests() {
		local.mocked = {};
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result").$("setIsSuccess");
		variables.CUT
			.$property(propertyName = "message", propertyScope = "variables", mock = "")
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "")
			.$property(propertyName = "super", propertyScope = "variables", mock = variables.mocked.resultObj);
		return local.mocked;
	}

	function test_setErrorMessage_sets_error_message() {
		local.mocked = getMocksForSetErrorMessageTests();
		variables.CUT.setErrorMessage(message = "the message");
		local.expected = "danger";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	// setInfoMessage() tests

	private struct function getMocksForSetInfoMessageTests() {
		local.mocked = {};
		variables.CUT
			.$property(propertyName = "message", propertyScope = "variables", mock = "")
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "");
		return local.mocked;
	}

	function test_setInfoMessage_sets_info_message() {
		local.mocked = getMocksForSetInfoMessageTests();
		variables.CUT.setInfoMessage(message = "the message");
		local.expected = "info";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	// setSuccessMessage() tests

	private struct function getMocksForSetSuccessMessageTests() {
		local.mocked = {};
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("ValidateThis.util.Result")
			.$("setIsSuccess")
			.$("setSuccessMessage");
		variables.CUT
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "")
			.$property(propertyName = "super", propertyScope = "variables", mock = variables.mocked.resultObj);
		return local.mocked;
	}

	function test_setSuccessMessage_sets_success_message() {
		local.mocked = getMocksForSetSuccessMessageTests();
		variables.CUT.setSuccessMessage(message = "the message");
		local.expected = "success";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	// setWarningMessage() tests

	private struct function getMocksForSetWarningMessageTests() {
		local.mocked = {};
		variables.CUT
			.$property(propertyName = "message", propertyScope = "variables", mock = "")
			.$property(propertyName = "messageType", propertyScope = "variables", mock = "");
		return local.mocked;
	}

	function test_setWarningMessage_sets_warning_message() {
		variables.CUT.setWarningMessage(message = "the message");
		local.expected = "warning";
		local.actual = variables.CUT.$getProperty(name = "messageType", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

}
