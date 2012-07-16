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

component accessors="true" extends="model.abstract.BaseService"{

	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	
	property name="EnquiryGateway" getter="false";
	property name="NotificationService" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete an enquiry
	 */	
	struct function deleteEnquiry( required enquiryid ){
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

	/**
	 * I return an array of enquiries
	 */		
	array function getEnquiries( maxresults=0 ){
		return variables.EnquiryGateway.getEnquiries( maxresults=Val( arguments.maxresults ) );
	}	

	/**
	 * I return an enquiry matching an id
	 */	
	Enquiry function getEnquiry( required enquiryid ){
		return variables.EnquiryGateway.getEnquiry( Val( arguments.enquiryid ) );
	}

	/**
	 * I return a count of unread enquiries
	 */	
	numeric function getUnreadCount(){
		return variables.EnquiryGateway.getUnreadCount();		
	}	
	
	/**
	 * I mark an enquiry, or enquiries, as read
	 */		
	struct function markRead( enquiryid=0 ){
		transaction{
			var result = variables.Validator.newResult();
			if( Len( Trim( arguments.enquiryid ) ) ){
				var Enquiry = variables.EnquiryGateway.getEnquiry( Val( arguments.enquiryid ) );
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
	
	/**
	 * I return a new enquiry
	 */		
	Enquiry function newEnquiry(){
		return variables.EnquiryGateway.newEnquiry();
	}

	/**
	 * I validate and send an enquiry
	 */		
	struct function sendEnquiry( required struct properties, required struct config, required string emailtemplatepath ){
		transaction{
			var emailtemplate = "";
			var Enquiry = variables.EnquiryGateway.newEnquiry(); 
			Enquiry.populate( arguments.properties );
			var result = variables.Validator.validate( theObject=Enquiry );
			if( !result.hasErrors() ){
				savecontent variable="emailtemplate"{ include arguments.emailtemplatepath; }
		        variables.NotificationService.send( arguments.config.subject, arguments.config.emailto, Enquiry.getEmail(), emailtemplate );
		        variables.EnquiryGateway.saveEnquiry( Enquiry );
		        result.setSuccessMessage( "Your enquiry has been sent." );
			}else{
				result.setErrorMessage( "Your enquiry could not be sent. Please amend the highlighted fields." );
			}
		}
		return result;
	}
	
}