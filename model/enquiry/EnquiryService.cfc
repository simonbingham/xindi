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
	property name="Validator" getter="false";

	/*
	 * Public methods
	 */

	function deleteEnquiry( required enquiryid ){
		transaction{
			var Enquiry = variables.EnquiryGateway.getEnquiry( Val( arguments.enquiryid ) );
			var result = variables.Validator.newResult();
			if( Enquiry.isPersisted() ){ 
				variables.EnquiryGateway.deleteEnquiry( Enquiry );
				result.setSuccessMessage( "The enquiry from &quot;#Enquiry.getFullName()#&quot; has been deleted." );
			}else{
				result.setErrorMessage( "The enquiry could not be deleted." );
			}
		}
		return result;
	}
	
	array function getEnquiries( maxresults=0 ){
		return variables.EnquiryGateway.getEnquiries( maxresults=Val( arguments.maxresults ) );
	}	

	function getEnquiry( required enquiryid ){
		return variables.EnquiryGateway.getEnquiry( enquiryid=Val( arguments.enquiryid ) );
	}

	numeric function getUnreadCount(){
		return variables.EnquiryGateway.getUnreadCount();		
	}	
	 	
	function getValidator( required Enquiry ){
		return variables.Validator.getValidator( theObject=arguments.Enquiry );
	}	
	
	function markRead( enquiryid=0 ){
		transaction{
			arguments.enquiryid = Val( arguments.enquiryid );
			var result = variables.Validator.newResult();
			if( arguments.enquiryid ){
				var Enquiry = variables.EnquiryGateway.getEnquiry( arguments.enquiryid );
				if( !IsNull( Enquiry ) ){
					variables.EnquiryGateway.markRead( Enquiry );
					result.setSuccessMessage( "The message has been marked as read." );
				}else{
					result.setErrorMessage( "The message could not be marked as read." );
				}
			}else{
				variables.EnquiryGateway.markRead();
				result.setSuccessMessage( "All messages have been marked as read." );
			}
		}
		return result;
	}	
	
	function newEnquiry(){
		return variables.EnquiryGateway.newEnquiry();
	}
	
	function sendEnquiry( required struct properties, required struct config, required string emailtemplatepath ){
		transaction{
			var emailtemplate = "";
			var Enquiry = variables.EnquiryGateway.newEnquiry(); 
			Enquiry.populate( arguments.properties );
			var result = variables.Validator.validate( theObject=Enquiry );
			if( !result.hasErrors() ){
				savecontent variable="emailtemplate"{ include arguments.emailtemplatepath; }
				var Email = new mail();
			    Email.setSubject( arguments.config.subject );
		    	Email.setTo( arguments.config.emailto );
		    	Email.setFrom( Enquiry.getEmail() );
		    	Email.setBody( emailtemplate );
		    	Email.setType( "html" );
		        Email.send();
		        variables.EnquiryGateway.saveEnquiry( Enquiry );
		        result.setSuccessMessage( "Your enquiry has been sent." );
			}else{
				result.setErrorMessage( "Your enquiry could not be sent. Please amend the highlighted fields." );
			}
		}
		return result;
	}
	
}