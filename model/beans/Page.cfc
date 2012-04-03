component persistent="true" table="pages" cacheuse="transactional"   
{

	property name="pageid" fieldtype="id" setter="false" generator="native" column="page_id";
	
	property name="uuid" column="page_uuid" ormtype="string" length="150" default="";
	property name="leftvalue" column="page_left" ormtype="int" default="";
	property name="rightvalue" column="page_right" ormtype="int" default="";
	property name="title" column="page_title" ormtype="string" length="150" default="";
	property name="menutitle" column="page_menutitle" ormtype="string" length="150" default="";
	property name="content" column="page_content" ormtype="text" default="";
	property name="metatitle" column="page_metatitle" ormtype="string" length="200" default="";
	property name="metadescription" column="page_metadescription" ormtype="string" length="200" default="";
	property name="metakeywords" column="page_metakeywords" ormtype="string" length="200" default="";
	property name="created" column="page_created" ormtype="timestamp";
	property name="updated" column="page_updated" ormtype="timestamp";

	public Page function init()
	{
		return this;
	}
	
	public numeric function getDescendentCount()
	{
		return ( variables.rightvalue - variables.leftvalue - 1 ) / 2;
	}

	public array function getFirstChild()
	{
		return ORMExecuteQuery( "from Page where leftvalue = :leftvalue", { leftvalue=variables.leftvalue + 1 } );
	}	

	public array function getLastChild()
	{
		return ORMExecuteQuery( "from Page where rightvalue = :rightvalue", { rightvalue=variables.rightvalue - 1 } );
	}	
	
	public any function getLevel()
	{
		return ORMExecuteQuery( "select Count( pageSubQuery ) from Page as pageSubQuery where pageSubQuery.leftvalue < :leftvalue and pageSubQuery.rightvalue > :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } )[ 1 ];
	}

	public any function getNextSibling()
	{
		return ORMExecuteQuery( "from Page where leftvalue = :leftvalue", { leftvalue=variables.rightvalue + 1 }, true );
	}
	
	public any function getAncestor()
	{
		return ORMExecuteQuery( "from Page where leftvalue < :leftvalue and rightvalue > :rightvalue order by leftvalue desc", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue }, { maxresults=1 } );
	}	

	public string function getDescendentPageIDList()
	{
		var looppage = "";
		var pageidlist = "";
		for( looppage in getDescendents() ){
			pageidlist = ListAppend( pageidlist, looppage.getPageID() );
		}
		return pageidlist; 
	}
	
	public array function getDescendents()
	{
		return ORMExecuteQuery( "from Page where leftvalue > :leftvalue and rightvalue < :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } );
	}	
	
	public array function getPath()
	{
		return ORMExecuteQuery( "from Page where leftvalue < :leftvalue and rightvalue > :rightvalue", { leftvalue=variables.leftvalue, rightvalue=variables.rightvalue } );
	}	

	public any function getPreviousSibling()
	{
		return ORMExecuteQuery( "from Page where rightvalue = :rightvalue", { rightvalue=variables.leftvalue - 1 }, true );
	}
	
	public string function getUUID()
	{
		return variables.uuid & getPageID();
	}	
	
	public boolean function hasChild()
	{
		return ArrayLen( getFirstChild() );
	}

	public boolean function hasDescendents()
	{
		return ArrayLen( getDescendents() );
	}

	public boolean function hasNextSibling()
	{
		return !IsNull( getNextSibling() );
	}

	public boolean function hasPreviousSibling()
	{
		return !IsNull( getPreviousSibling() );
	}
			
	public boolean function hasRoute( array routes=[] )
	{
		for( var route in arguments.routes )
		{
			if( StructKeyExists( route, getUUID() ) ) return true;
		}
		return false;
	}
	
	public boolean function isChild()
	{
		return getLevel() != 0;
	}	

	public boolean function isLeaf()
	{
		return getDescendentCount() == 0;
	}	
	
	public boolean function isRoot()
	{
		return getLevel() == 0;
	}
	
	public void function preInsert()
	{
		variables.uuid = ReReplace( LCase( getMenuTitle() ), "[^a-z0-9]{1,}", "-", "all" ) & "-";
	}
	
}