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

component persistent="true" table="pages" cacheuse="transactional"{

	// ------------------------ PROPERTIES ------------------------ //

	property name="pageid" column="page_id" fieldtype="id" setter="false" generator="native";
	
	property name="label" column="page_label" ormtype="string" length="150";
	property name="leftvalue" column="page_left" ormtype="int";
	property name="rightvalue" column="page_right" ormtype="int";
	property name="title" column="page_title" ormtype="string" length="150";
	property name="content" column="page_content" ormtype="text";
	property name="metagenerated" column="page_metagenerated" ormtype="boolean";
	property name="metatitle" column="page_metatitle" ormtype="string" length="69";
	property name="metadescription" column="page_metadescription" ormtype="string" length="169";
	property name="metakeywords" column="page_metakeywords" ormtype="string" length="169";
	property name="created" column="page_created" ormtype="timestamp";
	property name="updated" column="page_updated" ormtype="timestamp";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I initialise this component
	 */	
	Page function init(){
		variables.metagenerated = true;
		return this;
	}
	
	/**
	 * I return the page ancestor
	 */		
	any function getAncestor(){
		return ORMExecuteQuery( "from Page where leftvalue < :leftvalue and rightvalue > :rightvalue order by leftvalue desc", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue }, true, { maxresults=1 } );
	}
	
	/**
	 * I return a list of descendent page ids
	 */		
	string function getDescendentPageIDList(){
		var pageidlist = "";
		for( var looppage in getDescendents() ) pageidlist = ListAppend( pageidlist, looppage.getPageID() );
		return pageidlist; 
	}

	/**
	 * I return the page level
	 */	
	function getLevel(){
		return ORMExecuteQuery( "select Count( pageSubQuery ) from Page as pageSubQuery where pageSubQuery.leftvalue < :leftvalue and pageSubQuery.rightvalue > :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } )[ 1 ];
	}

	/**
	 * I return the next sibling of the page
	 */	
	function getNextSibling(){
		return ORMExecuteQuery( "from Page where leftvalue = :leftvalue", { leftvalue=variables.rightvalue + 1 }, true );
	}
	
	/**
	 * I return the page path
	 */		
	array function getPath(){
		return ORMExecuteQuery( "from Page where leftvalue < :leftvalue and rightvalue > :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } );
	}	

	/**
	 * I return the previous sibling of the page
	 */	
	function getPreviousSibling(){
		return ORMExecuteQuery( "from Page where rightvalue = :rightvalue", { rightvalue=variables.leftvalue - 1 }, true );
	}
	
	/**
	 * I return the page slug
	 */		
	string function getSlug(){
		var slug = "";
		if( !isRoot() ){
			for( var Page in getPath() ){
				if( !Page.isRoot() ) slug &= Page.getLabel() & "/";
			}
			slug &= variables.label;
		}
		return slug;
	}
	
	/**
	 * I return the page summary
	 */		
	string function getSummary(){
		var plaintext = Trim( ReReplace( REReplaceNoCase( Trim( variables.content ), "<[^>]{1,}>", " ", "all" ), " +", " ", "all" ) );
		if( Len( plaintext ) > 500 ) return Left( plaintext, 500 ) & "...";
		return plaintext;
	}
	
	/**
	 * I return true if the page has a child
	 */		
	boolean function hasChild(){
		return !IsNull( getFirstChild() );
	}	
	
	/**
	 * I return true if the page has a next sibling
	 */		
	boolean function hasNextSibling(){
		return !IsNull( getNextSibling() );
	}

	/**
	 * I return true if the page has a meta description
	 */	
	boolean function hasMetaDescription(){
		return Len( Trim( variables.metadescription ) );	
	}
	
	/**
	 * I return true if the page has meta keywords
	 */		
	boolean function hasMetaKeywords(){
		return Len( Trim( variables.metakeywords ) );
	}

	/**
	 * I return true if the page has a meta title
	 */	
	boolean function hasMetaTitle(){
		return Len( Trim( variables.metatitle ) );		
	}

	/**
	 * I return true if the page id is found in a list of page ids
	 */	
	boolean function hasPageIDInPath( required string pageidlist ){
		if( ListFind( arguments.pageidlist, variables.pageid ) ) return true;
		for( var Page in getPath() ){
			if( ListFind( arguments.pageidlist, Page.getPageID() ) ) return true;
		}
		return false;
	}

	/**
	 * I return true if the page has a previous sibling
	 */	
	boolean function hasPreviousSibling(){
		return !IsNull( getPreviousSibling() );
	}

	/**
	 * I return true if the page has a FW/1 route
	 */				
	boolean function hasRoute( array routes=[] ){
		for( var route in arguments.routes ){
			if( StructKeyExists( route, getSlug() ) ) return true;
		}
		return false;
	}
	
	/**
	 * I return true if the page is a leaf (i.e. has no children)
	 */		
	boolean function isLeaf(){
		return getDescendentCount() == 0;
	}	

	/**
	 * I return true if the page meta tags are automatically generated
	 */	
	boolean function isMetaGenerated(){
		return variables.metagenerated;
	}

	/**
	 * I return true if the page is persisted
	 */	
	boolean function isPersisted(){
		return !IsNull( variables.pageid );
	}
	
	/**
	 * I return true if the page is the root (i.e. home page)
	 */		
	boolean function isRoot(){
		return getLevel() == 0;
	}
	
	/**
	 * I am called after the page is inserted into the database 
	 */		
	void function preInsert(){
		setLabel();
	}

	// ------------------------ PRIVATE METHODS ------------------------ //
	
	/**
	 * I return the count of page descendents 
	 */	
	private numeric function getDescendentCount(){
		return ( variables.rightvalue - variables.leftvalue - 1 ) / 2;
	}
	
	/**
	 * I return the page descendents
	 */	
	private array function getDescendents(){
		return ORMExecuteQuery( "from Page where leftvalue > :leftvalue and rightvalue < :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } );
	}

	/**
	 * I return the first child of the page
	 */	
	private function getFirstChild(){
		return ORMExecuteQuery( "from Page where leftvalue = :leftvalue", { leftvalue=variables.leftvalue + 1 }, true );
	}	

	/**
	 * I return the last child of the page
	 */	
	private function getLastChild(){
		return ORMExecuteQuery( "from Page where rightvalue = :rightvalue", { rightvalue=variables.rightvalue - 1 }, true );
	}		
	
	/**
	 * I return true if the page has content
	 */		
	private boolean function hasContent(){
		return Len( Trim( variables.content ) );
	}

	/**
	 * I return true if the page has descendents
	 */	
	private boolean function hasDescendents(){
		return ArrayLen( getDescendents() );
	}	
	
	/**
	 * I return true if the page has a parent
	 */		
	private boolean function isChild(){
		return getLevel() != 0;
	}	

	/**
	 * I return true if the id of the page is unique
	 */		
	private boolean function isLabelUnique(){
		var matches = []; 
		if( isPersisted() ) matches = ORMExecuteQuery( "from Page where pageid <> :pageid and label = :label", { pageid=variables.pageid, label=variables.label } );
		else matches = ORMExecuteQuery( "from Page where label=:label", { label=variables.label });
		return !ArrayLen( matches );
	}
	
	/**
	 * I generate a unique id for the page
	 */		
	private void function setLabel(){
		variables.label = ReReplace( LCase( variables.title ), "[^a-z0-9]{1,}", "-", "all" );
		while ( !isLabelUnique() ) variables.label &= "-"; 
	}
		
}