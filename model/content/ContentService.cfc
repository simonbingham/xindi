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

component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="ContentGateway" getter="false";
	property name="MetaData" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete a page
	 */		 	
	struct function deletePage( required pageid ){
		transaction{
			var Page = variables.ContentGateway.getPage( Val( arguments.pageid ) );
			var result = variables.Validator.newResult();
			if( Page.isPersisted() ){
				variables.ContentGateway.deletePage( Page );
				result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been deleted." );
			}else{
				result.setErrorMessage( "The page could not be deleted." );
			}
		}
		return result;
	}
	
	/**
	 * I return a page matching an id
	 */		
	Page function getPage( required pageid ){
		return variables.ContentGateway.getPage( Val( arguments.pageid ) );
	}
	
	/**
	 * I return a page matching a slug
	 */		
	Page function getPageBySlug( required string slug ){
		return variables.ContentGateway.getPageBySlug( argumentCollection=arguments );
	}

	/**
	 * I return an array of pages
	 */	
	array function getPages( string searchterm="", sortorder="leftvalue", maxresults=0, excludefromsearch="" ){
		arguments.maxresults = Val( arguments.maxresults );
		return variables.ContentGateway.getPages( argumentCollection=arguments );
	}

	/**
	 * I return the root page (i.e. home page)
	 */	
	Page function getRoot(){
		return variables.ContentGateway.getRoot();
	}	
	
	/**
	 * I move a page
	 */		
	struct function movePage( required pageid, required string direction ){
		transaction{
			var result = variables.Validator.newResult();
			var Page = variables.ContentGateway.getPage( Val( arguments.pageid ) );
			result.setErrorMessage( "The page could not be moved." );
			if( Page.isPersisted() && ListFindNoCase( "up,down", Trim( arguments.direction ) ) ){
				if( arguments.direction eq "up" ){
					if( Page.hasPreviousSibling() ){
						variables.ContentGateway.movePage( Page, "up" );
						result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been moved." );
					}
				}else{
					if( Page.hasNextSibling() ){
						variables.ContentGateway.movePage( Page, "down" );
						result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been moved." );
					}
				}
			}
			result.setTheObject( Page );
		}
		return result;
	}
	
	/**
	 * I validate and save a page
	 */		
	struct function savePage( required struct properties, required ancestorid, required string context, required string websitetitle ){
		transaction{
			param name="arguments.properties.pageid" default="";
			param name="arguments.properties.metagenerated" default="false";
			arguments.properties.pageid = Val( arguments.properties.pageid );
			var Page = variables.ContentGateway.getPage( arguments.properties.pageid );
			if( arguments.properties.metagenerated ){
				arguments.properties.metatitle = variables.MetaData.generatePageTitle( arguments.websitetitle, arguments.properties.title );
				arguments.properties.metadescription = variables.MetaData.generateMetaDescription( arguments.properties.content );
				arguments.properties.metakeywords = variables.MetaData.generateMetaKeywords( arguments.properties.title );
			}			
			populate( Page, arguments.properties );
			var result = variables.Validator.validate( theObject=Page, context=arguments.context );
			if( !result.hasErrors() ){
				variables.ContentGateway.savePage( Page, ancestorid );
				result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been saved." );
			}else{
				result.setErrorMessage( "Your page could not be saved. Please amend the highlighted fields." );
			}
		}
		return result;
	}
	
}