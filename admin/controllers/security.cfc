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

	property name="SecurityService" setter="true" getter="false";
	property name="UserService" setter="true" getter="false";

	/*
	 * Public methods
	 */	
	 
	void function init( required any fw )
	{
		variables.fw = arguments.fw;
	}

	void function default( required rc )
	{
		rc.loggedin = variables.SecurityService.hasCurrentUser();
		if( rc.loggedin )
		{
			variables.fw.redirect( "main" );
		}
		else
		{
			rc.User = variables.UserService.newUser();
			rc.Validator = variables.UserService.getValidator( rc.User );
		}
	}
	
	void function login( required rc )
	{
		param name="rc.username" default="";
		param name="rc.password" default="";
		var properties = { username=rc.username, password=rc.password };
		var result = variables.SecurityService.loginUser( properties );
		rc.messages = result.messages;
		if( StructKeyExists( rc.messages, "success" ) ) variables.fw.redirect( "main", "messages" );
		else variables.fw.redirect( "security", "messages" );
	}

	void function logout( required rc )
	{
		var result = variables.SecurityService.deleteCurrentUser();
		rc.messages = result.messages;
		variables.fw.redirect( "security", "messages" );
	}

}