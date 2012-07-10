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
		/*
		 * Public methods
		 */			
		
		function deletePage( required Page ){
			var startvalue = arguments.Page.getLeftValue();
			ORMExecuteQuery( "update Page set leftvalue = leftvalue - 2 where leftvalue > :startvalue", { startvalue=startvalue });
			ORMExecuteQuery( "update Page set rightvalue = rightvalue - 2 where rightvalue > :startvalue", { startvalue=startvalue });
			delete( arguments.Page );
		}
		
		function getPage( required numeric pageid ){
			return get( "Page", arguments.pageid );
		}
		
		function getPageBySlug( required string slug ){
			var Page = EntityLoad( "Page", { uuid=Trim( ListLast( arguments.slug, "/" ) ) }, TRUE );
			if( IsNull( Page ) ) Page = new( "Page" );
			return Page;
		}
		
		function getRoot(){
			return EntityLoad( "Page", { leftvalue=1 }, true );
		}
	</cfscript>
	
	<cffunction name="getPages" output="false" returntype="Array">
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
		function movePage( required Page, required string direction ){
			var decreaseamount = "";
			var increaseamount = "";
			var nextsibling = "";
			var nextsiblingdescendentidlist = "";
			var previoussibling = "";
			var previoussiblingdescendentidlist = "";
			if( arguments.direction eq "up" ){
				if( Page.hasPreviousSibling() ){
					increaseamount = Page.getRightValue() - Page.getLeftValue() + 1;
					previoussibling = Page.getPreviousSibling();
					previoussiblingdescendentidlist = previoussibling.getDescendentPageIDList();
					decreaseamount = previoussibling.getRightValue() - previoussibling.getLeftValue() + 1;
					if( ListLen( Page.getDescendentPageIDList() ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { decreaseamount=decreaseamount });
					if( ListLen( previoussiblingdescendentidlist ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #previoussiblingdescendentidlist# )", { increaseamount=increaseamount });
					Page.setLeftValue( Page.getLeftValue() - decreaseamount );
					Page.setRightValue( Page.getRightValue() - decreaseamount );
					previoussibling.setLeftValue( previoussibling.getLeftValue() + increaseamount );
					previoussibling.setRightValue( previoussibling.getRightValue() + increaseamount );
					save( Page );
					save( previoussibling );
				}
			}else{
				if( Page.hasNextSibling() ){
					decreaseamount = Page.getRightValue() - Page.getLeftValue() + 1;
					nextsibling = Page.getNextSibling();
					nextsiblingdescendentidlist = nextsibling.getDescendentPageIDList();
					increaseamount = nextsibling.getRightValue() - nextsibling.getLeftValue() + 1;
					if( ListLen( Page.getDescendentPageIDList() ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue + :increaseamount, rightvalue = rightvalue + :increaseamount where pageid in ( #Page.getDescendentPageIDList()# )", { increaseamount=increaseamount });
					if( ListLen( nextsiblingdescendentidlist ) ) ORMExecuteQuery( "update Page set leftvalue = leftvalue - :decreaseamount, rightvalue = rightvalue - :decreaseamount where pageid in ( #nextsiblingdescendentidlist# )", { decreaseamount=decreaseamount });
					Page.setLeftValue( Page.getLeftValue() + increaseamount );
					Page.setRightValue( Page.getRightValue() + increaseamount );
					nextsibling.setLeftValue( nextsibling.getLeftValue() - decreaseamount );
					nextsibling.setRightValue( nextsibling.getRightValue() - decreaseamount );
					save( Page );
					save( nextsibling );
				}
			}
		}
		
		function savePage( required Page, required numeric ancestorid ){
			if( !arguments.Page.isPersisted() && arguments.ancestorid ){
				var Ancestor = get( "Page", arguments.ancestorid );
				arguments.Page.setLeftValue( Ancestor.getRightValue() );
				arguments.Page.setRightValue( Ancestor.getRightValue() + 1 );
				ORMExecuteQuery( "update Page set leftvalue = leftvalue + 2 where leftvalue > :startingvalue", { startingvalue=Ancestor.getRightValue() - 1 } );
				ORMExecuteQuery( "update Page set rightvalue = rightvalue + 2 where rightvalue > :startingvalue", { startingvalue=Ancestor.getRightValue() - 1 } );
				save( arguments.Page );
			}else if( arguments.Page.isPersisted() ){
				save( arguments.Page );
			}
		}
	</cfscript>
</cfcomponent>