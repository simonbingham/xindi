component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function testBlankPasswordDoesNotChangeHashedPassword() {
		CUT.setPassword("admin");
		var result = CUT.getPassword();
		assertEquals("1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", result);
		CUT.setPassword("");
		result = CUT.getPassword();
		assertEquals("1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", result);
	}

	function testIsEmailUniqueWhereEmailIsNotUnique() {
		CUT.setEmail("example@example.com");
		var isemailuniqueresult = CUT.IsEmailUnique();
		var result = isemailuniqueresult.issuccess;
		assertEquals(false, result);
	}

	function testIsUniqueEmailWhereEmailIsUnique() {
		CUT.setEmail("asdhakjsdas@badkjasld.com");
		var isemailuniqueresult = CUT.IsEmailUnique();
		var result = isemailuniqueresult.issuccess;
		assertEquals(true, result);
	}

	function testSetPassword() {
		CUT.setPassword("admin");
		var result = CUT.getPassword();
		assertEquals("1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.user.User();

		// reinitialise ORM for the application (create database table)
		ORMReload();

		// insert test data into database
		var q = new Query();
		q.setSQL("
			INSERT INTO Users (user_name, user_email, user_password, user_created, user_updated)
			VALUES ('Default User', 'example@example.com', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB', '20120422', '20120422');
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
