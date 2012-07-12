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
	 	
	void function deleteUser( required User theUser ){
		delete( arguments.theUser );
	}
	
	User function getUser( required numeric userid ){
		return get( "User", arguments.userid );
	}

	User function getUserByCredentials( required User theUser ){
		var User = ORMExecuteQuery( "from User where ( username=:username or email=:email ) and password=:password", { username=arguments.theUser.getUsername(), email=arguments.theUser.getEmail(), password=arguments.theUser.getPassword() }, true );
		if( IsNull( User ) ) User = new( "User" );
		return User;
	}

	User function getUserByEmailOrUsername( required User theUser ){
		var User = ORMExecuteQuery( "from User where username=:username or email=:email", { username=arguments.theUser.getUsername(), email=arguments.theUser.getEmail() }, true );
		if( IsNull( User ) ) User = new( "User" );
		return User;		
	}

	array function getUsers(){
		return EntityLoad( "User", {}, "firstname" );
	}
		
	User function newUser(){
		return new( "User" );
	}
	
	User function saveUser( required User theUser ){
		return save( arguments.theUser );
	}
	
}