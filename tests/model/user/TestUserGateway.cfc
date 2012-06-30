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

	// ------------------------ UNIT TESTS ------------------------ //
	
	function testDeleteUserWhereUserDoesNotExist(){
		result = CUT.deleteUser( 2 );
		assertTrue( StructKeyExists( result.messages, "error" ) );
	}

	function testDeleteUserWhereUserExists(){
		result = CUT.deleteUser( 1 );
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}

	function testGetUserByIDWhereUserDoesNotExist(){
		var User = CUT.getUserByID( 2 );
		assertFalse( User.isPersisted() );
	}	
	
	function testGetUserByIDWhereUserExists(){
		var User = CUT.getUserByID( 1 );
		assertTrue( User.isPersisted() );
	}	
	
	function testGetUserByCredentialsReturnsUserForCorrectCredentialsByEmail(){
		var $LoginUser = mock( "model.user.User" );
		$LoginUser.getUsername().returns( "" );
		$LoginUser.getEmail().returns( "enquiries@getxindi.com" );
		$LoginUser.getPassword().returns( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB" );
		result = CUT.getUserByCredentials( $LoginUser );
		assertEquals( false, IsNull( result ) );
		assertEquals( "enquiries@getxindi.com", result.getEmail() );
	}

	function testGetUserByCredentialsReturnsUserForCorrectCredentialsByUsername(){
		var $LoginUser = mock( "model.user.User" );
		$LoginUser.getUsername().returns( "admin" );
		$LoginUser.getEmail().returns( "" );
		$LoginUser.getPassword().returns( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB" );
		result = CUT.getUserByCredentials( $LoginUser );
		assertEquals( false, IsNull( result ) );
		assertEquals( "enquiries@getxindi.com", result.getEmail() );
	}

	function testGetUserByCredentialsReturnsNullForInCorrectCredentials(){
		var $LoginUser = mock( "model.user.User" );
		$LoginUser.getUsername().returns( "aliaspooryorik" );
		$LoginUser.getEmail().returns( "" );
		$LoginUser.getPassword().returns( "1111111111111111111111111111111111111111111111111111111111111111" );		
		result = CUT.getUserByCredentials( $LoginUser );
		assertEquals( true, IsNull( result ) );
	}
	
	function testGetUserByEmailOrUsernameWhereEmailIsSpecified(){
		var User = CUT.newUser();
		User.setEmail( "enquiries@getxindi.com" );
		User = CUT.getUserByEmailOrUsername( User );
		assertTrue( User.isPersisted() );
	}

	function testGetUserByEmailOrUsernameWhereUsernameIsSpecified(){
		var User = CUT.newUser();
		User.setUsername( "admin" );
		User = CUT.getUserByEmailOrUsername( User );
		assertTrue( User.isPersisted() );
	}
	
	function testGetUsers(){
		var users = CUT.getUsers();
		assertTrue( ArrayLen( users ) == 1 );
	}	
	
	function testGetValidator(){
		var $Validator = mock( "Validator" );
		var User = CUT.newUser();
		CUT.setValidator( $Validator );
		assertTrue( IsObject( CUT.getValidator( User ) ) );
	}
	
	function testNewUser(){
		var User = CUT.newUser();
		assertFalse( User.isPersisted() );
	}

	function testSaveUserWhereUserIsInvalid(){
		var properties = { firstname="Simon", lastname="Bingham", email="foobarfoobarcom", username="foo", password="bar"  };
		var $ValidationResult = mock( "Validator" ).hasErrors().returns( true );
		var $Validator = mock( "Validator" ).validate( theObject='{any}', Context='{string}' ).returns( $ValidationResult );
		CUT.setValidator( $Validator );		
		var result = CUT.saveUser( properties, "create" );
		assertTrue( StructKeyExists( result.messages, "error" ) );
	}
	
	function testSaveUserWhereUserIsValid(){
		var properties = { firstname="Simon", lastname="Bingham", email="foobar@foobar.com", username="foo", password="bar"  };
		var $ValidationResult = mock( "Validator" ).hasErrors().returns( false );
		var $Validator = mock( "Validator" ).validate( theObject='{any}', Context='{string}' ).returns( $ValidationResult );
		CUT.setValidator( $Validator );	
		var result = CUT.saveUser( properties, "create" );
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}	

	// ------------------------ IMPLICIT ------------------------ //
	 
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.user.UserGateway();
		
		// reinitialise ORM for the application (create database table)
		ORMReload();
		
		// insert test data into database
		var q = new Query();
		q.setSQL( "
			INSERT INTO Users ( user_id, user_firstname, user_lastname, user_email, user_username, user_password, user_created, user_updated ) 
			VALUES ( 1, 'Default', 'User', 'enquiries@getxindi.com', 'admin', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB', '2012-04-22 08:39:07', '2012-04-22 08:39:09' );
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
		ORMClearSession( "xindi_testsuite" );		
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