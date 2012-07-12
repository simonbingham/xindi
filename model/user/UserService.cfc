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

	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	
	property name="UserGateway" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
     * I delete a user
	 */		 	
	struct function deleteUser( required userid ){
		transaction{
			var User = variables.UserGateway.getUser( Val( arguments.userid ) );
			var result = variables.Validator.newResult();
			if( User.isPersisted() ){
				variables.UserGateway.deleteUser( User );
				result.setSuccessMessage( "The user &quot;#User.getFullName()#&quot; has been deleted." );
			}else{
				result.setErrorMessage( "The user could not be deleted." );
			}
		}
		return result;
	}
	
	/**
     * I return a user matching an id
	 */		
	User function getUser( required userid ){
		return variables.UserGateway.getUser( Val( arguments.userid ) );
	}

	/**
     * I return a user matching a username or email address and password
	 */	
	User function getUserByCredentials( required User theUser ){
		return variables.UserGateway.getUserByCredentials( theUser );
	}

	/**
     * I return a user matching a username or email address
	 */	
	User function getUserByEmailOrUsername( required User theUser ){
		return variables.UserGateway.getUserByEmailOrUsername( theUser );
	}

	/**
     * I return an array of users
	 */	
	array function getUsers(){
		return variables.UserGateway.getUsers();
	}

	/**
     * I return a user validator
	 */			
	function getValidator( required User theUser ){
		return variables.Validator.getValidator( theObject=arguments.theUser );
	}
	
	/**
     * I return a new password
	 */		
	string function newPassword(){
		return Left( CreateUUID(), 8 );
	}
	
	/**
     * I return a new user
	 */		
	User function newUser(){
		return variables.UserGateway.newUser();
	}
	
	/**
     * I validate and save a user
	 */		
	struct function saveUser( required struct properties, required string context ){
		transaction{
			param name="arguments.properties.userid" default="0";
			var User = variables.UserGateway.getUser( Val( arguments.properties.userid ) );
			User.populate( arguments.properties );
			var result = variables.Validator.validate( theObject=User, context=arguments.context );
			if( !result.hasErrors() ){
				result.setSuccessMessage( "The user &quot;#User.getFullName()#&quot; has been saved." );
				variables.UserGateway.saveUser( User );
			}else{
				result.setErrorMessage( "The user could not be saved. Please amend the highlighted fields." );
			}
		}
		return result;
	}
	
}