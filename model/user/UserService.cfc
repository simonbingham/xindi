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

	/*
	 * Public methods
	 */
	 	
	struct function deleteUser( required userid ){
		return variables.UserGateway.deleteUser( userid=Val( arguments.userid ) );
	}
	
	function getUserByID( required userid ){
		return variables.UserGateway.getUserByID( userid=Val( arguments.userid ) );
	}

	function getUserByCredentials( required User ){
		return variables.UserGateway.getUserByCredentials( argumentCollection=arguments );
	}

	function getUserByEmailOrUsername( required User ){
		return variables.UserGateway.getUserByEmailOrUsername( argumentCollection=arguments );
	}

	array function getUsers(){
		return variables.UserGateway.getUsers();
	}
		
	function getValidator( required any User ){
		return variables.UserGateway.getValidator( argumentCollection=arguments );
	}
	
	function newUser(){
		return variables.UserGateway.newUser();
	}
	
	struct function saveUser( required struct properties, required string context ){
		return variables.UserGateway.saveUser( argumentCollection=arguments );
	}
	
}