/*
	Copyright (c) 2012, Simon Bingham (http://www.simonbingham.me.uk/)
	
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

component accessors="true" extends="abstract"   
{
	
	/*
	 * Dependency injection
	 */		

	property name="NewsService" setter="true" getter="false";

	/*
	 * Public methods
	 */	

	void function default( required struct rc ) {
		rc.articles = variables.NewsService.getArticles();
	}

	void function delete( required struct rc ) {
		param name="rc.articleid" default="0";
		rc.messages = variables.NewsService.deleteArticle( Val( rc.articleid ) );
		/*
		var refreshsitemap = new Http( url="#rc.basehref#index.cfm/public:main/xml", method="get" );
		refreshsitemap.send();
		*/		
		variables.fw.redirect( "news", "messages" );
	}
	
	void function maintain( required struct rc ) {
		param name="rc.articleid" default="0";
		if( !StructKeyExists( rc, "Article" ) ) rc.Article = variables.NewsService.getArticleByID( Val( rc.articleid ) );
		rc.Validator = variables.NewsService.getValidator( rc.Article );
	}	
	
	void function save( required struct rc ) {
		param name="rc.articleid" default="0";
		param name="rc.title" default="";
		param name="rc.published" default="";
		param name="rc.content" default="";
		param name="rc.metatitle" default="";
		param name="rc.metadescription" default="";
		param name="rc.metakeywords" default="";
		var properties = { articleid=rc.articleid, title=rc.title, published=rc.published, content=rc.content, metatitle=rc.metatitle, metadescription=rc.metadescription, metakeywords=rc.metakeywords };
		rc.result = variables.NewsService.saveArticle( properties );
		if( rc.result.hasErrors() )
		{
			rc.Article = rc.result.getTheObject();
			rc.messages.error = "The article could not be saved. Please amend the fields listed below.";
			variables.fw.redirect( "news/maintain", "messages,Article,articleid,result" );
		}
		else
		{
			/*
			var refreshsitemap = new Http( url="#rc.basehref#index.cfm/public:main/xml", method="get" );
			refreshsitemap.send();
			*/
			rc.messages.success = "The article has been saved.";
			variables.fw.redirect( "news", "messages" );	
		}
	}
	
}