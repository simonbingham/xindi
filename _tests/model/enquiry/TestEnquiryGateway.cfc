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

	function testDeleteEnquiryDoesNotExists(){
		var enquiries = EntityLoad( "Enquiry" );
		var enquirycount = ArrayLen( enquiries );
		assertEquals( 3, enquirycount );
		var Enquiry = EntityNew( "Enquiry" );
		transaction{
			CUT.deleteEnquiry( Enquiry );
		}
		enquiries = EntityLoad( "Enquiry" );
		enquirycount = ArrayLen( enquiries );
		assertEquals( 3, enquirycount );
	}
	
	function testDeleteEnquiryWhereEnquiryExists(){
		var enquiries = EntityLoad( "Enquiry" );
		var enquirycount = ArrayLen( enquiries );
		assertEquals( 3, enquirycount );
		var Enquiry = EntityLoadByPK( "Enquiry", 1 );
		transaction{
			CUT.deleteEnquiry( Enquiry );
		}
		enquiries = EntityLoad( "Enquiry" );
		enquirycount = ArrayLen( enquiries );
		assertEquals( 2, enquirycount );
	}
		
	function testGetEnquiries(){
		var enquiries = CUT.getEnquiries();
		var result = ArrayLen( enquiries );
		assertEquals( 3, result );
	}

	function testGetEnquiriesWithMaxResults(){
		var enquiries = CUT.getEnquiries( maxresults=2 );
		var result = ArrayLen( enquiries );
		assertEquals( 2, result );
	}
	
	function testGetEnquiry(){
		var Enquiry = CUT.getEnquiry( 2 );
		var result = Enquiry.isPersisted();
		assertTrue( result );
	}

	function testGetUnreadCount(){
		var result = CUT.getUnreadCount();
		assertEquals( 3, result );
	}
	
	function testMarkReadForAllEnquiries(){
		var unreadenquiries = EntityLoad( "Enquiry", { read=false } );
		var result = ArrayLen( unreadenquiries );
		assertEquals( 3, result );
		transaction{
			CUT.markRead();
		}
		unreadenquiries = EntityLoad( "Enquiry", { read=false } );
		result = ArrayLen( unreadenquiries );
		assertEquals( 0, result );
	}
	
	function testMarkReadForSingleEnquiry(){
		var unreadenquiries = EntityLoad( "Enquiry", { read=false } );
		debug(unreadenquiries);
		var result = ArrayLen( unreadenquiries );
		assertEquals( 3, result );
		var Enquiry = EntityLoadByPK( "Enquiry", 1 );
		transaction{
			CUT.markRead( Enquiry );
		}
		unreadenquiries = EntityLoad( "Enquiry", { read=false } );
		result = ArrayLen( unreadenquiries );
		assertEquals( 2, result );
	}
	
	function testNewEnquiry(){
		var Enquiry = CUT.newEnquiry();
		var result = Enquiry.isPersisted();
		assertFalse( result );
	}

	function testSaveEnquiry(){
		var enquiries = EntityLoad( "Enquiry" );
		var enquirycount = ArrayLen( enquiries );
		assertEquals( 3, enquirycount );
		var Enquiry = EntityNew( "Enquiry" );
		Enquiry.setFirstName( "foo" );
		Enquiry.setLastName( "bar" );
		Enquiry.setEmail( "example@example.com" );
		Enquiry.setMessage( "foobar" );
		CUT.saveEnquiry( Enquiry );
		enquiries = EntityLoad( "Enquiry" );
		enquirycount = ArrayLen( enquiries );
		assertEquals( 4, enquirycount );
	}
 
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.enquiry.EnquiryGateway();
		
		// reinitialise ORM for the application (create database table)
		ORMReload();
		
		// insert test data into database
		var q = new Query();
		q.setSQL( "
			INSERT INTO enquiries (enquiry_id, enquiry_firstname, enquiry_lastname, enquiry_email, enquiry_message, enquiry_read, enquiry_created) 
			VALUES
				(1, 'Simon', 'Bingham', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', false, '2012-06-08 13:46:47'),
				(2, 'John', 'Whish', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', false, '2012-06-08 13:46:57'),
				(3, 'Andy', 'Beer', 'example@example.com', 'Phasellus ut tortor in erat dignissim eleifend at nec leo! Praesent vel lectus et elit condimentum hendrerit vel sit amet magna. Nunc luctus bibendum mi sed posuere. Pellentesque facilisis ullamcorper ultrices. Nulla eu dolor ac nunc laoreet tincidunt. Nulla et laoreet eros. Proin id pellentesque justo? Maecenas quis risus augue. Nulla commodo laoreet est nec mattis. Phasellus id dolor quam, id mattis mauris.', false, '2012-06-08 13:47:04');
		" );
		q.execute();		
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){
		// destroy test data
		var q = new Query();
		q.setSQL( "DROP TABLE Enquiries;");
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