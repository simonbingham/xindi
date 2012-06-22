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

	function testGetDisplayMessage(){
		// line feeds and carriage returns should be replaced
		var result = EntityNew( "Enquiry" );
		result.setMessage( "
		This
		
		is
		
		a" );
		assertTrue( FindNoCase( "<br />", result.getDisplayMessage() ) );
		// html should be escaped
		result = EntityNew( "Enquiry" );
		result.setMessage( "<script>alert('hack');</script>" );
		assertEquals( "&lt;script&gt;alert('hack');&lt;/script&gt;", result.getDisplayMessage() );		
	}
	 
	function testGetFullName(){
		var result = EntityNew( "Enquiry" );
		result.setFirstName( "simon" );
		result.setLastName( "bingham" );
		assertEquals( "simon bingham", result.getFullname() );
	}
	
	function testIsPersisted(){
		var result = EntityNew( "Enquiry" );
		assertFalse( result.isPersisted() );
	}
	
	function testIsUnread(){
		var result = EntityNew( "Enquiry" );
		assertTrue( result.isUnread() );
	}	

	function testSetRead(){
		var result = EntityNew( "Enquiry" );
		result.setRead( true );
		assertFalse( result.isUnread() );
	}	
	
	// ------------------------ IMPLICIT ------------------------ //
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){}
	
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
	function afterTests(){}
	
}