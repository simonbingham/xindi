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
	
	function testDeleteCurrentUser(){
		assertFalse( CUT.hasCurrentUser() );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User );
		assertTrue( CUT.hasCurrentUser() );
		CUT.deleteCurrentUser();
		assertFalse( CUT.hasCurrentUser() );
	}
	
	function testHasCurrentUser(){
		assertFalse( CUT.hasCurrentUser() );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User );
		assertTrue( CUT.hasCurrentUser() );
	}
	
	function testIsAllowedForSecureAction(){
		assertFalse( CUT.isAllowed( "admin:pages" ) );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User );
		assertTrue( CUT.isAllowed( "admin:pages" ) );
		CUT.deleteCurrentUser();
		assertFalse( CUT.isAllowed( "admin:pages" ) );
	}	

	function testIsAllowedForUnsecureAction(){
		assertTrue( CUT.isAllowed( "public:" ) );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User );
		assertTrue( CUT.isAllowed( "public:" ) );
		CUT.deleteCurrentUser();
		assertTrue( CUT.isAllowed( "public:" ) );		
	}	
	
	function testLoginUserForValidUser(){
		var properties = { username="admin", password="admin" };
		result = CUT.loginUser( properties );
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}

	function testLoginUserForInvalidUser(){
		var properties = { username="foo", password="bar" };
		result = CUT.loginUser( properties );
		assertTrue( StructKeyExists( result.messages, "error" ) );
	}
	
	function testResetPassword(){
		fail( "test not yet implemented" );
	}
	
	function testSetCurrentUser(){
		assertFalse( CUT.hasCurrentUser() );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User );
		assertTrue( CUT.hasCurrentUser() );
	}

	// ------------------------ IMPLICIT ------------------------ //
	 
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.security.SecurityService();
		
		var UserService = new model.user.UserService();
		var UserGateway = new model.user.UserGateway();
		UserService.setUserGateway( UserGateway );
		CUT.setUserService( UserService );
		var config = { security = { whitelist="^admin:security,^public:" } };
		CUT.setConfig( config );
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
			INSERT INTO users ( user_id, user_firstname, user_lastname, user_email, user_username, user_password, user_created, user_updated ) 
			VALUES ( 1, 'Default', 'User', 'enquiries@getxindi.com', 'admin', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB', '2012-04-22 08:39:07', '2012-04-22 08:39:09' );
		" );
		q.execute();		
	}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){}

}