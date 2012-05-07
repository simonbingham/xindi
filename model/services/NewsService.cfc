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

component accessors="true"
{

	/*
	 * Dependency injection
	 */	
	
	property name="MetaData" getter="false";
	property name="Validator" getter="false";

	/*
	 * Public methods
	 */
	 	
	function init()
	{
		return this;
	}
	
	struct function deleteArticle( required numeric articleid )
	{
		var Article = getArticleByID( arguments.articleid );
		var result = {};
		if( Article.isPersisted() )
		{
			transaction
			{
				EntityDelete( Article );
				result.messages.success = "The article has been deleted.";
			}
		}
		else
		{
			result.messages.error = "The article could not be deleted.";
		}
		return result;
	}
	
	function getArticleByID( required numeric articleid )
	{
		var Article = EntityLoadByPK( "Article", arguments.articleid );
		if( IsNull( Article ) ) Article = newArticle();
		return Article;
	}
	
	function getArticleByUUID( required string uuid )
	{
		var Article = ORMExecuteQuery( "from Article where uuid=:uuid and published<=:published", { uuid=arguments.uuid, published=Now() }, true );
		if( IsNull( Article ) ) Article = newArticle();
		return Article;
	}

	array function getArticles( boolean published=false )
	{
		if( arguments.published ) return ORMExecuteQuery( "from Article where published <= :published order by published desc", { published=Now() } );
		return EntityLoad( "Article", {}, "published desc" );
	}
		
	function getValidator( required any Article )
	{
		return variables.Validator.getValidator( theObject=arguments.Article );
	}
	
	function saveArticle( required struct properties )
	{
		transaction
		{
			var Article = ""; 
			Article = getArticleByID( Val( arguments.properties.articleid ) );
			Article.populate( arguments.properties );
			if( IsNull( Article.getContent() ) ) Article.setContent( "" );
			if( !Article.hasMetaTitle() ) Article.setMetaTitle( Article.getTitle() );
			if( !Article.hasMetaDescription() ) Article.setMetaDescription( variables.MetaData.generateMetaDescription( Article.getContent() ) );
			if( !Article.hasMetaKeywords() ) Article.setMetaKeywords( variables.MetaData.generateMetaKeywords( Article.getContent() ) );
			var result = variables.Validator.validate( theObject=Article );
			if( !result.hasErrors() )
			{
				EntitySave( Article );
				transaction action="commit";
				result.messages.success = "The article has been saved.";
			}
			else
			{
				transaction action="rollback";
				result.messages.error = "Your article could not be saved. Please amend the following:";
			}
		}
		return result;
	}
	
	/*
	 * Private methods
	 */	
	
	private function newArticle()
	{
		return EntityNew( "Article" );
	}	
	
}