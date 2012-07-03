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

	property name="ContentGateway" getter="false";

	/*
	 * Public methods
	 */
	 	
	struct function deletePage( required pageid ){
		transaction{
			return variables.ContentGateway.deletePage( Val( arguments.pageid ) );
		}
	}
	
	function getPageByID( required pageid ){
		return variables.ContentGateway.getPageByID( Val( arguments.pageid ) );
	}
	
	function getPageBySlug( required string slug ){
		return variables.ContentGateway.getPageBySlug( argumentCollection=arguments );
	}

	array function getPages( string searchterm="", sortorder="leftvalue", maxresults=0 ){
		arguments.maxresults = Val( arguments.maxresults );
		return variables.ContentGateway.getPages( argumentCollection=arguments );
	}

	function getRoot(){
		return variables.ContentGateway.getRoot();
	}	
	
	function getValidator( required any Page ){
		return variables.ContentGateway.getValidator( argumentCollection=arguments );
	}
	
	struct function movePage( required pageid, required string direction ){
		transaction{
			arguments.pageid = Val( arguments.pageid );
			return variables.ContentGateway.movePage( argumentCollection=arguments );
		}
	}
	
	function savePage( required struct properties, required ancestorid, required string context ){
		transaction{
			arguments.ancestorid = Val( arguments.ancestorid );
			return variables.ContentGateway.savePage( argumentCollection=arguments );
		}
	}
	
}