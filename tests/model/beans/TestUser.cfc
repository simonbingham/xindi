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

component extends="mxunit.framework.TestCase"
{
	// ------------------------ TESTS ------------------------ // 
	function testPasswordHashing()
	{
		var User = EntityNew( "User" );
		User.setPassword( "admin" );
		
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", User.getPassword() );
	}

	function testBlankPasswordDoesNotChangeHashedPassword()
	{
		var User = EntityNew( "User" );
		User.setPassword( "admin" );
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", User.getPassword() );
		
		User.setPassword( "" );
		assertEquals( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB", User.getPassword() );
	}
	
	
	function testGetFullName()
	{
		var User = EntityNew( "User" );
		User.setFirstName( "john" );
		User.setLastName( "whish" );
		
		assertEquals( "john whish", User.getFullname() );
	}

	function testIsUniqueEmail()
	{
		var User = EntityNew( "User" );
		User.setEmail( "asdhakjsdas@badkjasld.com" );
		
		var result = User.IsEmailUnique();
		assertEquals( true, result.issuccess );
	}

	function testIsNotUniqueEmail()
	{
		var User = EntityNew( "User" );
		User.setEmail( "foo@bar.moo" );
		
		var result = User.IsEmailUnique();
		assertEquals( false, result.issuccess );
	}
	
	function testIsUniqueUsername()
	{
		var User = EntityNew( "User" );
		User.setUsername( "sdjalkdjakdjasd" );
		
		var result = User.isUsernameUnique();
		assertEquals( true, result.issuccess );
	}

	function testIsNotUniqueUsername()
	{
		var User = EntityNew( "User" );
		User.setUsername( "aliaspooryorik" );
		
		var result = User.isUsernameUnique();
		assertEquals( false, result.issuccess );
	}
	
	// ------------------------ IMPLICIT ------------------------ // 
	/**
	* this will run before every single test in this test case
	*/
	function setUp()
	{
	}
	/**
	* this will run after every single test in this test case
	*/
	function tearDown()
	{
	}
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests()
	{
		var q = new Query();
		q.setSQL( "
			insert into Users (
				user_firstname, user_lastname, user_email, user_username, user_password
			) 
			values (
				'John', 'Whish', 'foo@bar.moo', 'aliaspooryorik', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB'
			)
		" );
		q.execute();
	}
	/**
	* this will run once after all tests have been run
	*/
	function afterTests()
	{
		var q = new Query();
		q.setSQL( "delete from Users where user_username = 'aliaspooryorik'");
		q.execute();
	}
 
	
}