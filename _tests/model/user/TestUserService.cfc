component extends="mxunit.framework.TestCase" {

	// ------------------------ INTEGRATION TESTS ------------------------ //

	function testDeleteUserWhereUserDoesNotExist() {
		var deleteuserresult = CUT.deleteUser(2);
		var result = deleteuserresult.getIsSuccess();
		assertFalse(result);
	}

	function testDeleteUserWhereUserExists() {
		var deleteuserresult = CUT.deleteUser(1);
		var result = deleteuserresult.getIsSuccess();
		assertTrue(result);
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

	function testGetUserByCredentialsReturnsUserForCorrectCredentialsByEmail() {
		var User = new model.user.User();
		User.setEmail("example@example.com");
		User.setPassword("admin");
		var User = CUT.getUserByCredentials(User);
		var result = IsNull(User);
		assertFalse(result);
		result = User.getEmail();
		assertEquals("example@example.com", result);
	}

	function testGetUserByCredentialsReturnsNullForIncorrectCredentials() {
		var User = new model.user.User();
		User.setEmail("");
		User.setPassword("bar");
		var User = CUT.getUserByCredentials(User);
		var result = User.isPersisted();
		assertFalse(result);
	}

	function testGetUsers() {
		var users = CUT.getUsers();
		var result = ArrayLen(users);
		assertTrue(result);
	}

	function testGetValidator() {
		var User = new model.user.User();
		var result = IsObject(CUT.getValidator(User));
		assertTrue(result);
	}

	function testNewPassword() {
		var password = CUT.newPassword();
		var result = Len(password);
		assertEquals(8, result);
	}

	function testNewUser() {
		var User = CUT.newUser();
		var result = User.isPersisted();
		assertFalse(result);
	}

	function testSaveUserWhereUserIsInvalid() {
		var properties = {name="Simon Bingham", email="foobarfoobarcom", password="bar" };
		var saveuserresult = CUT.saveUser(properties, "create");
		var result = saveuserresult.getIsSuccess();
		assertFalse(result);
	}

	function testSaveUserWhereUserIsValid() {
		var properties = {name="Simon Bingham", email="foobar@foobar.com", password="bar" };
		var saveuserresult = CUT.saveUser(properties, "create");
		var result = saveuserresult.getIsSuccess();
		assertTrue(result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.user.UserService();
		var UserGateway = new model.user.UserGateway();
		CUT.setUserGateway(UserGateway);
		var validatorconfig = {definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult"};
		Validator = new ValidateThis.ValidateThis(validatorconfig);
		CUT.setValidator(Validator);

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
