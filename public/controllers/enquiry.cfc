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

component accessors="true" extends="abstract"  
{

	/*
	 * Dependency injection
	 */	

	property name="EnquiryService" setter="true" getter="false";
	
	/*
	 * Public methods
	 */		
	
	void function default( required struct rc ) {
		if( !StructKeyExists( rc, "Enquiry" ) ) rc.Enquiry = variables.EnquiryService.newEnquiry();
		rc.Validator = variables.EnquiryService.getValidator( rc.Enquiry );
		rc.MetaData.setMetaTitle( "Contact Us" ); 
		rc.MetaData.setMetaDescription( "" );
		rc.MetaData.setMetaKeywords( "" );		
	}
	
	void function send( required struct rc ) {
		param name="rc.firstname" default="";
 		param name="rc.lastname" default="";
 		param name="rc.email" default="";
 		param name="rc.message" default="";
		var properties = { firstname=rc.firstname, lastname=rc.lastname, email=rc.email, message=rc.message };
		var emailtemplatepath = "../../public/views/enquiry/email.cfm";
		rc.result = variables.EnquiryService.sendEnquiry( properties, application.config, emailtemplatepath );
		rc.messages = rc.result.messages;
		if( StructKeyExists( rc.messages, "success" ) )
		{
			variables.fw.redirect( "enquiry/thanks" );	
		}
		else
		{
			rc.Enquiry = rc.result.getTheObject();
			variables.fw.redirect( "enquiry", "messages,Enquiry,result" );
		}		
	}
	
}