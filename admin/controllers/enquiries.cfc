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

component accessors="true" extends="abstract"{
	
	/*
	 * Public methods
	 */	

	void function before( required struct rc ){
		super.before( arguments.rc );
	}

	void function default( required struct rc ){
		rc.enquiries = variables.EnquiryService.getEnquiries();
		rc.unreadenquirycount = variables.EnquiryService.getUnreadCount();
	}
	
	void function delete( required struct rc ){
		param name="rc.enquiryid" default="0";
		rc.result = variables.EnquiryService.deleteEnquiry( enquiryid=rc.enquiryid );
		variables.fw.redirect( "enquiries", "result" );
	}	
	
	void function enquiry( required struct rc ){
		param name="rc.enquiryid" default="0";
		rc.Enquiry = variables.EnquiryService.getEnquiry( enquiryid=rc.enquiryid );
		if( !IsNull( rc.Enquiry ) ) variables.EnquiryService.markRead( enquiryid=rc.Enquiry.getEnquiryID() );
		else variables.fw.redirect( "main.notfound" );
	}
	
	void function markread( required struct rc ){
		rc.result = variables.EnquiryService.markRead();
		variables.fw.redirect( "enquiries", "result" );
	}	
	
}