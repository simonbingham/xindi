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
	
	property name="Validator" getter="false";

	/*
	 * Public methods
	 */
	 	
	function deleteUser( required userid ){
		var User = getUser( Val( arguments.userid ) );
		var result = variables.Validator.newResult();
		if( User.isPersisted() ){
			EntityDelete( User );
			result.setSuccessMessage( "The user &quot;#User.getFullName()#&quot; has been deleted." );
		}else{
			result.setErrorMessage( "The user could not be deleted." );
		}
		return result;
	}
	
	function getUser( required userid ){
		var User = EntityLoadByPK( "User", Val( arguments.userid ) );
		if( IsNull( User ) ) User = newUser();
		return User;
	}

	function getUserByCredentials( required User ){
		User = ORMExecuteQuery( "from User where ( username=:username or email=:email ) and password=:password", { username=arguments.User.getUsername(), email=arguments.User.getEmail(), password=arguments.User.getPassword() }, true );
		if( IsNull( User ) ) User = newUser();
		return User;
	}

	// TODO: might be able to remove this
	function getUserByEmailOrUsername( required User ){
		User = ORMExecuteQuery( "from User where username=:username or email=:email", { username=arguments.User.getUsername(), email=arguments.User.getEmail() }, true );
		if( IsNull( User ) ) User = newUser();
		return User;		
	}

	array function getUsers(){
		return EntityLoad( "User", {}, "firstname" );	
	}
		
	function getValidator( required any User ){
		return variables.Validator.getValidator( theObject=arguments.User );
	}
	
	function newUser(){
		return EntityNew( "User" );
	}
	
	function saveUser( required struct properties, required string context ){
		param name="arguments.properties.userid" default="0";
		var result = variables.Validator.newResult();
		var User = ""; 
		User = getUser( Val( arguments.properties.userid ) );
		User.populate( arguments.properties );
		var result = variables.Validator.validate( theObject=User, context=arguments.context );
		if( !result.hasErrors() ){
			result.setSuccessMessage( "The user &quot;#User.getFullName()#&quot; has been saved." );
			EntitySave( User );
		}else{
			result.setErrorMessage( "The user could not be saved. Please amend the highlighted fields." );
		}
		return result;
	}
	
}