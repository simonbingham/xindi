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
	
	property name="UserGateway" getter="false";
	property name="Validator" getter="false";
	property name="config" getter="false";
	
	variables.userkey = "userid";

	/*
	 * Public methods
	 */

	struct function deleteCurrentUser(){
		var result = {};
		if( hasCurrentUser() ){
			StructDelete( session, variables.userkey );
			result.messages.success = "You have been logged out.";	
		}else{
			result.messages.error = "You are not logged in.";
		}
		return result;
	}

	boolean function hasCurrentUser(){
		return StructKeyExists( session, variables.userkey );
	}
	
	boolean function isAllowed( required string action, string whitelist ){
		param name="arguments.whitelist" default=variables.config.security.whitelist; 
		// user is not logged in
		if( !hasCurrentUser() ){
			// if the requested action is in the whitelist allow access
			for ( var unsecured in ListToArray( arguments.whitelist ) ){
				if( ReFindNoCase( unsecured, arguments.action ) ) return true;
			}
		// user is logged in so allow access to requested action 
		}else if( hasCurrentUser() ){
			return true;
		}
		// previous conditions not met so deny access to requested action
		return false;
	}	

	function loginUser( required struct properties ){
		param name="arguments.properties.username" default="";
		param name="arguments.properties.password" default="";
		if( IsValid( "email", arguments.properties.username ) ){
			arguments.properties.email = arguments.properties.username;
			StructDelete( arguments.properties, "username" );
		}
		var User = variables.UserGateway.newUser();
		User.populate( arguments.properties );
		var result = variables.Validator.validate( theObject=User, context="login" );
		User = variables.UserGateway.getUserByCredentials( User=User );
		if( User.isPersisted() ){
			setCurrentUser( User );
			result.messages.success = "Welcome #User.getFirstName()#. You have been logged in.";
		}else{
			result.messages.error = "Sorry, your login details have not been recognised.";
			var failure = { propertyName="username", clientFieldname="username", message=result.messages.error };
			result.addFailure( failure );
		}
		return result;
	}	
	
	struct function resetPassword( required struct properties, required string name, required struct config, required string emailtemplatepath ){
		param name="arguments.properties.username" default="";
		if( IsValid( "email", arguments.properties.username ) ){
			arguments.properties.email = arguments.properties.username;
			StructDelete( arguments.properties, "username" );
		}
		var User = variables.UserGateway.newUser();
		User.populate( arguments.properties );
		var result = variables.Validator.validate( theObject=User, context="password" );
		User = variables.UserGateway.getUserByEmailOrUsername( User=User );
		if( User.isPersisted() ){
			var password = Left( CreateUUID(), 8 );
			User.setPassword( password );
			savecontent variable="emailtemplate"{ include arguments.emailtemplatepath; }
			var Email = new mail();
		    Email.setSubject( arguments.config.resetpasswordemailsubject );
	    	Email.setTo( User.getEmail() );
	    	Email.setFrom( arguments.config.resetpasswordemailfrom );
	    	Email.setBody( emailtemplate );
	    	Email.setType( "html" );
	        Email.send();				
			result.messages.success = "A new password has been sent to #User.getEmail()#.";
		}else{
			result.messages.error = "Sorry, your username or email address has not been recognised.";
			var failure = { propertyName="username", clientFieldname="username", message=result.messages.error };
			result.addFailure( failure );
		}
		return result;
	}	
	
	void function setCurrentUser( required any User ){
		session[ variables.userkey ] = arguments.User.getUserID();
	}
	
}