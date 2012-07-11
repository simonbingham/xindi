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

component accessors="true" extends="model.abstract.BaseGateway"{

	/*
	 * Public methods
	 */

	void function deleteEnquiry( required Enquiry theEnquiry ){
		delete( arguments.theEnquiry );
	}
	
	array function getEnquiries( numeric maxresults=0 ){
		var ormoptions = {};
		if( arguments.maxresults ) ormoptions.maxresults = arguments.maxresults;	
		return EntityLoad( "Enquiry", {}, "unread DESC, created DESC", ormoptions );
	}	

	Enquiry function getEnquiry( required numeric enquiryid ){
		return get( "Enquiry", arguments.enquiryid );
	}

	numeric function getUnreadCount(){
		return ORMExecuteQuery( "select count( * ) from Enquiry where unread = true", true );
	}
	 	
	void function markRead( theEnquiry="" ){
		if( IsObject( arguments.theEnquiry ) ){
			arguments.theEnquiry.setRead();
			save( arguments.theEnquiry );
		}else{
			ORMExecuteQuery( "update Enquiry set unread=false" );		
		}
	}
	
	Enquiry function newEnquiry(){
		return new( "Enquiry" );
	}
	
	Enquiry function saveEnquiry( required Enquiry theEnquiry ){
        return save( arguments.theEnquiry );
	}
	
}