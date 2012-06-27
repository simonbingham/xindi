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

	// ------------------------ TESTS ------------------------ //
	
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
		var LoginUser = mock( "model.user.User" );
		LoginUser.getUsername().returns( "" );
		LoginUser.getEmail().returns( "foo@bar.moo" );
		LoginUser.getPassword().returns( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB" );
		result = CUT.getUserByCredentials( LoginUser );
		assertEquals( false, IsNull( result ) );
		assertEquals( "foo@bar.moo", result.getEmail() );
	}

	function testGetUserByCredentialsReturnsUserForCorrectCredentialsByUsername(){
		var LoginUser = mock( "model.user.User" );
		LoginUser.getUsername().returns( "aliaspooryorik" );
		LoginUser.getEmail().returns( "" );
		LoginUser.getPassword().returns( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB" );
		result = CUT.getUserByCredentials( LoginUser );
		assertEquals( false, IsNull( result ) );
		assertEquals( "foo@bar.moo", result.getEmail() );
	}

	function testGetUserByCredentialsReturnsNullForInCorrectCredentials(){
		var LoginUser = mock( "model.user.User" );
		LoginUser.getUsername().returns( "aliaspooryorik" );
		LoginUser.getEmail().returns( "" );
		LoginUser.getPassword().returns( "1111111111111111111111111111111111111111111111111111111111111111" );		
		result = CUT.getUserByCredentials( LoginUser );
		assertEquals( true, IsNull( result ) );
	}
	
	function testGetUserByEmailOrUsernameWhereEmailIsSpecified(){
		var User = CUT.newUser();
		User.setEmail( "foo@bar.moo" );
		User = CUT.getUserByEmailOrUsername( User );
		assertTrue( User.isPersisted() );
	}

	function testGetUserByEmailOrUsernameWhereUsernameIsSpecified(){
		var User = CUT.newUser();
		User.setUsername( "aliaspooryorik" );
		User = CUT.getUserByEmailOrUsername( User );
		assertTrue( User.isPersisted() );
	}
	
	function testGetUsers(){
		var users = CUT.getUsers();
		assertTrue( ArrayLen( users ) == 1 );
	}	
	
	function testGetValidator(){
		makePublic( CUT, "newUser" );
		var User = CUT.newUser();
		assertTrue( IsObject( CUT.getValidator( User ) ) );
	}
	
	function testNewUser(){
		var User = CUT.newUser();
		assertFalse( User.isPersisted() );
	}

	function testSaveUserWhereUserIsInvalid(){
		var properties = { firstname="Simon", lastname="Bingham", email="foobarfoobarcom", username="foo", password="bar"  };
		var result = CUT.saveUser( properties, "create" );
		assertTrue( StructKeyExists( result.messages, "error" ) );
	}
	
	function testSaveUserWhereUserIsValid(){
		var properties = { firstname="Simon", lastname="Bingham", email="foobar@foobar.com", username="foo", password="bar"  };
		var result = CUT.saveUser( properties, "create" );
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}	

	// ------------------------ IMPLICIT ------------------------ //
	 
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.user.UserGateway(); 

		var ValidateThisConfig = { definitionPath="/model/", JSIncludes=false };
		var Validator = new ValidateThis.ValidateThis( ValidateThisConfig );
		CUT.setValidator( Validator );		
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){}
	
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests(){
		var q = new Query();
		q.setSQL( "DROP TABLE Users;");
		q.execute();		
		ORMReload();
		q = new Query();
		q.setSQL( "
			insert into Users (
				user_id, user_firstname, user_lastname, user_email, user_username, user_password
			) values (
				1, 'John', 'Whish', 'foo@bar.moo', 'aliaspooryorik', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB'
			)
		" );
		q.execute();
	}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){}

}