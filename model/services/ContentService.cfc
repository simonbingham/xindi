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
	 	
	struct function deletePage( required numeric pageid )
	{
		var Page = getPageByID( arguments.pageid );
		var result = {};
		if( Page.isPersisted() )
		{
			transaction
			{
				var startvalue = Page.getLeftValue();
				ORMExecuteQuery( "update Page set leftvalue = leftvalue - 2 where leftvalue > :startvalue", { startvalue=startvalue } );
				ORMExecuteQuery( "update Page set rightvalue = rightvalue - 2 where rightvalue > :startvalue", { startvalue=startvalue } );
				EntityDelete( Page );
				result.messages.success = "The page has been deleted.";
			}
		}
		else
		{
			result.messages.error = "The page could not be deleted.";
		}
		return result;
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

	array function getPages( string searchterm="" )
	{
		if( Len( Trim( arguments.searchterm ) ) ) return ORMExecuteQuery( "from Page where lower( title ) like :searchterm or lower( navigationtitle ) like :searchterm or lower( content ) like :searchterm", { searchterm="%#Lcase( arguments.searchterm )#%" } );
		else return EntityLoad( "Page", {}, "leftvalue" );
	}
		
	function getRoot()
	{
		return EntityLoad( "Page", { leftvalue = 1 }, true );
	}	
	
	function getValidator( required any Page )
	{
		return variables.Validator.getValidator( theObject=arguments.Page );
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
		var result = {};
		if( Page.isPersisted() && ListFindNoCase( "up,down", Trim( arguments.direction ) ) )
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
					result.messages.success = "The page has been moved.";
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
					result.messages.success = "The page has been moved.";
				}
			}
		}
		else
		{
			result.messages.error = "The page could not be moved.";
		}
		return result;
	}
	
	function savePage( required struct properties, required numeric ancestorid, required string context )
	{
		transaction
		{
			var Page = "";
			Page = getPageByID( Val( arguments.properties.pageid ) );
			Page.populate( arguments.properties );
			if( IsNull( Page.getContent() ) ) Page.setContent( "" );
			if( !Page.hasMetaTitle() ) Page.setMetaTitle( Page.getTitle() );
			if( !Page.hasMetaDescription() ) Page.setMetaDescription( variables.MetaData.generateMetaDescription( Page.getContent() ) );
			if( !Page.hasMetaKeywords() ) Page.setMetaKeywords( variables.MetaData.generateMetaKeywords( Page.getContent() ) );			
			var result = variables.Validator.validate( theObject=Page, Context=arguments.context );
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
				result.messages.success = "The page has been saved.";
			}
			else
			{
				transaction action="rollback";
				result.messages.error = "Your page could not be saved. Please amend the following:";
			}
		}
		return result;
	}
	
	/*
	 * Private methods
	 */	
	
	private function newPage()
	{
		return EntityNew( "Page" );
	}	
	
}