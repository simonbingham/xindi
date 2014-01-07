component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function testDeleteEnquiry() {
		var enquiries = EntityLoad("Enquiry");
		var enquirycount = ArrayLen(enquiries);
		assertEquals(3, enquirycount);
		var Enquiry = EntityLoadByPK("Enquiry", 1);
		transaction{
			CUT.deleteEnquiry(Enquiry);
		}
		enquiries = EntityLoad("Enquiry");
		enquirycount = ArrayLen(enquiries);
		assertEquals(2, enquirycount);
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
		var unreadenquiries = EntityLoad("Enquiry", {read=false});
		var result = ArrayLen(unreadenquiries);
		assertEquals(3, result);
		transaction{
			CUT.markRead();
		}
		unreadenquiries = EntityLoad("Enquiry", {read=false});
		result = ArrayLen(unreadenquiries);
		assertEquals(0, result);
	}

	function testMarkReadForSingleEnquiry() {
		var unreadenquiries = EntityLoad("Enquiry", {read=false});
		var result = ArrayLen(unreadenquiries);
		assertEquals(3, result);
		var Enquiry = EntityLoadByPK("Enquiry", 1);
		transaction{
			CUT.markRead(Enquiry);
		}
		unreadenquiries = EntityLoad("Enquiry", {read=false});
		result = ArrayLen(unreadenquiries);
		assertEquals(2, result);
	}

	function testNewEnquiry() {
		var Enquiry = CUT.newEnquiry();
		var result = Enquiry.isPersisted();
		assertFalse(result);
	}

	function testSaveEnquiry() {
		var enquiries = EntityLoad("Enquiry");
		var result = ArrayLen(enquiries);
		assertEquals(3, result);
		var Enquiry = EntityNew("Enquiry");
		Enquiry.setName("foo bar");
		Enquiry.setEmail("example@example.com");
		Enquiry.setMessage("foobar");
		CUT.saveEnquiry(Enquiry);
		enquiries = EntityLoad("Enquiry");
		result = ArrayLen(enquiries);
		assertEquals(4, result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.enquiry.EnquiryGateway();

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
