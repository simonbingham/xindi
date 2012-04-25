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
	
	property name="UserService" setter="true" getter="false";
	
	variables.userkey = "userid";

	/*
	 * Public methods
	 */

	function deleteCurrentUser()
	{
		if ( hasCurrentUser() ) StructDelete( session, variables.userkey );
	}

	function getCurrentUser()
	{
		if ( hasCurrentUser() ) return variables.UserService.getUserByID( session[ variables.userkey ] ).isPersisted();
	}
		
	boolean function hasCurrentUser()
	{
		return StructKeyExists( session, variables.userkey );
	}

	function loginUser( required struct properties, required any ValidateThis )
	{
		var User = variables.UserService.newUser();
		User.populate( arguments.properties );
		var result = arguments.ValidateThis.validate( User, "login" );
		if( !result.hasErrors() )
		{
			User = variables.UserService.getUserByCredentials( arguments.properties );
			if( !IsNull( User ) )
			{
				setCurrentUser( User );
			}
			else
			{
				var failure = { propertyName="username", clientFieldname="username", message="Sorry, your login details have not been recognised." };
				result.addFailure( failure );				
			}
		}
		return result;
	}	
	
	function setCurrentUser( required any User )
	{
		session[ variables.userkey ] = arguments.User.getUserID();
	}
	
}