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

	function testBlankPasswordDoesNotChangeHashedPassword(){
		CUT.setPassword( "admin" );
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", CUT.getPassword() );
		CUT.setPassword( "" );
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", CUT.getPassword() );
	}

	function testGetFullName(){
		CUT.setFirstName( "john" );
		CUT.setLastName( "whish" );
		assertEquals( "john whish", CUT.getFullname() );
	}

	function testIsNotUniqueEmail(){
		CUT.setEmail( "foo@bar.moo" );
		var result = CUT.IsEmailUnique();
		assertEquals( false, result.issuccess );
	}

	function testIsNotUniqueUsername(){
		CUT.setUsername( "aliaspooryorik" );
		var result = CUT.isUsernameUnique();
		assertEquals( false, result.issuccess );
	}
	
	function testIsUniqueEmail(){
		CUT.setEmail( "asdhakjsdas@badkjasld.com" );
		var result = CUT.IsEmailUnique();
		assertEquals( true, result.issuccess );
	}

	function testIsUniqueUsername(){
		CUT.setUsername( "sdjalkdjakdjasd" );
		var result = CUT.isUsernameUnique();
		assertEquals( true, result.issuccess );
	}

	function testPasswordHashing(){
		CUT.setPassword( "admin" );
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", CUT.getPassword() );
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.user.User(); 
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