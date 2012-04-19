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
	
	any function init()
	{
		return this;
	}
	
	boolean function deletePage( required numeric pageid )
	{
		var Page = getPageByID( arguments.pageid );
		if( !IsNull( Page ) )
		{
			transaction
			{
				var startvalue = Page.getLeftValue();
				ORMExecuteQuery( "update Page set leftvalue = leftvalue - 2 where leftvalue > :startvalue", { startvalue=startvalue } );
				ORMExecuteQuery( "update Page set rightvalue = rightvalue - 2 where rightvalue > :startvalue", { startvalue=startvalue } );
				EntityDelete( Page );
				result = true;
			}
		}
		else
		{
			result = false;
		}
		return result;
	}
	
	array function getPages()
	{
		return EntityLoad( "Page", {}, "leftvalue" );		
	}
	
	any function getPageByID( required numeric pageid )
	{
		return EntityLoadByPK( "Page", arguments.pageid );
	}
	
	any function getPageBySlug( required string slug )
	{
		return getPageByID( Val( ListLast( arguments.slug, "-" ) ) );
	}	
	
	any function getRoot()
	{
		return EntityLoad( "Page", { leftvalue = 1 }, true );
	}	
	
	/*
	struct function movePage( required numeric pageid, required string direction )
	{
		var decreaseamount = "";
		var increaseamount = "";
		var nextsibling = "";
		var nextsiblingdescendentidlist = "";
		var previoussibling = "";
		var previoussiblingdescendentidlist = "";
		var Page = getPageByID( arguments.pageid );
		var result = { success=false, message="The page could not be moved." };
		if( rc.Page.isPersisted() )
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
						if( ListLen( Page.getDescendentPageIDList() ) )
						{
							ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { decreaseamount=Val( decreaseamount ) } );
						}
						if( ListLen( previoussiblingdescendentidlist ) )
						{
							ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #previoussiblingdescendentidlist# )", { increaseamount=Val( increaseamount ) } );
						}
						Page.setLeftValue( Page.getLeftValue() - decreaseamount );
						Page.setRightValue( Page.getRightValue() - decreaseamount );
						previoussibling.setLeftValue( previoussibling.getLeftValue() + increaseamount );
						previoussibling.setRightValue( previoussibling.getRightValue() + increaseamount );
						savePage( Page );
						savePage( previoussibling );
					}
					result = { success=true, message="The page has been moved." };
				}
			}
			else if( rc.direction eq "down" )
			{
				if( Page.hasNextSibling() )
				{
					decreaseamount = Page.getRightValue() - Page.getLeftValue() + 1;
					nextsibling = Page.getNextSibling();
					nextsiblingdescendentidlist = nextsibling.getDescendentPageIDList();
					increaseamount = nextsibling.getRightValue() - nextsibling.getLeftValue() + 1;
					transaction
					{
						if( ListLen( Page.getDescendentPageIDList() ) )
						{
							ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { increaseamount=Val( increaseamount ) } );
						}
						if( ListLen( nextsiblingdescendentidlist ) )
						{
							ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #nextsiblingdescendentidlist# )", { decreaseamount=Val( decreaseamount ) } );
						}
						Page.setLeftValue( Page.getLeftValue() + increaseamount );
						Page.setRightValue( Page.getRightValue() + increaseamount );
						nextsibling.setLeftValue( nextsibling.getLeftValue() - decreaseamount );
						nextsibling.setRightValue( nextsibling.getRightValue() - decreaseamount );
						savePage( Page );
						savePage( nextsibling );
					}
					result = { success=true, message="The page has been moved." };
				}
			}
		}
		return result;
	}
	*/
	
	any function newPage()
	{
		return EntityNew( "Page" );
	}		
	
	function savePage( required struct properties, required numeric ancestorid )
	{
		transaction
		{
			var Page = ""; 
			Page = getPageByID( Val( arguments.properties.pageid ) );
			if( IsNull( Page ) ) Page = newPage();
			Page.populate( arguments.properties );
			var result = application.ValidateThis.validate( Page );
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
			}
			else
			{
				transaction action="rollback";
			}
		}
		return result;
	}
	
}