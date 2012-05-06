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

component extends="Base" persistent="true" table="pages" cacheuse="transactional"   
{

	/*
	 * Properties
	 */

	property name="pageid" fieldtype="id" setter="false" generator="native" column="page_id";
	
	property name="uuid" column="page_uuid" ormtype="string" length="150" default="";
	property name="leftvalue" column="page_left" ormtype="int" default="0";
	property name="rightvalue" column="page_right" ormtype="int" default="0";
	property name="title" column="page_title" ormtype="string" length="150" default="";
	property name="navigationtitle" column="page_navigationtitle" ormtype="string" length="150" default="";
	property name="content" column="page_content" ormtype="text" default="";
	property name="metatitle" column="page_metatitle" ormtype="string" length="200" default="";
	property name="metadescription" column="page_metadescription" ormtype="string" length="200" default="";
	property name="metakeywords" column="page_metakeywords" ormtype="string" length="200" default="";
	property name="created" column="page_created" ormtype="timestamp";
	property name="updated" column="page_updated" ormtype="timestamp";

	/*
	 * Public methods
	 */

	Page function init()
	{
		return this;
	}
	
	string function getDescendentPageIDList()
	{
		var pageidlist = "";
		for( var looppage in getDescendents() ){
			pageidlist = ListAppend( pageidlist, looppage.getPageID() );
		}
		return pageidlist; 
	}

	function getLevel()
	{
		return ORMExecuteQuery( "select Count( pageSubQuery ) from Page as pageSubQuery where pageSubQuery.leftvalue < :leftvalue and pageSubQuery.rightvalue > :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } )[ 1 ];
	}

	function getNextSibling()
	{
		return ORMExecuteQuery( "from Page where leftvalue = :leftvalue", { leftvalue=variables.rightvalue + 1 }, true );
	}
	
	array function getPath()
	{
		return ORMExecuteQuery( "from Page where leftvalue < :leftvalue and rightvalue > :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } );
	}	

	function getPreviousSibling()
	{
		return ORMExecuteQuery( "from Page where rightvalue = :rightvalue", { rightvalue=variables.leftvalue - 1 }, true );
	}
	
	string function getSlug()
	{
		var slug = "";
		if( !isRoot() )
		{
			for( var Page in getPath() )
			{
				if( !Page.isRoot() ) slug &= Page.getUUID() & "/";
			}
			slug &= getUUID();
		}
		return slug;
	}
	
	string function getSummary()
	{
		return Left( REReplaceNoCase( Trim( getContent() ), "<[^>]{1,}>", " ", "all" ), 500 ) & "...";
	}
	
	boolean function hasNextSibling()
	{
		return !IsNull( getNextSibling() );
	}

	boolean function hasMetaDescription()
	{
		return Len( Trim( getMetaDescription() ) );	
	}
	
	boolean function hasMetaKeywords()
	{
		return Len( Trim( getMetaKeywords() ) );
	}

	boolean function hasMetaTitle()
	{
		return Len( Trim( getMetaTitle() ) );		
	}

	boolean function hasPreviousSibling()
	{
		return !IsNull( getPreviousSibling() );
	}
			
	boolean function hasRoute( array routes=[] )
	{
		for( var route in arguments.routes )
			if( StructKeyExists( route, "/" & getSlug() ) ) return true;
		return false;
	}
	
	boolean function isLeaf()
	{
		return getDescendentCount() == 0;
	}	

	boolean function isPersisted()
	{
		return !IsNull( variables.pageid );
	}
	
	boolean function isRoot()
	{
		return getLevel() == 0;
	}
	
	void function preInsert()
	{
		setUUID();
	}
	
	void function preUpdate()
	{
		setUUID();
	}

	/*
	 * Private methods
	 */	
	
	private function getAncestor()
	{
		return ORMExecuteQuery( "from Page where leftvalue < :leftvalue and rightvalue > :rightvalue order by leftvalue desc", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue }, { maxresults=1 } );
	}	
	
	private numeric function getDescendentCount()
	{
		return ( variables.rightvalue - variables.leftvalue - 1 ) / 2;
	}
	
	private array function getDescendents()
	{
		return ORMExecuteQuery( "from Page where leftvalue > :leftvalue and rightvalue < :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } );
	}

	private array function getFirstChild()
	{
		return ORMExecuteQuery( "from Page where leftvalue = :leftvalue", { leftvalue=variables.leftvalue + 1 } );
	}	

	private array function getLastChild()
	{
		return ORMExecuteQuery( "from Page where rightvalue = :rightvalue", { rightvalue=variables.rightvalue - 1 } );
	}		
	
	private boolean function hasChild()
	{
		return ArrayLen( getFirstChild() );
	}

	private boolean function hasContent()
	{
		return Len( Trim( getContent() ) );
	}

	private boolean function hasDescendents()
	{
		return ArrayLen( getDescendents() );
	}	
	
	private boolean function isChild()
	{
		return getLevel() != 0;
	}	
	
	private boolean function isUUIDUnique()
	{
		var matches = []; 
		if( isPersisted() ) matches = ORMExecuteQuery( "from Page where pageid <> :pageid and uuid = :uuid", { pageid=getPageID(), uuid=getUUID()} );
		else matches = ORMExecuteQuery( "from Page where uuid=:uuid", { uuid=getUUID() } );
		return !ArrayLen( matches );
	}
	
	private void function setUUID()
	{
		variables.uuid = ReReplace( LCase( getNavigationTitle() ), "[^a-z0-9]{1,}", "", "all" );
		while ( !isUUIDUnique() ) variables.uuid &= "-"; 
	}
		
}