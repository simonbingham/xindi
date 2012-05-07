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

	property name="UserService" setter="true" getter="false";

	/*
	 * Public methods
	 */	
	 
	void function default( required struct rc ) {
		rc.users = variables.UserService.getUsers();
	}

	void function delete( required struct rc ) {
		param name="rc.userid" default="0";
		var result = variables.UserService.deleteUser( Val( rc.userid ) );
		rc.messages = result.messages;
		variables.fw.redirect( "users", "messages" );
	}	
	
	void function maintain( required struct rc ) {
		param name="rc.userid" default="0";
		param name="rc.context" default="create";
		if( !StructKeyExists( rc, "User" ) ) rc.User = variables.UserService.getUserByID( Val( rc.userid ) );
		if( rc.User.isPersisted() ) rc.context = "update";
		rc.Validator = variables.UserService.getValidator( rc.User );
	}	
	
	void function save( required struct rc ) {
		param name="rc.userid" default="0";
		param name="rc.firstname" default="";
		param name="rc.lastname" default="";
		param name="rc.email" default="";
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.context" default="create";
		var properties = { userid=rc.userid, firstname=rc.firstname, lastname=rc.lastname, email=rc.email, username=rc.username, password=rc.password };
		var result = variables.UserService.saveUser( properties, rc.context );
		rc.messages = result.messages;
		if( StructKeyExists( rc.messages, "success" ) )
		{
			variables.fw.redirect( "users", "messages" );	
		}
		else
		{
			rc.User = result.getTheObject();
			variables.fw.redirect( "users/maintain", "messages,User,userid" );
		}
	}
	
}