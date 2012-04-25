/*
   Copyright 2012, Simon Bingham

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
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
			rc.Validator = variables.UserService.getValidator( application.ValidateThis, rc.User );
		}
	}
	
	void function login( required rc )
	{
		param name="rc.username" default="";
		param name="rc.password" default="";
		var properties = { username=rc.username, password=rc.password };
		rc.result = variables.SecurityService.loginUser( properties, application.ValidateThis );
		if( rc.result.hasErrors() )
		{
			variables.fw.redirect( "security", "result" );
		}
		else
		{
			rc.messages.success = "You have been logged in.";
			variables.fw.redirect( "main", "messages" );	
		}
	}

	void function logout( required rc )
	{
		variables.SecurityService.deleteCurrentUser();
		rc.message = "You have been logged out.";
		variables.fw.redirect( "login", "messages" );
	}

}