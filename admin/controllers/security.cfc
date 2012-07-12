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

	property name="SecurityService" setter="true" getter="false";
	property name="UserService" setter="true" getter="false";

	/*
	 * Public methods
	 */	
	 
	void function init( required any fw ){
		variables.fw = arguments.fw;
	}

	void function default( required struct rc ){
		rc.loggedin = variables.SecurityService.hasCurrentUser( session );
		if( rc.loggedin ){
			variables.fw.redirect( "main" );
		}else{
			rc.User = variables.UserService.newUser();
			rc.Validator = variables.UserService.getValidator( rc.User );
			if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
		}
	}
	
	void function login( required struct rc ){
		param name="rc.username" default="";
		param name="rc.password" default="";
		var properties = { username=rc.username, password=rc.password };
		rc.result = variables.SecurityService.loginUser( session, properties );
		if( rc.result.getIsSuccess() ) variables.fw.redirect( "main", "result" );
		else variables.fw.redirect( "security", "result" );
	}

	void function logout( required struct rc ){
		rc.result = variables.SecurityService.deleteCurrentUser( session );
		variables.fw.redirect( "security", "result" );
	}
	
	void function password( required struct rc ){
		rc.User = variables.UserService.newUser();
		rc.Validator = variables.UserService.getValidator( rc.User );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
	}
	
	void function resetpassword( required struct rc ){
		param name="rc.username" default="";
		var properties = { username=rc.username };
		var emailtemplatepath = "../../admin/views/security/email.cfm";
		rc.result = variables.SecurityService.resetPassword( properties, rc.config.name, rc.config.security, emailtemplatepath );
		if( rc.result.getIsSuccess() ) variables.fw.redirect( "security", "result" );
		else variables.fw.redirect( "security.password", "result" );
	}

}