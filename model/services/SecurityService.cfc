/*
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
	
	property name="UserService" getter="false";
	property name="Validator" getter="false";
	
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

	function loginUser( required struct properties )
	{
		var User = variables.UserService.newUser();
		User.populate( arguments.properties );
		var result = variables.Validator.validate( User, "login" );
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