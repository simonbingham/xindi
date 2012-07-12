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
	 * DEPENDENCY INJECTION
	 */	
	
	property name="NotificationService" getter="false";
	property name="UserGateway" getter="false";
	property name="UserService" getter="false";
	property name="Validator" getter="false";
	property name="config" getter="false";
	
	variables.userkey = "userid";

	/*
	 * PUBLIC METHODS
	 */

	/**
     * I delete the current user from the session
	 */	
	struct function deleteCurrentUser( required struct session ){
		var result = variables.Validator.newResult();
		if( hasCurrentUser( arguments.session ) ){
			StructDelete( arguments.session, variables.userkey );
			result.setSuccessMessage( "You have been logged out." );	
		}else{
			result.setErrorMessage( "You are not logged in." );
		}
		return result;
	}

	/**
     * I return true if the session has a user
	 */	
	boolean function hasCurrentUser( required struct session ){
		return StructKeyExists( arguments.session, variables.userkey );
	}
	
	/**
     * I return true if the user is permitted access to an action
	 */		
	boolean function isAllowed( required struct session, required string action, string whitelist ){
		param name="arguments.whitelist" default=variables.config.security.whitelist; 
		// user is not logged in
		if( !hasCurrentUser( arguments.session ) ){
			// if the requested action is in the whitelist allow access
			for ( var unsecured in ListToArray( arguments.whitelist ) ){
				if( ReFindNoCase( unsecured, arguments.action ) ) return true;
			}
		// user is logged in so allow access to requested action 
		}else if( hasCurrentUser( arguments.session ) ){
			return true;
		}
		// previous conditions not met so deny access to requested action
		return false;
	}	

	/**
     * I verify and login a user
	 */	
	struct function loginUser( required struct session, required struct properties ){
		param name="arguments.properties.username" default="";
		param name="arguments.properties.password" default="";
		if( IsValid( "email", arguments.properties.username ) ){
			arguments.properties.email = arguments.properties.username;
			StructDelete( arguments.properties, "username" );
		}
		var User = variables.UserGateway.newUser();
		User.populate( arguments.properties );
		var result = variables.Validator.validate( theObject=User, context="login" );
		User = variables.UserGateway.getUserByCredentials( User );
		if( User.isPersisted() ){
			setCurrentUser( arguments.session, User );
			result.setSuccessMessage( "Welcome #User.getFirstName()#. You have been logged in." );
		}else{
			var message = "Sorry, your login details have not been recognised.";
			result.setErrorMessage( message );
			var failure = { propertyName="username", clientFieldname="username", message=message };
			result.addFailure( failure );
		}
		return result;
	}	
	
	/**
     * I reset the password of a user and send a notification email
	 */		
	struct function resetPassword( required struct properties, required string name, required struct config, required string emailtemplatepath ){
		transaction{
			param name="arguments.properties.username" default="";
			if( IsValid( "email", arguments.properties.username ) ){
				arguments.properties.email = arguments.properties.username;
				StructDelete( arguments.properties, "username" );
			}
			var User = variables.UserGateway.newUser();
			User.populate( arguments.properties );
			var result = variables.Validator.validate( theObject=User, context="password" );
			User = variables.UserGateway.getUserByEmailOrUsername( User );
			if( User.isPersisted() ){
				var password = variables.UserService.newPassword();
				User.setPassword( password );
				savecontent variable="emailtemplate"{ include arguments.emailtemplatepath; }
				variables.NotificationService.send( arguments.config.resetpasswordemailsubject, User.getEmail(), arguments.config.resetpasswordemailfrom, emailtemplate );
				result.setSuccessMessage( "A new password has been sent to #User.getEmail()#." );
			}else{
				var message = "Sorry, your username or email address has not been recognised.";
				result.setErrorMessage( message );
				var failure = { propertyName="username", clientFieldname="username", message=message };
				result.addFailure( failure );
			}
		}
		return result;
	}	

	/**
     * I add a user to the session
	 */		
	void function setCurrentUser( required struct session, required any User ){
		arguments.session[ variables.userkey ] = arguments.User.getUserID();
	}
	
}