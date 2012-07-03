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
	
	property name="NewsGateway" getter="false";

	/*
	 * Public methods
	 */
	 	
	struct function deleteArticle( required articleid ){
		transaction{
			return variables.NewsGateway.deleteArticle( Val( arguments.articleid ) );
		}
	}
	
	function getArticleByID( required articleid ){
		return variables.NewsGateway.getArticleByID( Val( arguments.articleid ) );
	}
	
	function getArticleByUUID( required string uuid ){
		return variables.NewsGateway.getArticleByUUID( argumentCollection=arguments );
	}
	
	numeric function getArticleCount(){
		return variables.NewsGateway.getArticleCount();
	}

	array function getArticles( string searchterm="", string sortorder="published desc", boolean published=false, maxresults=0, offset=0 ){
		arguments.maxresults = Val( arguments.maxresults );
		arguments.offset = Val( arguments.offset );
		return variables.NewsGateway.getArticles( argumentCollection=arguments );
	}
		
	function getValidator( required any Article ){
		return variables.NewsGateway.getValidator( argumentCollection=arguments );
	}
	
	function saveArticle( required struct properties ){
		transaction{
			return variables.NewsGateway.saveArticle( argumentCollection=arguments );
		}
	}
	
}