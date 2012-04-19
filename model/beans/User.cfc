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

component persistent="true" table="users" cacheuse="transactional"
{
	property name="userid" fieldtype="id" setter="false" generator="native" column="user_id";

	property name="firstname" ormtype="string" length="50" column="user_firstname" default="";
	property name="lastname" ormtype="string" length="50" column="user_lastname" default="";
	property name="email" ormtype="string" length="150" column="user_email" default="";
	property name="username" ormtype="string" length="50" column="user_username";
	property name="password" ormtype="string" length="50" column="user_password";
	property name="created" ormtype="timestamp" column="user_created";
	property name="updated" ormtype="timestamp" column="user_updated";
	
	function init()
	{
		return this;
	}
	
	string function getFullName()
	{
		return getFirstName() & " " & getLastName();
	}
	
	struct function isEmailUnique()
	{
		var matches = []; 
		var result = { issuccess=false, failuremessage="The email address '#getEmail()#' is registered to an existing account." };
		if( isPersisted() ) matches = ORMExecuteQuery( "from User where userid <> :userid and email = :email", { userid=getUserID(), email=getEmail()} );
		else matches = ORMExecuteQuery( "from User where email=:email", { email=getEmail() } );
		if( !ArrayLen( matches ) ) result.issuccess = true;
		return result;
	}

	struct function isUsernameUnique()
	{
		var matches = []; 
		var result = { issuccess = false, failuremessage = "The username '#getUsername()#' is registered to an existing account." };
		if( isPersisted() ) matches = ORMExecuteQuery( "from User where userid <> :userid and username = :username", { userid=getUserID(), username=getUsername()} );
		else matches = OrmExecuteQuery( "from User where username = :username", { username=getUsername() } );
		if( !ArrayLen( matches ) ) result.issuccess = true;
		return result;
	}	

	boolean function isPersisted()
	{
		return !IsNull( variables.userid );
	}
	
	// TODO: move to abstract cfc
	// populate method sourced from https://gist.github.com/947636
	void function populate( required struct memento, boolean trustedSetter=false, string include="", string exclude="", string disallowConversionToNull="" )
	{
		var object = this;
		var key = "";
		var populate = true;
		for( key in arguments.memento )
		{
			populate = true;
			if( Len( arguments.include ) && !ListFindNoCase( arguments.include, key ) ) populate = false;
			if( Len( arguments.exclude ) && ListFindNoCase( arguments.exclude, key ) ) populate = false;
			if( populate )
			{
				if( StructKeyExists( object, "set" & key ) || arguments.trustedSetter )
				{
					if( IsSimpleValue( arguments.memento[ key ] ) && Trim( arguments.memento[ key ] ) == "" )
					{
						if( Len( arguments.disallowConversionToNull ) && !ListFindNoCase( arguments.disallowConversionToNull, key ) ) Evaluate( "object.set#key#(arguments.memento[key])" );
						else Evaluate( 'object.set#key#(javacast("null",""))' );
					}
					else 
					{
						Evaluate( "object.set#key#(arguments.memento[key])" );
					}
				}
			}
		}
	}
	
	// TODO: move to global event handler
	void function preInsert()
	{
		var timestamp = Now();
		setCreated( timestamp );
		setUpdated( timestamp );
	}
	
	// TODO: move to global event handler
	void function preUpdate()
	{
		setUpdated( Now() );
	}
		
}