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
		rc.users = variables.UserService.getUsers();
	}

	void function delete( required struct rc ){
		param name="rc.userid" default="0";
		rc.result = variables.UserService.deleteUser( userid=rc.userid );
		variables.fw.redirect( "users", "result" );
	}	
	
	void function maintain( required struct rc ){
		param name="rc.userid" default="0";
		param name="rc.context" default="create";
		if( !StructKeyExists( rc, "User" ) ) rc.User = variables.UserService.getUserByID( userid=rc.userid );
		if( rc.User.isPersisted() ) rc.context = "update";
		rc.Validator = variables.UserService.getValidator( User=rc.User );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
	}	
	
	void function save( required struct rc ){
		param name="rc.userid" default="0";
		param name="rc.firstname" default="";
		param name="rc.lastname" default="";
		param name="rc.email" default="";
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.context" default="create";
		param name="rc.submit" default="Save & exit";
		var properties = { userid=rc.userid, firstname=rc.firstname, lastname=rc.lastname, email=rc.email, username=rc.username, password=rc.password };
		rc.result = variables.UserService.saveUser( properties=properties, context=rc.context );
		rc.User = rc.result.getTheObject();
		if( rc.result.getIsSuccess() ){
			if( rc.submit == "Save & Continue" )  variables.fw.redirect( "users.maintain", "result,User", "userid" );
			else variables.fw.redirect( "users", "result" );
		}else{
			variables.fw.redirect( "users.maintain", "result,User", "userid" );
		}
	}
	
}