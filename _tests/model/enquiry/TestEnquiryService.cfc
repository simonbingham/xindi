component extends="mxunit.framework.TestCase" {

	// ------------------------ INTEGRATION TESTS ------------------------ //

	function testDeleteEnquiryWhereEnquiryDoesNotExist() {
		var deleteenquiryresult = CUT.deleteEnquiry(4);
		var result = deleteenquiryresult.getIsSuccess();
		assertFalse(result);
	}

	function testDeleteEnquiryWhereEnquiryExists() {
		var deleteenquiryresult = CUT.deleteEnquiry(1);
		var result = deleteenquiryresult.getIsSuccess();
		assertTrue(result);
	}

	function testGetEnquiries() {
		var enquiries = CUT.getEnquiries();
		var result = ArrayLen(enquiries);
		assertEquals(3, result);
	}

	function testGetEnquiriesWithMaxResults() {
		var enquiries = CUT.getEnquiries(maxresults=2);
		var result = ArrayLen(enquiries);
		assertEquals(2, result);
	}

	function testGetEnquiry() {
		var Enquiry = CUT.getEnquiry(2);
		var result = Enquiry.isPersisted();
		assertTrue(result);
	}

	function testGetUnreadCount() {
		var result = CUT.getUnreadCount();
		assertEquals(3, result);
	}

	function testMarkReadForAllEnquiries() {
		var markallreadresult = CUT.markRead();
		var result = markallreadresult.getIsSuccess();
		assertTrue(result);
	}

	function testMarkReadForSingleEnquiry() {
		var markreadresult = CUT.markRead(3);
		var result = markreadresult.getIsSuccess();
		assertTrue(result);
	}

	function testNewEnquiry() {
		var Enquiry = CUT.newEnquiry();
		var result = Enquiry.isPersisted();
		assertFalse(result);
	}

	function testSendEnquiryWhereEnquiryIsInvalid() {
		var sendenquiryresult = CUT.sendEnquiry({name="", email="", message=""}, {subject="Test", emailto="example@example.com"}, "../../public/views/enquiry/email.cfm");
		var result = sendenquiryresult.getIsSuccess();
		assertFalse(result);
	}

	function testSendEnquiryWhereEnquiryIsValid() {
		var sendenquiryresult = CUT.sendEnquiry({name="Test User", email="example@example.com", message="This is a test message."}, {subject="Test", emailto="example@example.com"}, "../../public/views/enquiry/email.cfm");
		var result = sendenquiryresult.getIsSuccess();
		assertTrue(result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.enquiry.EnquiryService();
		var validatorconfig = {definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult"};
		Validator = new ValidateThis.ValidateThis(validatorconfig);
		CUT.setValidator(Validator);
		var EnquiryGateway = new model.enquiry.EnquiryGateway();
		CUT.setEnquiryGateway(EnquiryGateway);
		var NotificationService = new model.utility.NotificationService();
		CUT.setNotificationService(NotificationService);

		// reinitialise ORM for the application (create database table)
		ORMReload();

		// insert test data into database
		var q = new Query();
		q.setSQL("
			INSERT INTO enquiries (enquiry_name, enquiry_email, enquiry_message, enquiry_read, enquiry_created)
			VALUES ('Simon Bingham', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', 0, '20120608');
			INSERT INTO enquiries (enquiry_name, enquiry_email, enquiry_message, enquiry_read, enquiry_created)
			VALUES ('John Whish', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', 0, '20120608');
			INSERT INTO enquiries (enquiry_name, enquiry_email, enquiry_message, enquiry_read, enquiry_created)
			VALUES ('Andy Beer', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', 0, '20120608');
		");
		q.execute();
	}

	/**
	* this will run after every single test in this test case
	*/
	function tearDown() {
		// destroy test data
		var q = new Query();
		q.setSQL("
			DROP TABLE Articles;
			DROP TABLE Enquiries;
			DROP TABLE Pages;
			DROP TABLE Users;
		");
		q.execute();

		// clear first level cache and remove any unsaved objects
		ORMClearSession();
	}

	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests() {}

	/**
	* this will run once after all tests have been run
	*/
	function afterTests() {}

}
