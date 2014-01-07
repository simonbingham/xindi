component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function testDeleteUserWhereUserDoesNotExist() {
		var users = EntityLoad("User");
		var result = ArrayLen(users);
		assertEquals(1, result);
		var User = EntityNew("User");
		transaction{
			CUT.deleteUser(User);
		}
		users = EntityLoad("User");
		result = ArrayLen(users);
		assertEquals(1, result);
	}

	function testDeleteUserWhereUserExists() {
		var users = EntityLoad("User");
		var result = ArrayLen(users);
		assertEquals(1, result);
		var User = EntityLoadByPK("User", 1);
		transaction{
			CUT.deleteUser(User);
		}
		users = EntityLoad("User");
		result = ArrayLen(users);
		assertEquals(0, result);
	}

	function testGetUserWhereUserDoesNotExist() {
		var User = CUT.getUser(2);
		var result = User.isPersisted();
		assertFalse(result);
	}

	function testGetUserWhereUserExists() {
		var User = CUT.getUser(1);
		var result = User.isPersisted();
		assertTrue(result);
	}

	function testGetUserByCredentialsReturnsNewUserForIncorrectCredentials() {
		var User = EntityNew("User");
		User.setEmail("foo@bar.com");
		User.setPassword("bar");
		var getuserbycredentialsresult = CUT.getUserByCredentials(User);
		var result = getuserbycredentialsresult.isPersisted();
		assertFalse(result);
	}

	function testGetUserByCredentialsReturnsUserForCorrectCredentialsByEmail() {
		var User = EntityNew("User");
		User.setEmail("admin@getxindi.com");
		User.setPassword("admin");
		var getuserbycredentialsresult = CUT.getUserByCredentials(User);
		var result = getuserbycredentialsresult.isPersisted();
		assertTrue(result);
	}

	function testGetUsers() {
		var users = CUT.getUsers();
		var result = ArrayLen(users) == 1;
		assertTrue(result);
	}

	function testNewUser() {
		var User = CUT.newUser();
		var result = User.isPersisted();
		assertFalse(result);
	}

	function testSaveUser() {
		var users = EntityLoad("User");
		var result = ArrayLen(users);
		assertEquals(1, result);
		var User = EntityNew("User");
		User.setName("Simon Bingham");
		User.setEmail("foo@bar.com");
		User.setPassword("bar");
		CUT.saveUser(User);
		users = EntityLoad("User");
		result = ArrayLen(users);
		assertEquals(2, result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.user.UserGateway();

		// reinitialise ORM for the application (create database table)
		ORMReload();

		// insert test data into database
		var q = new Query();
		q.setSQL("
			INSERT INTO Users (user_name, user_email, user_password, user_created, user_updated)
			VALUES ('Default User', 'admin@getxindi.com', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB', '20120422', '20120422');
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

