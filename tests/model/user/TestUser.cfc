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

	function testBlankPasswordDoesNotChangeHashedPassword(){
		CUT.setPassword( "admin" );
		var result = CUT.getPassword();
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", result );
		CUT.setPassword( "" );
		result = CUT.getPassword();
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", result );
	}

	function testGetFullName(){
		CUT.setFirstName( "john" );
		CUT.setLastName( "whish" );
		var result = CUT.getFullname();
		assertEquals( "john whish", result );
	}

	function testIsNotUniqueEmail(){
		CUT.setEmail( "example@example.com" );
		var isemailuniqueresult = CUT.IsEmailUnique();
		var result = isemailuniqueresult.issuccess;
		assertEquals( false, result );
	}

	function testIsNotUniqueUsername(){
		CUT.setUsername( "admin" );
		var isusernameuniqueresult = CUT.isUsernameUnique();
		var result = isusernameuniqueresult.issuccess;
		assertEquals( false, result );
	}
	
	function testIsUniqueEmail(){
		CUT.setEmail( "asdhakjsdas@badkjasld.com" );
		var isemailuniqueresult = CUT.IsEmailUnique();
		var result = isemailuniqueresult.issuccess;
		assertEquals( true, result );
	}

	function testIsUniqueUsername(){
		CUT.setUsername( "sdjalkdjakdjasd" );
		var isusernameuniqueresult = CUT.isUsernameUnique();
		var result = isusernameuniqueresult.issuccess;
		assertEquals( true, result );
	}

	function testPasswordHashing(){
		CUT.setPassword( "admin" );
		var result = CUT.getPassword();
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", result );
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.user.User();
		
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