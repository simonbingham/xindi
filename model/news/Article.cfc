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

component extends="model.abstract.BaseEntity" persistent="true" table="articles" cacheuse="transactional"{

	// ------------------------ PROPERTIES ------------------------ //

	property name="articleid" column="article_id" fieldtype="id" setter="false" generator="native";
	
	property name="uuid" column="article_uuid" ormtype="string" length="150";
	property name="title" column="article_title" ormtype="string" length="150";
	property name="content" column="article_content" ormtype="text";
	property name="metagenerated" column="article_metagenerated" ormtype="boolean";
	property name="metatitle" column="article_metatitle" ormtype="string" length="69";
	property name="metadescription" column="article_metadescription" ormtype="string" length="169";
	property name="metakeywords" column="article_metakeywords" ormtype="string" length="169";
	property name="published" column="article_published" ormtype="timestamp";
	property name="created" column="article_created" ormtype="timestamp";
	property name="updated" column="article_updated" ormtype="timestamp";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
     * I initialise this component
	 */
	Article function init(){
		variables.metagenerated = true;
		return this;
	}

	/**
     * I return the summary in xml format
	 */
	string function getRSSSummary() {
		return XMLFormat( getSummary() );
	}

	/**
     * I return the summary
	 */
	string function getSummary(){
		var plaintext = Trim( ReReplace( REReplaceNoCase( Trim( getContent() ), "<[^>]{1,}>", " ", "all" ), " +", " ", "all" ) );
		if( Len( plaintext ) > 500 ){
			return Left( plaintext, 500 ) & "...";
		}
		return plaintext;
	}

	/**
     * I return true if the article has a meta description
	 */
	boolean function hasMetaDescription(){
		return Len( Trim( getMetaDescription() ) );	
	}
	
	/**
     * I return true if the article has meta keywords
	 */	
	boolean function hasMetaKeywords(){
		return Len( Trim( getMetaKeywords() ) );
	}

	/**
     * I return true if the article has a meta title
	 */
	boolean function hasMetaTitle(){
		return Len( Trim( getMetaTitle() ) );		
	}

	/**
     * I return true if the article meta tags are generated automatically
	 */
	boolean function isMetaGenerated(){
		return getMetaGenerated();
	}

	/**
     * I return true if the article is new
	 */
	boolean function isNew(){
		return DateDiff( "ww", getPublished(), Now() ) < 1;
	}

	/**
     * I return true if the article is persisted
	 */
	boolean function isPersisted(){
		return !IsNull( variables.articleid );
	}
	
	/**
     * I return true if the article is published
	 */	
	boolean function isPublished(){
		return variables.published < Now();
	}

	/**
	* I am called before inserting the article into the database
	*/
	void function preInsert(){
		setUUID();
	}
	
	/**
	 * I am called before the article is updated in the database
	 */	
	void function preUpdate(){
		setUUID();
	}

	// ------------------------ PRIVATE METHODS ------------------------ //

	/**
     * I return true if the id of the article is unique
	 */	
	private boolean function isUUIDUnique(){
		var matches = []; 
		if( isPersisted() ) matches = ORMExecuteQuery( "from Article where articleid <> :articleid and uuid = :uuid", { articleid=getArticleID(), uuid=getUUID()});
		else matches = ORMExecuteQuery( "from Article where uuid=:uuid", { uuid=getUUID() });
		return !ArrayLen( matches );
	}

	/**
     * I generate a unique id for the article
	 */		
	private void function setUUID(){
		variables.uuid = ReReplace( LCase( getTitle() ), "[^a-z0-9]{1,}", "-", "all" );
		while ( !isUUIDUnique() ) variables.uuid &= "-"; 
	}
		
}