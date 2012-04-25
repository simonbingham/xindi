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

component extends="Abstract" persistent="true" table="pages" cacheuse="transactional"   
{

	/*
	 * Properties
	 */

	property name="pageid" fieldtype="id" setter="false" generator="native" column="page_id";
	
	property name="uuid" column="page_uuid" ormtype="string" length="150" default="";
	property name="leftvalue" column="page_left" ormtype="int" default="";
	property name="rightvalue" column="page_right" ormtype="int" default="";
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
	
	function getAncestor()
	{
		return ORMExecuteQuery( "from Page where leftvalue < :leftvalue and rightvalue > :rightvalue order by leftvalue desc", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue }, { maxresults=1 } );
	}	
	
	numeric function getDescendentCount()
	{
		return ( variables.rightvalue - variables.leftvalue - 1 ) / 2;
	}

	string function getDescendentPageIDList()
	{
		var pageidlist = "";
		for( var looppage in getDescendents() ){
			pageidlist = ListAppend( pageidlist, looppage.getPageID() );
		}
		return pageidlist; 
	}

	array function getDescendents()
	{
		return ORMExecuteQuery( "from Page where leftvalue > :leftvalue and rightvalue < :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } );
	}

	array function getFirstChild()
	{
		return ORMExecuteQuery( "from Page where leftvalue = :leftvalue", { leftvalue=variables.leftvalue + 1 } );
	}	

	array function getLastChild()
	{
		return ORMExecuteQuery( "from Page where rightvalue = :rightvalue", { rightvalue=variables.rightvalue - 1 } );
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
		for( var Page in getPath() )
		{
			if( !Page.isRoot() ) slug &= Page.getUUID() & "/";
		}
		slug &= getUUID();
		return slug;
	}	
	
	boolean function hasChild()
	{
		return ArrayLen( getFirstChild() );
	}

	boolean function hasContent()
	{
		return Len( Trim( getContent() ) );
	}

	boolean function hasDescendents()
	{
		return ArrayLen( getDescendents() );
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
		{
			if( StructKeyExists( route, getSlug() ) ) return true;
		}
		return false;
	}
	
	boolean function isChild()
	{
		return getLevel() != 0;
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
	
	boolean function isUUIDUnique()
	{
		var matches = []; 
		if( isPersisted() ) matches = ORMExecuteQuery( "from Page where pageid <> :pageid and uuid = :uuid", { pageid=getPageID(), uuid=getUUID()} );
		else matches = ORMExecuteQuery( "from Page where uuid=:uuid", { uuid=getUUID() } );
		return !ArrayLen( matches );
	}	

	void function preInsert()
	{
		super.preInsert();
		setUUID();
	}
	
	void function preUpdate()
	{
		super.preUpdate();
		setUUID();
	}

	void function setMetaDescription( string metadescription="" )
	{
		var MetaData = CreateObject( "component", "model.beans.MetaData" );
		if( !Len( Trim( arguments.metadescription ) ) && hasContent() ) variables.metadescription = MetaData.generateMetaDescription( getContent() );
		else variables.metadescription = arguments.metadescription;
	}

	void function setMetaKeywords( string metakeywords="" )
	{
		var MetaData = CreateObject( "component", "model.beans.MetaData" );
		if( !hasMetaKeywords() && hasContent() ) variables.metakeywords = MetaData.generateMetaKeywords( getContent() );
		else variables.metakeywords = arguments.metakeywords;
	}

	void function setMetaTitle( string metatitle="" )
	{
		if( !Len( Trim( arguments.metatitle ) ) ) variables.metatitle = getTitle();
		else variables.metatitle = arguments.metatitle;
	}

	void function setUUID()
	{
		variables.uuid = ReReplace( LCase( getNavigationTitle() ), "[^a-z0-9]{1,}", "", "all" );
		while ( !isUUIDUnique() ) variables.uuid &= "_"; 
	}
		
}