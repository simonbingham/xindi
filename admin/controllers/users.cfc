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

component accessors="true" extends="abstract"   
{

	property name="UserService" setter="true" getter="false";

	void function default( required struct rc ) {
		rc.users = variables.UserService.getUsers();
	}

	void function delete( required struct rc ) {
		param name="rc.userid" default="0";
		rc.messages = variables.UserService.deleteUser( Val( rc.userid ) );
		variables.fw.redirect( "users", "messages" );
	}	
	
	void function maintain( required struct rc ) {
		param name="rc.userid" default="0";
		param name="rc.context" default="create";
		if( !StructKeyExists( rc, "User" ) ) rc.User = variables.UserService.getUserByID( Val( rc.userid ) );
		if( rc.User.isPersisted() ) rc.context = "update";
		rc.Validator = variables.UserService.getValidator( rc.User );
	}	
	
	void function save( required struct rc ) {
		param name="rc.userid" default="0";
		param name="rc.firstname" default="";
		param name="rc.lastname" default="";
		param name="rc.email" default="";
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.context" default="create";
		var properties = { userid=rc.userid, firstname=rc.firstname, lastname=rc.lastname, email=rc.email, username=rc.username, password=rc.password };
		rc.result = variables.UserService.saveUser( properties, rc.context, application.ValidateThis );
		if( rc.result.hasErrors() )
		{
			rc.User = rc.result.getTheObject();
			rc.messages.error = "The user could not be saved. Please amend the fields listed below.";
			variables.fw.redirect( "users/maintain", "messages,User,userid,result" );
		}
		else
		{
			rc.messages.success = "The user has been saved.";
			variables.fw.redirect( "users", "messages" );	
		}
	}
	
}