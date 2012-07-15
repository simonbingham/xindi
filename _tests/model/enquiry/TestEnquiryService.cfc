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
			
	// ------------------------ INTEGRATION TESTS ------------------------ //

	function testDeleteEnquiryWhereEnquiryDoesNotExist(){
		var deleteenquiryresult = CUT.deleteEnquiry( enquiryid=4 );
		var result = deleteenquiryresult.getIsSuccess();
		assertFalse( result );
	}
		
	function testDeleteEnquiryWhereEnquiryExists(){
		var deleteenquiryresult = CUT.deleteEnquiry( enquiryid=1 );
		var result = deleteenquiryresult.getIsSuccess();
		assertTrue( result );
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
		var Enquiry = CUT.getEnquiry( enquiryid=2 );
		var result = Enquiry.isPersisted();
		assertTrue( result );
	}

	function testGetUnreadCount(){
		var result = CUT.getUnreadCount();
		assertEquals( 3, result );
	}
	
	function testMarkReadForAllEnquiries(){
		var markallreadresult = CUT.markRead();
		var result = markallreadresult.getIsSuccess();
		assertTrue( result );
	}
	
	function testMarkReadForSingleEnquiry(){
		var markreadresult = CUT.markRead( enquiryid=3 );
		var result = markreadresult.getIsSuccess();
		assertTrue( result );
	}
	
	function testNewEnquiry(){
		var Enquiry = CUT.newEnquiry();
		var result = Enquiry.isPersisted();
		assertFalse( result );
	}
	
	function testSendEnquiryWhereEnquiryIsInvalid(){
		var sendenquiryresult = CUT.sendEnquiry( properties={ firstname="", lastname="", email="", message="" }, config={ subject="Test", emailto="example@example.com" }, emailtemplatepath="../../public/views/enquiry/email.cfm" );
		var result = sendenquiryresult.getIsSuccess();
		assertFalse( result );
	}

	function testSendEnquiryWhereEnquiryIsValid(){
		var sendenquiryresult = CUT.sendEnquiry( properties={ firstname="Test", lastname="User", email="example@example.com", message="This is a test message." }, config={ subject="Test", emailto="example@example.com" }, emailtemplatepath="../../public/views/enquiry/email.cfm" );
		var result = sendenquiryresult.getIsSuccess();
		assertTrue( result );
	}
 
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.enquiry.EnquiryService();
		var validatorconfig = { definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult" };
		Validator = new ValidateThis.ValidateThis( validatorconfig );
		CUT.setValidator( Validator );
		var EnquiryGateway = new model.enquiry.EnquiryGateway();
		CUT.setEnquiryGateway( EnquiryGateway );
		var NotificationService = new model.utility.NotificationService();
		CUT.setNotificationService( NotificationService );
		
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