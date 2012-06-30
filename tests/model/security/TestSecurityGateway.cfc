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
	
	function testDeleteCurrentUser(){
		assertFalse( CUT.hasCurrentUser() );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User=User );
		assertTrue( CUT.hasCurrentUser() );
		CUT.deleteCurrentUser();
		assertFalse( CUT.hasCurrentUser() );
	}
	
	function testHasCurrentUser(){
		assertFalse( CUT.hasCurrentUser() );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User=User );
		assertTrue( CUT.hasCurrentUser() );
	}
	
	function testIsAllowedForSecureAction(){
		assertFalse( CUT.isAllowed( action="admin:pages", whitelist="^admin:security,^public:" ) );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User=User );
		assertTrue( CUT.isAllowed( action="admin:pages", whitelist="^admin:security,^public:" ) );
		CUT.deleteCurrentUser();
		assertFalse( CUT.isAllowed( action="admin:pages", whitelist="^admin:security,^public:" ) );
	}	

	function testIsAllowedForUnsecureAction(){
		assertTrue( CUT.isAllowed( action="public:", whitelist="^admin:security,^public:" ) );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User=User );
		assertTrue( CUT.isAllowed( action="public:", whitelist="^admin:security,^public:" ) );
		CUT.deleteCurrentUser();
		assertTrue( CUT.isAllowed( action="public:", whitelist="^admin:security,^public:" ) );		
	}	
	
	function testLoginUserForValidUser(){
		var properties = { username="admin", password="admin" };
		result = CUT.loginUser( properties=properties );
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}

	function testLoginUserForInvalidUser(){
<<<<<<< HEAD
		var $User = mock( "model.user.User" ).getFirstName().returns( "" ).isPersisted().returns( false );
		var $UserGateway = mock( "model.user.UserGateway" ).getUserByCredentials( User="{any}" ).returns( $User ).newUser().returns( $User );
		CUT.setUserGateway( $UserGateway );
		var $ValidationResult = mock( "Validator" ).hasErrors().returns( true );
		var $Validator = mock( "Validator" ).validate( theObject="{any}", Context="{string}" ).returns( $ValidationResult );
=======
		var $User = mock().getFirstName().returns( "" ).isPersisted().returns( false );
		var $UserGateway = mock().getUserByCredentials( User="{any}" ).returns( $User ).newUser().returns( $User );
		CUT.setUserGateway( $UserGateway );
		var $ValidationResult = mock().hasErrors().returns( true );
		var $Validator = mock().validate( theObject="{any}", Context="{string}" ).returns( $ValidationResult );
>>>>>>> origin/develop
		CUT.setValidator( $Validator );
		result = CUT.loginUser( properties={ username="foo", password="bar" } );
		assertTrue( StructKeyExists( result.messages, "error" ) );
	}
	
	function testResetPassword(){
		fail( "test not yet implemented" );
	}
	
	function testSetCurrentUser(){
		assertFalse( CUT.hasCurrentUser() );
		var User = EntityLoadByPK( "User", 1 );
		CUT.setCurrentUser( User=User );
		assertTrue( CUT.hasCurrentUser() );
	}

	// ------------------------ IMPLICIT ------------------------ //
	 
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.security.SecurityGateway();
		
<<<<<<< HEAD
		ORMReload();
		var q = new Query();
		q.setSQL( "
			INSERT INTO Users ( user_id, user_firstname, user_lastname, user_email, user_username, user_password, user_created, user_updated ) 
=======
		var q = new Query();
		q.setSQL( "DROP TABLE Users;");
		q.execute();		
		ORMReload();
		q = new Query();
		q.setSQL( "
			INSERT INTO users ( user_id, user_firstname, user_lastname, user_email, user_username, user_password, user_created, user_updated ) 
>>>>>>> origin/develop
			VALUES ( 1, 'Default', 'User', 'enquiries@getxindi.com', 'admin', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB', '2012-04-22 08:39:07', '2012-04-22 08:39:09' );
		" );
		q.execute();		
	}
<<<<<<< HEAD
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){
		var q = new Query();
		q.setSQL( "DROP TABLE Users;");
		q.execute();
		
		ORMReload(); // TODO: error occurs in web browsers test if this is excluded - need to work out why this is happening
	}
	
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests(){}
=======
>>>>>>> origin/develop
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){}
	
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests(){}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){
		var q = new Query();
		q.setSQL( "DROP TABLE Users;");
		q.execute();		
	}

}