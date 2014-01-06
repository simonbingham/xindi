component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function testGetDisplayMessageHTMLShouldBeEscaped() {
		CUT.setMessage("<script>alert('hack');</script>");
		var result = CUT.getDisplayMessage();
		assertEquals("&lt;script&gt;alert('hack');&lt;/script&gt;", result);
	}

	function testGetDisplayMessageLineFeedsAndCarriageReturnsShouldBeReplaced() {
		CUT.setMessage("
		This

		is

		a");
		var result = FindNoCase("<br />", CUT.getDisplayMessage());
		assertTrue(result);
	}

	function testIsPersisted() {
		var result = CUT.isPersisted();
		assertFalse(result);
	}

	function testIsRead() {
		var result = CUT.isRead();
		assertFalse(result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.enquiry.Enquiry();
	}

	/**
	* this will run after every single test in this test case
	*/
	function tearDown() {}

	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests() {}

	/**
	* this will run once after all tests have been run
	*/
	function afterTests() {}

}
