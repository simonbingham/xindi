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

component accessors="true"
{
	
	function init()
	{
		return this;
	}
	
	struct function deletePage( required numeric pageid, required string basehref, required boolean sesomitindex )
	{
		var Page = getPageByID( arguments.pageid );
		var messages = {};
		if( Page.isPersisted() )
		{
			transaction
			{
				var startvalue = Page.getLeftValue();
				ORMExecuteQuery( "update Page set leftvalue = leftvalue - 2 where leftvalue > :startvalue", { startvalue=startvalue } );
				ORMExecuteQuery( "update Page set rightvalue = rightvalue - 2 where rightvalue > :startvalue", { startvalue=startvalue } );
				EntityDelete( Page );
				updateSitemapXML( arguments.basehref, sesomitindex );
				messages.success = "The page has been deleted.";
			}
		}
		else
		{
			messages.error = "The page could not be deleted.";
		}
		return messages;
	}
	
	function getPageByID( required numeric pageid )
	{
		var Page = EntityLoadByPK( "Page", arguments.pageid );
		if( IsNull( Page ) ) Page = newPage();
		return Page;
	}
	
	function getPageBySlug( required string slug )
	{
		var Page = EntityLoad( "Page", { uuid=Trim( ListLast( arguments.slug, "/" ) ) }, TRUE );
		if( IsNull( Page ) ) Page = newPage();
		return Page;
	}

	array function getPages()
	{
		return EntityLoad( "Page", {}, "leftvalue" );		
	}
		
	function getRoot()
	{
		return EntityLoad( "Page", { leftvalue = 1 }, true );
	}	
	
	function getValidator( required any ValidateThis, required any Page )
	{
		return arguments.ValidateThis.getValidator( theObject=arguments.Page );
	}
	
	struct function movePage( required numeric pageid, required string direction )
	{
		var decreaseamount = "";
		var increaseamount = "";
		var nextsibling = "";
		var nextsiblingdescendentidlist = "";
		var previoussibling = "";
		var previoussiblingdescendentidlist = "";
		var Page = getPageByID( arguments.pageid );
		var messages = "";
		if( !Page.isPersisted() && ListFind( "up,down", Trim( arguments.direction ) ) )
		{
			if( arguments.direction eq "up" )
			{
				if( Page.hasPreviousSibling() )
				{
					increaseamount = Page.getRightValue() - Page.getLeftValue() + 1;
					previoussibling = Page.getPreviousSibling();
					previoussiblingdescendentidlist = previoussibling.getDescendentPageIDList();
					decreaseamount = previoussibling.getRightValue() - previoussibling.getLeftValue() + 1;
					transaction{
						if( ListLen( Page.getDescendentPageIDList() ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { decreaseamount=Val( decreaseamount ) } );
						if( ListLen( previoussiblingdescendentidlist ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #previoussiblingdescendentidlist# )", { increaseamount=Val( increaseamount ) } );
						Page.setLeftValue( Page.getLeftValue() - decreaseamount );
						Page.setRightValue( Page.getRightValue() - decreaseamount );
						previoussibling.setLeftValue( previoussibling.getLeftValue() + increaseamount );
						previoussibling.setRightValue( previoussibling.getRightValue() + increaseamount );
						EntitySave( Page );
						EntitySave( previoussibling );
					}
					messages.success="The page has been moved.";
				}
			}
			else
			{
				if( Page.hasNextSibling() )
				{
					decreaseamount = Page.getRightValue() - Page.getLeftValue() + 1;
					nextsibling = Page.getNextSibling();
					nextsiblingdescendentidlist = nextsibling.getDescendentPageIDList();
					increaseamount = nextsibling.getRightValue() - nextsibling.getLeftValue() + 1;
					transaction
					{
						if( ListLen( Page.getDescendentPageIDList() ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { increaseamount=Val( increaseamount ) } );
						if( ListLen( nextsiblingdescendentidlist ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #nextsiblingdescendentidlist# )", { decreaseamount=Val( decreaseamount ) } );
						Page.setLeftValue( Page.getLeftValue() + increaseamount );
						Page.setRightValue( Page.getRightValue() + increaseamount );
						nextsibling.setLeftValue( nextsibling.getLeftValue() - decreaseamount );
						nextsibling.setRightValue( nextsibling.getRightValue() - decreaseamount );
						EntitySave( Page );
						EntitySave( nextsibling );
					}
					messages.success="The page has been moved.";
				}
			}
		}
		else
		{
			messages.error = "The page could not be moved.";
		}
		return messages;
	}
	
	private function newPage()
	{
		return EntityNew( "Page" );
	}	
	
	function savePage( required struct properties, required numeric ancestorid, required any ValidateThis, required string basehref, required boolean sesomitindex )
	{
		transaction
		{
			var Page = ""; 
			Page = getPageByID( Val( arguments.properties.pageid ) );
			Page.populate( arguments.properties );
			if( !Page.hasMetaTitle() ) Page.setMetaTitle( Page.getTitle() );
			var MetaData = CreateObject( "component", "model.beans.MetaData" ).init();
			if( !Page.hasMetaDescription() && Page.hasContent() ) Page.setMetaDescription( MetaData.generateMetaDescription( Page.getContent() ) );
			if( !Page.hasMetaKeywords() && Page.hasContent() ) Page.setMetaKeywords( MetaData.generateMetaKeywords( Page.getContent() ) );
			var result = arguments.ValidateThis.validate( Page );
			if( !result.hasErrors() )
			{
				if( !Page.isPersisted() && arguments.ancestorid )
				{
					var Ancestor = getPageByID( arguments.ancestorid );
					Page.setLeftValue( Val( Ancestor.getRightValue() ) );
					Page.setRightValue( Val( Ancestor.getRightValue() + 1 ) );
					ORMExecuteQuery( "update Page set leftvalue = leftvalue + 2 where leftvalue > :startingvalue", { startingvalue=Val( Ancestor.getRightValue() - 1 ) } );
					ORMExecuteQuery( "update Page set rightvalue = rightvalue + 2 where rightvalue > :startingvalue", { startingvalue=Val( Ancestor.getRightValue() - 1 ) } );
					EntitySave( Page );
					transaction action="commit";
				}
				else if( Page.isPersisted() )
				{
					EntitySave( Page );
					transaction action="commit";
				}
				updateSitemapXML( arguments.basehref, sesomitindex  );
			}
			else
			{
				transaction action="rollback";
			}
		}
		return result;
	}
	
	private void function updateSitemapXML( required string basehref, required boolean sesomitindex )
	{
		var pages = getPages();
		var sitemap = "<?xml version='1.0' encoding='UTF-8'?><urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'>";
		for( var Page in pages ){
			if( arguments.sesomitindex ) sitemap &= "<url><loc>#arguments.basehref##local.Page.getSlug()#</loc></url>";
			else sitemap &= "<url><loc>#arguments.basehref#index.cfm/#local.Page.getSlug()#</loc></url>";
		} 
		sitemap &= "</urlset>";
		FileWrite( ExpandPath( "./" ) & "sitemap.xml", sitemap );
	}		
	
}