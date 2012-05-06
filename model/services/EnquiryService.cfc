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

component accessors="true"
{

	/*
	 * Dependency injection
	 */	
	
	property name="Validator" getter="false";
	
	/*
	 * Public methods
	 */
	 	
	function init()
	{
		return this;
	}
	
	function getValidator( required any Enquiry )
	{
		return variables.Validator.getValidator( theObject=arguments.Enquiry );
	}	
	
	function newEnquiry(){
		return new model.beans.Enquiry();
	}
	
	struct function sendEnquiry( required struct properties, required struct config, required string emailtemplatepath ){
		var emailtemplate = "";
		var Enquiry = newEnquiry(); 
		Enquiry.populate( arguments.properties );
		var result = variables.Validator.validate( theObject=Enquiry );
		result.messages = {};
		if( !result.hasErrors() )
		{
			savecontent variable="emailtemplate" { include arguments.emailtemplatepath; }
			var Email = new mail();
		    Email.setSubject( arguments.config.enquirysettings.subject );
	    	Email.setTo( arguments.config.enquirysettings.emailto );
	    	Email.setFrom( Enquiry.getEmail() );
	    	Email.setBody( emailtemplate );
	    	Email.setType( "html" );
	        Email.send();
	        result.messages.success = "Your enquiry has been sent.";
		}
		else
		{
			result.messages.error = "Your enquiry could not be sent. Please amend the following:";
		}
		return result;
	}
	
}