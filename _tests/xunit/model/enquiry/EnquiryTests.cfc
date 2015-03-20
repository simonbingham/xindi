component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.enquiry.Enquiry");
	}

	// Tests

	// getDisplayMessage() tests

	private struct function getMocksForGetDisplayMessageTests() {
		local.mocked = {};
		local.message = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit.#Chr(10)#These men promptly escaped from a maximum security stockade to the Los Angeles underground.#Chr(10)#Today, still wanted by the government, they survive as soldiers of fortune.";
		variables.CUT.$property(propertyName = "message", propertyScope = "variables", mock = local.message);
		return local.mocked;
	}

	function test_getDisplayMessage_returns_expected_result() {
		local.mocked = getMocksForGetDisplayMessageTests();
		local.expected = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit.<br /><br />These men promptly escaped from a maximum security stockade to the Los Angeles underground.<br /><br />Today, still wanted by the government, they survive as soldiers of fortune.";
		local.actual = variables.CUT.getDisplayMessage();
		$assert.isEqual(local.expected, local.actual);
	}

	// isPersisted() tests

	private struct function getMocksForIsPersistedTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "enquiryId", propertyScope = "variables", mock = 111);
		return local.mocked;
	}

	function test_isPersisted_returns_true_when_enquiry_is_persisted() {
		local.mocked = getMocksForIsPersistedTests();
		local.actual = variables.CUT.isPersisted();
		$assert.isTrue(local.actual);
	}

	// isRead() tests

	private struct function getMocksForIsReadTests() {
		local.mocked = {};
		variables.CUT.$property(propertyName = "read", propertyScope = "variables", mock = TRUE);
		return local.mocked;
	}

	function test_isRead_returns_true_when_enquiry_is_read() {
		local.mocked = getMocksForIsReadTests();
		local.actual = variables.CUT.isRead();
		$assert.isTrue(local.actual);
	}

	function test_isRead_returns_false_when_enquiry_is_not_read() {
		local.mocked = getMocksForIsReadTests();
		variables.CUT.$property(propertyName = "read", propertyScope = "variables", mock = FALSE);
		local.actual = variables.CUT.isRead();
		$assert.isFalse(local.actual);
	}

}
