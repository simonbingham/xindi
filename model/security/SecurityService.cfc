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
	
	property name="SecurityGateway" getter="false";

	/*
	 * Public methods
	 */

	function deleteCurrentUser( required struct session ){
		return variables.SecurityGateway.deleteCurrentUser( session=arguments.session );
	}

	boolean function hasCurrentUser( required struct session ){
		return variables.SecurityGateway.hasCurrentUser( session=arguments.session );
	}
	
	boolean function isAllowed( required struct session, required string action, string whitelist ){
		return variables.SecurityGateway.isAllowed( argumentCollection=arguments );
	}	

	function loginUser( required struct session, required struct properties ){
		return variables.SecurityGateway.loginUser( argumentCollection=arguments );
	}	
	
	function resetPassword( required struct properties, required string name, required struct config, required string emailtemplatepath ){
		transaction{
			var result = variables.SecurityGateway.resetPassword( argumentCollection=arguments );
		}
		return result;
	}	
	
	void function setCurrentUser( required struct session, required any User ){
		variables.SecurityGateway.setCurrentUser( argumentCollection=arguments );
	}
	
}