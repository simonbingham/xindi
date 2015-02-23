component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		variables.mocked.enquiryGatewayObj = variables.mockbox.createEmptyMock("model.enquiry.EnquiryGateway");
		variables.mocked.notificationServiceObj = variables.mockbox.createEmptyMock("model.utility.NotificationService");
		variables.mocked.validationFactoryObj = variables.mockbox.createEmptyMock("framework.ValidateThis.core.ValidationFactory");
	}

	function setup() {
		super.setup("model.enquiry.EnquiryService");

		variables.CUT
			.$property(propertyName = "EnquiryGateway", propertyScope = "variables", mock = variables.mocked.enquiryGatewayObj)
			.$property(propertyName = "NotificationService", propertyScope = "variables", mock = variables.mocked.notificationServiceObj)
			.$property(propertyName = "Validator", propertyScope = "variables", mock = variables.mocked.validationFactoryObj);
	}

	// Tests

	function test_deleteEnquiry_deletes_enquiry_if_it_is_persisted() {
		setupDeleteEnquiryTests();
		variables.mocked.enquiryObj.$("isPersisted", TRUE);
		variables.CUT.deleteEnquiry(enquiryid = 111);
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$once("deleteEnquiry"));
	}

	function test_deleteEnquiry_does_not_delete_enquiry_if_it_is_not_persisted() {
		setupDeleteEnquiryTests();
		variables.mocked.enquiryObj.$("isPersisted", FALSE);
		variables.CUT.deleteEnquiry(enquiryid = 111);
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$never("deleteEnquiry"));
	}

	function test_getEnquiries_calls_getEnquiries_gateway_method() {
		variables.mocked.enquiryGatewayObj.$("getEnquiries", []);
		local.actual = variables.CUT.getEnquiries();
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$once("getEnquiries"));
	}

	function test_getEnquiry_calls_getEnquiry_gateway_method() {
		variables.mocked.enquiryObj = variables.mockbox.createEmptyMock("model.enquiry.Enquiry");
		variables.mocked.enquiryGatewayObj.$("getEnquiry", variables.mocked.enquiryObj);
		local.actual = variables.CUT.getEnquiry(enquiryId = 111);
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$once("getEnquiry"));
	}

	function test_getUnreadCount_calls_getUnreadCount_gateway_method() {
		variables.mocked.enquiryGatewayObj.$("getUnreadCount", 111);
		local.actual = variables.CUT.getUnreadCount();
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$once("getUnreadCount"));
	}

	function test_markRead_sets_all_enquiries_as_read() {
		setupMarkReadTests();
		variables.CUT.markRead();
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$once("markRead"), "Expected markRead to be called once.");
		$assert.isEqual(variables.mocked.resultObj.$calllog().setSuccessMessage[1][1], "All messages have been marked as read.", "Expected success message to be set.");
	}

	function test_markRead_sets_enquiry_as_read() {
		setupMarkReadTests();
		variables.CUT.markRead(enquiryId = 111);
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$once("markRead"), "Expected markRead to be called once.");
		$assert.isEqual(variables.mocked.resultObj.$calllog().setSuccessMessage[1][1], "The message has been marked as read.", "Expected success message to be set.");
	}

	function test_markRead_does_not_set_enquiry_as_read_when_enquiry_does_not_exist() {
		setupMarkReadTests();
		variables.mocked.enquiryGatewayObj.$("getEnquiry");
		variables.CUT.markRead(enquiryId = 111);
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$never("markRead"), "Expected markRead to not be called.");
		$assert.isEqual(variables.mocked.resultObj.$calllog().setErrorMessage[1][1], "The message could not be marked as read.", "Expected error message to be set.");
	}

	function test_newEnquiry_calls_newEnquiry_gateway_method() {
		variables.mocked.enquiryObj = variables.mockbox.createEmptyMock("model.enquiry.Enquiry");
		variables.mocked.enquiryGatewayObj.$("newEnquiry", variables.mocked.enquiryObj, FALSE);
		local.actual = variables.CUT.newEnquiry();
		$assert.isTrue(variables.mocked.enquiryGatewayObj.$once("newEnquiry"));
	}

	function test_sendEnquiry_sends_an_enquiry_when_valid() {
		setupSendEnquiryTests();
		variables.mocked.resultObj.$("hasErrors", FALSE);
		variables.CUT.sendEnquiry(properties = {}, config = {subject = "the subject", emailTo = "the email address"}, emailTemplatePath = "../../public/views/enquiry/email.cfm");
		$assert.isTrue(variables.mocked.notificationServiceObj.$once("send"));
	}

	function test_sendEnquiry_does_not_send_enquiry_when_enquiry_is_invalid() {
		setupSendEnquiryTests();
		variables.mocked.resultObj.$("hasErrors", TRUE);
		variables.CUT.sendEnquiry(properties = {}, config = {subject = "the subject", emailTo = "the email address"}, emailTemplatePath = "../../public/views/enquiry/email.cfm");
		$assert.isTrue(variables.mocked.notificationServiceObj.$never("send"));
	}

	// Helper Methods

	private function setupDeleteEnquiryTests() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.mocked.enquiryObj = variables.mockbox.createEmptyMock("model.enquiry.Enquiry").$("getName", "the name");
		variables.mocked.enquiryGatewayObj
			.$("getEnquiry", variables.mocked.enquiryObj, FALSE)
			.$("deleteEnquiry");
	}

	private function setupMarkReadTests() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("newResult", variables.mocked.resultObj);
		variables.mocked.enquiryObj = variables.mockbox.createEmptyMock("model.enquiry.Enquiry").$("getName", "the name");
		variables.mocked.enquiryGatewayObj
			.$("getEnquiry", variables.mocked.enquiryObj, FALSE)
			.$("markRead");
	}

	private function setupSendEnquiryTests() {
		variables.mocked.resultObj = variables.mockbox.createEmptyMock("framework.ValidateThis.util.Result")
			.$("setSuccessMessage")
			.$("setErrorMessage");
		variables.mocked.validationFactoryObj.$("validate", variables.mocked.resultObj);
		variables.mocked.enquiryObj = variables.mockbox.createEmptyMock("model.enquiry.Enquiry")
			.$("getDisplayMessage")
			.$("getEmail", "the email");
		variables.mocked.enquiryGatewayObj
			.$("newEnquiry", variables.mocked.enquiryObj, FALSE)
			.$("saveEnquiry", variables.mocked.enquiryObj, FALSE);
		variables.mocked.notificationServiceObj.$("send");
	}

}
