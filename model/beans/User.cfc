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

component extends="Base" persistent="true" table="users" cacheuse="transactional"
{

	/*
	 * Properties
	 */	
	
	property name="userid" fieldtype="id" setter="false" generator="native" column="user_id";

	property name="firstname" ormtype="string" length="50" column="user_firstname";
	property name="lastname" ormtype="string" length="50" column="user_lastname";
	property name="email" ormtype="string" length="150" column="user_email";
	property name="username" ormtype="string" length="50" column="user_username";
	property name="password" ormtype="string" length="65" column="user_password" setter="false";
	property name="created" ormtype="timestamp" column="user_created";
	property name="updated" ormtype="timestamp" column="user_updated";
	
	/*
	 * Public methods
	 */	
	
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
	
	/**
	* I override the implicit setter to include hashing of the password
	*/
	string function setPassword( required password )
	{
		if ( arguments.password != "" )
		{
			variables.password = arguments.password;
			// to help prevent rainbow attacks hash several times
			for ( var i=0; i<50; i++ ) {			
				variables.password = Hash( variables.password, "SHA-256" );
			}
		}
	}
	
}