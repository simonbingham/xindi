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

component accessors="true" extends="abstract"   
{

	property name="PageService" setter="true" getter="false";

	void function default( required struct rc ) {
		rc.pages = variables.PageService.getPages();
	}

	void function delete( required struct rc ) {
		param name="rc.pageid" default="0";
		rc.messages = variables.PageService.deletePage( Val( rc.pageid ), rc.basehref );
		variables.fw.redirect( "pages", "messages" );
	}	
	
	void function maintain( required struct rc ) {
		param name="rc.pageid" default="0";
		if( !StructKeyExists( rc, "Page" ) ) rc.Page = variables.PageService.getPageByID( Val( rc.pageid ) );
		rc.Validator = variables.PageService.getValidator( rc.Page );
	}	
	
	void function move( required struct rc ) {
		param name="rc.pageid" default="0";
		param name="rc.direction" default="";
		rc.messages = variables.PageService.movePage( Val( rc.pageid ), rc.direction );
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
		var properties = { pageid=rc.pageid, title=rc.title, navigationtitle=rc.navigationtitle, content=rc.content, metatitle=rc.metatitle, metadescription=rc.metadescription, metakeywords=rc.metakeywords };
		rc.result = variables.PageService.savePage( properties, rc.ancestorid, application.ValidateThis, rc.basehref );
		if( rc.result.hasErrors() )
		{
			rc.Page = rc.result.getTheObject();
			rc.messages.error = "The page could not be saved. Please amend the fields listed below.";
			variables.fw.redirect( "pages/maintain", "messages,Page,pageid,ancestorid,result" );
		}
		else
		{
			rc.messages.success = "The page has been saved.";
			variables.fw.redirect( "pages", "messages" );	
		}
	}
	
}