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

/**
* @mxunit:decorators mxunit.framework.decorators.TransactionRollbackDecorator
*/
component extends="mxunit.framework.TestCase"{
			
	// ------------------------ UNIT TESTS ------------------------ //
	
	function testDeleteEnquiryWhereEnquiryExists(){
		var result = CUT.deleteEnquiry( enquiryid=1 );
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}

	function testDeleteEnquiryWhereEnquiryDoesNotExist(){
		var result = CUT.deleteEnquiry( enquiryid=4 );
		assertTrue( StructKeyExists( result.messages, "error" ) );
	}
	
	function testGetEnquiries(){
		var enquiries = CUT.getEnquiries();
		assertEquals( 3, ArrayLen( enquiries ) );
	}

	function testGetEnquiriesWithMaxResults(){
		var enquiries = CUT.getEnquiries( maxresults=2 );
		assertEquals( 2, ArrayLen( enquiries ) );
	}
	
	function testGetEnquiryByID(){
		var Enquiry = CUT.getEnquiryByID( enquiryid=2 );
		assertTrue( Enquiry.isPersisted() );
	}

	function testGetUnreadCount(){
		assertEquals( 3, CUT.getUnreadCount() );
	}
	
	function testMarkAllRead(){
		var result = CUT.markAllRead();
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}
	
	function testMarkRead(){
		var result = CUT.markRead( enquiryid=3 );
		assertTrue( StructKeyExists( result.messages, "success" ) );
	}
	
	function testNewEnquiry(){
		var result = CUT.newEnquiry();
		assertFalse( result.isPersisted() );
	}
	
	function testSendEnquiry(){
		fail( "test not yet implemented" );
	}
 
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.enquiry.EnquiryGateway();
		
		ORMReload();
		var q = new Query();
		q.setSQL( "
			INSERT INTO enquiries (enquiry_id, enquiry_firstname, enquiry_lastname, enquiry_email, enquiry_message, enquiry_unread, enquiry_created) 
			VALUES
				(1, 'Simon', 'Bingham', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', true, '2012-06-08 13:46:47'),
				(2, 'John', 'Whish', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', true, '2012-06-08 13:46:57'),
				(3, 'Andy', 'Beer', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', true, '2012-06-08 13:47:04');
		" );
		q.execute();		
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){
		var q = new Query();
		q.setSQL( "DROP TABLE Enquiries;");
		q.execute();		
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