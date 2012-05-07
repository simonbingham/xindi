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

component extends="Base" persistent="true" table="articles" cacheuse="transactional"   
{

	/*
	 * Properties
	 */

	property name="articleid" fieldtype="id" setter="false" generator="native" column="article_id";
	
	property name="uuid" column="article_uuid" ormtype="string" length="150" default="";
	property name="title" column="article_title" ormtype="string" length="150" default="";
	property name="content" column="article_content" ormtype="text" default="";
	property name="metatitle" column="article_metatitle" ormtype="string" length="200" default="";
	property name="metadescription" column="article_metadescription" ormtype="string" length="200" default="";
	property name="metakeywords" column="article_metakeywords" ormtype="string" length="200" default="";
	property name="published" column="article_published" ormtype="timestamp";
	property name="created" column="article_created" ormtype="timestamp";
	property name="updated" column="article_updated" ormtype="timestamp";

	/*
	 * Public methods
	 */

	Article function init()
	{
		return this;
	}

	string function getRSSSummary() 
	{
		return XMLFormat( getSummary() );
	}

	string function getSummary()
	{
		return Left( REReplaceNoCase( Trim( getContent() ), "<[^>]{1,}>", " ", "all" ), 500 ) & "...";
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
	
	boolean function isPersisted()
	{
		return !IsNull( variables.articleid );
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

	private boolean function isUUIDUnique()
	{
		var matches = []; 
		if( isPersisted() ) matches = ORMExecuteQuery( "from Article where articleid <> :articleid and uuid = :uuid", { articleid=getArticleID(), uuid=getUUID()} );
		else matches = ORMExecuteQuery( "from Article where uuid=:uuid", { uuid=getUUID() } );
		return !ArrayLen( matches );
	}

	private void function setUUID()
	{
		variables.uuid = ReReplace( LCase( getTitle() ), "[^a-z0-9]{1,}", "", "all" );
		while ( !isUUIDUnique() ) variables.uuid &= "-"; 
	}
		
}