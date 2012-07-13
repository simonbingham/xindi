<!---
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
--->

<cfcomponent accessors="true" output="false" extends="model.abstract.BaseGateway">
	<cfscript>
		// ------------------------ PUBLIC METHODS ------------------------ //		
		
		/**
		 * I delete a page
		 */			
		void function deletePage( required Page thePage ){
			var startvalue = arguments.thePage.getLeftValue();
			ORMExecuteQuery( "update Page set leftvalue = leftvalue - 2 where leftvalue > :startvalue", { startvalue=startvalue });
			ORMExecuteQuery( "update Page set rightvalue = rightvalue - 2 where rightvalue > :startvalue", { startvalue=startvalue });
			delete( arguments.thePage );
		}
		
		/**
		 * I return a page matching an id
		 */			
		Page function getPage( required numeric pageid ){
			return get( "Page", arguments.pageid );
		}

		/**
		 * I return a page matching a slug
		 */			
		Page function getPageBySlug( required string slug ){
			var Page = EntityLoad( "Page", { label=Trim( ListLast( arguments.slug, "/" ) ) }, TRUE );
			if( IsNull( Page ) ) Page = new( "Page" );
			return Page;
		}
		
		/**
		 * I return the root page (i.e. home page)
		 */			
		Page function getRoot(){
			return EntityLoad( "Page", { leftvalue=1 }, true );
		}
	</cfscript>
	
	<cffunction name="getPages" output="false" returntype="Array" hint="I return an array of pages">
		<cfargument name="searchterm" type="string" required="false" default="">
		<cfargument name="sortorder" type="string" required="false" default="leftvalue">
		<cfargument name="maxresults" type="numeric" required="false" default="0">
		<cfset var qPages = "">
		<cfset var thesearchterm = Trim( arguments.searchterm )>
		<cfset var ormoptions = {}>
		<cfif arguments.maxresults>
			<cfset ormoptions.maxresults = arguments.maxresults>
		</cfif>
		<cfquery name="qPages" dbtype="hql" ormoptions="#ormoptions#">
			from Page
			where 1=1
			<cfif Len( thesearchterm )>
				and 
				(	
				 	lower( title ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%"> 
				 	or lower( content ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%">
				) 
			</cfif>
			order by #arguments.sortorder#
		</cfquery>
		<cfreturn qPages>
	</cffunction>
	
	<cfscript>
		/**
		 * I move a page
		 */			
		Page function movePage( required Page thePage, required string direction ){
			var decreaseamount = "";
			var increaseamount = "";
			if( arguments.direction eq "up" ){
				if( thePage.hasPreviousSibling() ){
					increaseamount = thePage.getRightValue() - thePage.getLeftValue() + 1;
					var PreviousSibling = thePage.getPreviousSibling();
					var previoussiblingdescendentidlist = PreviousSibling.getDescendentPageIDList();
					decreaseamount = PreviousSibling.getRightValue() - PreviousSibling.getLeftValue() + 1;
					if( ListLen( thePage.getDescendentPageIDList() ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { decreaseamount=decreaseamount });
					if( ListLen( previoussiblingdescendentidlist ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #previoussiblingdescendentidlist# )", { increaseamount=increaseamount });
					thePage.setLeftValue( thePage.getLeftValue() - decreaseamount );
					thePage.setRightValue( thePage.getRightValue() - decreaseamount );
					PreviousSibling.setLeftValue( previoussibling.getLeftValue() + increaseamount );
					PreviousSibling.setRightValue( previoussibling.getRightValue() + increaseamount );
					save( thePage );
					save( PreviousSibling );
				}
			}else{
				if( thePage.hasNextSibling() ){
					decreaseamount = thePage.getRightValue() - thePage.getLeftValue() + 1;
					var NextSibling = thePage.getNextSibling();
					var nextsiblingdescendentidlist = NextSibling.getDescendentPageIDList();
					increaseamount = NextSibling.getRightValue() - NextSibling.getLeftValue() + 1;
					if( ListLen( thePage.getDescendentPageIDList() ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { increaseamount=increaseamount });
					if( ListLen( nextsiblingdescendentidlist ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #nextsiblingdescendentidlist# )", { decreaseamount=decreaseamount });
					thePage.setLeftValue( thePage.getLeftValue() + increaseamount );
					thePage.setRightValue( thePage.getRightValue() + increaseamount );
					NextSibling.setLeftValue( nextsibling.getLeftValue() - decreaseamount );
					NextSibling.setRightValue( nextsibling.getRightValue() - decreaseamount );
					save( thePage );
					save( NextSibling );
				}
			}
			return thePage;
		}
		
		/**
		 * I save a page
		 */			
		Page function savePage( required Page thePage, required numeric ancestorid ){
			if( !arguments.thePage.isPersisted() && arguments.ancestorid ){
				var Ancestor = get( "Page", arguments.ancestorid );
				arguments.thePage.setLeftValue( Ancestor.getRightValue() );
				arguments.thePage.setRightValue( Ancestor.getRightValue() + 1 );
				ORMExecuteQuery( "update Page set leftvalue = leftvalue + 2 where leftvalue > :startingvalue", { startingvalue=Ancestor.getRightValue() - 1 } );
				ORMExecuteQuery( "update Page set rightvalue = rightvalue + 2 where rightvalue > :startingvalue", { startingvalue=Ancestor.getRightValue() - 1 } );
				return save( arguments.thePage );
			}else if( arguments.thePage.isPersisted() ){
				return save( arguments.thePage );
			}
		}
	</cfscript>
</cfcomponent>