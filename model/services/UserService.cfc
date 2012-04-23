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
	
	any function init()
	{
		return this;
	}
	
	struct function deleteUser( required numeric userid )
	{
		var User = getUserByID( arguments.userid );
		var messages = {};
		if( User.isPersisted() )
		{
			transaction
			{
				EntityDelete( User );
				messages.success = "The user has been deleted.";
			}
		}
		else
		{
			messages.error = "The user could not be deleted.";
		}
		return messages;
	}
	
	any function getUserByID( required numeric userid )
	{
		var User = EntityLoadByPK( "User", arguments.userid );
		if( IsNull( User ) ) User = newUser();
		return User;
	}

	array function getUsers()
	{
		return EntityLoad( "User", {}, "firstname" );		
	}
		
	any function getValidator( required any User )
	{
		return application.ValidateThis.getValidator( theObject=arguments.User );
	}
	
	any function newUser()
	{
		return EntityNew( "User" );
	}		
	
	function saveUser( required struct properties, required string context, required any ValidateThis )
	{
		transaction
		{
			var User = ""; 
			User = getUserByID( Val( arguments.properties.userid ) );
			User.populate( arguments.properties );
			var result = arguments.ValidateThis.validate( theObject=User, Context=arguments.context );
			if( !result.hasErrors() )
			{
				EntitySave( User );
				transaction action="commit";
			}
			else
			{
				transaction action="rollback";
			}
		}
		return result;
	}
	
}