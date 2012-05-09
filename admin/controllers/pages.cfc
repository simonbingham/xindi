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

component accessors="true" extends="abstract"   
{
	
	/*
	 * Dependency injection
	 */		

	property name="ContentService" setter="true" getter="false";

	/*
	 * Public methods
	 */	

	void function default( required struct rc ) {
		rc.pages = variables.ContentService.getPages();
	}

	void function delete( required struct rc ) {
		param name="rc.pageid" default="0";
		var result = variables.ContentService.deletePage( Val( rc.pageid ) );
		rc.messages = result.messages;
		if( StructKeyExists( result.messages, "success" ) )
		{
			var refreshsitemap = new Http( url="#rc.basehref#index.cfm/public:navigation/xml", method="get" );
			refreshsitemap.send();
		}
		variables.fw.redirect( "pages", "messages" );
	}	
	
	void function maintain( required struct rc ) {
		param name="rc.pageid" default="0";
		param name="rc.context" default="create";
		if( !StructKeyExists( rc, "Page" ) ) rc.Page = variables.ContentService.getPageByID( Val( rc.pageid ) );
		if( rc.Page.isPersisted() && !rc.Page.hasRoute( variables.fw.getRoutes() ) ) rc.context = "update";
		rc.Validator = variables.ContentService.getValidator( rc.Page );
	}	
	
	void function move( required struct rc ) {
		param name="rc.pageid" default="0";
		param name="rc.direction" default="";
		var result = variables.ContentService.movePage( Val( rc.pageid ), rc.direction );
		rc.messages = result.messages;
		variables.fw.redirect( "pages", "messages" );
	}	
	
	void function save( required struct rc ) {
		param name="rc.pageid" default="0";
		param name="rc.ancestorid" default="0";
		param name="rc.title" default="";
		param name="rc.navigationtitle" default="";
		param name="rc.content" default="";
		param name="rc.metatitle" default="";
		param name="rc.metadescription" default="";
		param name="rc.metakeywords" default="";
		param name="rc.context" default="create";
		var properties = { pageid=rc.pageid, title=rc.title, navigationtitle=rc.navigationtitle, content=rc.content, metatitle=rc.metatitle, metadescription=rc.metadescription, metakeywords=rc.metakeywords };
		rc.result = variables.ContentService.savePage( properties, rc.ancestorid, rc.context );
		rc.messages = rc.result.messages;
		if( StructKeyExists( rc.messages, "success" ) )
		{
			var refreshsitemap = new Http( url="#rc.basehref#index.cfm/public:navigation/xml", method="get" );
			refreshsitemap.send();
			variables.fw.redirect( "pages", "messages" );	
		}
		else
		{
			rc.Page = rc.result.getTheObject();
			variables.fw.redirect( "pages/maintain", "messages,Page,pageid,ancestorid,result" );
		}
	}
	
}