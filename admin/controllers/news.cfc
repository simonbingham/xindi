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

component accessors="true" extends="abstract"{
	
	/*
	 * Public methods
	 */	

	void function before( required struct rc ){
		super.before( arguments.rc );
	}

	void function default( required struct rc ){
		rc.articles = variables.NewsService.getArticles();
	}

	void function delete( required struct rc ){
		param name="rc.articleid" default="0";
		rc.result = variables.NewsService.deleteArticle( rc.articleid );
		variables.fw.redirect( "news", "result" );
	}
	
	void function maintain( required struct rc ){
		param name="rc.articleid" default="0";
		if( !StructKeyExists( rc, "Article" ) ) rc.Article = variables.NewsService.getArticle( rc.articleid );
		rc.Validator = variables.NewsService.getValidator( rc.Article );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
	}	
	
	void function save( required struct rc ){
		param name="rc.articleid" default="0";
		param name="rc.title" default="";
		param name="rc.published" default="";
		param name="rc.content" default="";
		param name="rc.metagenerated" default="false";
		param name="rc.metatitle" default="";
		param name="rc.metadescription" default="";
		param name="rc.metakeywords" default="";
		param name="rc.submit" default="Save & exit";
		rc.result = variables.NewsService.saveArticle( rc );
		rc.Article = rc.result.getTheObject();
		if( rc.result.getIsSuccess() ){
			if( rc.submit == "Save & Continue" ) variables.fw.redirect( "news.maintain", "Article,result", "articleid" );
			else variables.fw.redirect( "news", "result" );
		}else{
			variables.fw.redirect( "news.maintain", "Article,result", "articleid" );
		}
	}
	
}