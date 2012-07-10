/*
	Xindi - http://www.getxindi.com/
	
	Copyright (c) 2012, Simon Bingham
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

component extends="mxunit.framework.TestCase"{

	// ------------------------ INTEGRATION TESTS ------------------------ //
	
	function testDeleteUserWhereUserDoesNotExist(){
		var deleteuserresult = CUT.deleteUser( 2 );
		var result = deleteuserresult.getIsSuccess();
		assertFalse( result );
	}

	function testDeleteUserWhereUserExists(){
		var deleteuserresult = CUT.deleteUser( 1 );
		var result = deleteuserresult.getIsSuccess();
		assertTrue( result );
	}

	function testGetUserWhereUserDoesNotExist(){
		var User = CUT.getUser( 2 );
		var result = User.isPersisted();
		assertFalse( result );
	}	
	
	function testGetUserWhereUserExists(){
		var User = CUT.getUser( 1 );
		var result = User.isPersisted();
		assertTrue( result );
	}	
	
	function testGetUserByCredentialsReturnsUserForCorrectCredentialsByEmail(){
		var User = new model.user.User();
		User.setUsername( "" );
		User.setEmail( "example@example.com" );
		User.setPassword( "admin" );
		var User = CUT.getUserByCredentials( User );
		var result = IsNull( User );
		assertFalse( result );
		result = User.getEmail();
		assertEquals( "example@example.com", result );
	}

	function testGetUserByCredentialsReturnsUserForCorrectCredentialsByUsername(){
		var User = new model.user.User();
		User.setUsername( "admin" );
		User.setEmail( "" );
		User.setPassword( "admin" );
		var User = CUT.getUserByCredentials( User );
		var result = IsNull( User );
		assertFalse( result );
		result = User.getEmail();
		assertEquals( "example@example.com", result );
	}

	function testGetUserByCredentialsReturnsNullForInCorrectCredentials(){
		var User = new model.user.User();
		User.setUsername( "aliaspooryorik" );
		User.setEmail( "" );
		User.setPassword( "1111111111111111111111111111111111111111111111111111111111111111" );		
		var User = CUT.getUserByCredentials( User );
		var result = User.isPersisted();
		assertFalse( result );
	}
	
	function testGetUserByEmailOrUsernameWhereEmailIsSpecified(){
		var User = CUT.newUser();
		User.setEmail( "example@example.com" );
		User = CUT.getUserByEmailOrUsername( User );
		var result = User.isPersisted();
		assertTrue( result );
	}

	function testGetUserByEmailOrUsernameWhereUsernameIsSpecified(){
		var User = CUT.newUser();
		User.setUsername( "admin" );
		User = CUT.getUserByEmailOrUsername( User );
		var result = User.isPersisted();
		assertTrue( result );
	}
	
	function testGetUsers(){
		var users = CUT.getUsers();
		var result = ArrayLen( users ); 
		assertTrue( result );
	}	
	
	function testGetValidator(){
		var User = new model.user.User();
		var result = IsObject( CUT.getValidator( User ) );
		assertTrue( result );
	}
	
	function testNewUser(){
		var User = CUT.newUser();
		var result = User.isPersisted();
		assertFalse( result );
	}

	function testSaveUserWhereUserIsInvalid(){
		var properties = { firstname="Simon", lastname="Bingham", email="foobarfoobarcom", username="foo", password="bar"  };
		var saveuserresult = CUT.saveUser( properties, "create" );
		var result = saveuserresult.getIsSuccess();
		assertFalse( result );
	}
	
	function testSaveUserWhereUserIsValid(){
		var properties = { firstname="Simon", lastname="Bingham", email="foobar@foobar.com", username="foo", password="bar"  };
		var saveuserresult = CUT.saveUser( properties, "create" );
		var result = saveuserresult.getIsSuccess();
		assertTrue( result );
	}
	
	// ------------------------ IMPLICIT ------------------------ //
	 
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.user.UserService();
		var UserGateway = new model.user.UserGateway();
		CUT.setUserGateway( UserGateway );
		var validatorconfig = { definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult" };
		Validator = new ValidateThis.ValidateThis( validatorconfig );
		CUT.setValidator( Validator );
		
		// reinitialise ORM for the application (create database table)
		ORMReload();
		
		// insert test data into database
		var q = new Query();
		q.setSQL( "
			INSERT INTO Users ( user_id, user_firstname, user_lastname, user_email, user_username, user_password, user_created, user_updated ) 
			VALUES ( 1, 'Default', 'User', 'example@example.com', 'admin', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB', '2012-04-22 08:39:07', '2012-04-22 08:39:09' );
		" );
		q.execute();
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){
		// destroy test data
		var q = new Query();
		q.setSQL( "DROP TABLE Users;");
		q.execute();
		
		// clear first level cache and remove any unsaved objects
		ORMClearSession();		
	}
	
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests(){}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){}

}