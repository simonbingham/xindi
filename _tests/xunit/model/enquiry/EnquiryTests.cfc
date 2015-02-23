component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.enquiry.Enquiry");
	}

	// Tests

	function test_getDisplayMessage_returns_expected_result() {
		local.message = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit.#Chr(10)#These men promptly escaped from a maximum security stockade to the Los Angeles underground.#Chr(10)#Today, still wanted by the government, they survive as soldiers of fortune.";
		variables.CUT.$property(propertyName = "message", propertyScope = "variables", mock = local.message);
		local.expected = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit.<br /><br />These men promptly escaped from a maximum security stockade to the Los Angeles underground.<br /><br />Today, still wanted by the government, they survive as soldiers of fortune.";
		local.actual = variables.CUT.getDisplayMessage();
		$assert.isEqual(local.expected, local.actual);
	}

	function test_isPersisted_returns_true_when_enquiry_is_persisted() {
		variables.CUT.$property(propertyName = "enquiryId", propertyScope = "variables", mock = 111);
		local.actual = variables.CUT.isPersisted();
		$assert.isTrue(local.actual);
	}

	function test_isRead_returns_true_when_enquiry_is_read() {
		variables.CUT.$property(propertyName = "read", propertyScope = "variables", mock = TRUE);
		local.actual = variables.CUT.isRead();
		$assert.isTrue(local.actual);
	}

	function test_isRead_returns_false_when_enquiry_is_not_read() {
		variables.CUT.$property(propertyName = "read", propertyScope = "variables", mock = FALSE);
		local.actual = variables.CUT.isRead();
		$assert.isFalse(local.actual);
	}

}
