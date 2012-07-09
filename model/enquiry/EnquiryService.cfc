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

component accessors="true"{

	/*
	 * Dependency injection
	 */	
	
	property name="EnquiryGateway" getter="false";

	/*
	 * Public methods
	 */

	function deleteEnquiry( required enquiryid ){
		transaction{
			var result = variables.EnquiryGateway.deleteEnquiry( enquiryid=Val( arguments.enquiryid ) );
		}
		return result;
	}
	
	array function getEnquiries( maxresults=0 ){
		return variables.EnquiryGateway.getEnquiries( maxresults=Val( arguments.maxresults ) );
	}	

	function getEnquiryByID( required enquiryid ){
		return variables.EnquiryGateway.getEnquiryByID( enquiryid=Val( arguments.enquiryid ) );
	}

	numeric function getUnreadCount(){
		return variables.EnquiryGateway.getUnreadCount();		
	}	
	 	
	function getValidator( required any Enquiry ){
		return variables.EnquiryGateway.getValidator( argumentCollection=arguments );		
	}	
	
	function markRead( numeric enquiryid=0 ){
		transaction{
			var result = variables.EnquiryGateway.markRead( enquiryid=Val( arguments.enquiryid ) );
		}
		return result;
	}	
	
	function newEnquiry(){
		return variables.EnquiryGateway.newEnquiry();		
	}
	
	function sendEnquiry( required struct properties, required struct config, required string emailtemplatepath ){
		transaction{
			var result = variables.EnquiryGateway.sendEnquiry( argumentCollection=arguments );
		}
		return result;
	}
	
}