<cfcomponent accessors="true" output="false" extends="model.abstract.BaseGateway">
	<cfscript>
		// ------------------------ PUBLIC METHODS ------------------------ //

		/**
		 * I delete a page
		 */
		void function deletePage(required Page thePage) {
			var startvalue = arguments.thePage.getLeftValue();
			if(!IsNull(startvalue)) {
				ORMExecuteQuery("update Page set leftvalue = leftvalue - 2 where leftvalue > :startvalue", {startvalue=startvalue});
				ORMExecuteQuery("update Page set rightvalue = rightvalue - 2 where rightvalue > :startvalue", {startvalue=startvalue});
			}
			delete(arguments.thePage);
		}
	</cfscript>

	<cffunction name="findContentBySearchTerm" output="false" returntype="query" hint="I return a query of pages and articles that match the search term">
		<cfargument name="searchterm" type="string" required="true">
		<cfargument name="maxresults" type="numeric" required="false" default="50">
		<cfset var qPages = "">
		<cfset var keyword = "">
		<cfif variables.dbengine eq "MYSQL">
			<cfset findFunction = "locate">
		<cfelse>
			<cfset findFunction = "charindex"><!--- MSSQL --->
		</cfif>
		<!--- extract pages and articles that match search term - includes conditional statements based upon datasource type --->
		<cfquery name="qPages" maxrows="#arguments.maxresults#">
			select
				page_id as id
				, page_title as title
				, page_slug as slug
				, page_updated as published
				, page_content as content
				, #findFunction#('#arguments.searchterm#', page_content) - (#findFunction#('#arguments.searchterm#', page_title) * 100) as weighting
				, 'page' as type
			from pages
			where 1 = 1
			<cfloop list="#arguments.searchterm#" index="keyword" delimiters=" ">
				and
				(
				 	page_title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
				 	or page_content like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
				)
			</cfloop>
			union all
			select
				article_id as id
				, article_title as title
				, article_slug as slug
				, article_published as published
				, article_content as content
				, #findFunction#('#arguments.searchterm#', article_content) - (#findFunction#('#arguments.searchterm#', article_title) * 100) as weighting
				, 'article' as type
			from articles
			where 1=1
			<cfloop list="#arguments.searchterm#" index="keyword" delimiters=" ">
				and
				(
				 	article_title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
				 	or article_content like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
				)
			</cfloop>
			order by weighting
		</cfquery>
		<cfreturn qPages>
	</cffunction>

	<cffunction name="getChildren" output="false" returntype="query" hint="I return a query of child pages based upon the left and right value arguments">
		<cfargument name="left" required="true" hint="The left position">
		<cfargument name="right" required="true" hint="The right position">
		<cfargument name="clearcache" required="false" default="false">
		<cfset var qChildren = "">
		<cfif arguments.clearcache>
			<cfset var timespan = CreateTimeSpan(0,0,0,0)>
		<cfelse>
			<cfset var timespan = CreateTimeSpan(0,0,0,30)>
		</cfif>
		<cfquery name="qChildren" cachedwithin="#timespan#">
			select
				page.page_id as pageid
				, page.page_slug as slug
				, page.page_title as title
				, page.page_updated as updated
				, page.page_left as positionleft
				, page.page_right as positionright
				, page.page_updatedby as updatedby
			from pages as page
			where 1 = 1
			and (
					select count(*)
					from pages as pageSubQuery
					where pageSubQuery.page_left < page.page_left
					and pageSubQuery.page_right > page.page_right
				) =
				(select Count(*) from pages where page_left < <cfqueryparam value="#arguments.left#" cfsqltype="cf_sql_integer"> and page_right > <cfqueryparam value="#arguments.right#" cfsqltype="cf_sql_integer">) + 1
			and page_left > <cfqueryparam value="#arguments.left#" cfsqltype="cf_sql_integer">
			and page_right < <cfqueryparam value="#arguments.right#" cfsqltype="cf_sql_integer">
			order by page_left;
		</cfquery>
		<cfreturn qChildren>
	</cffunction>

	<cfscript>
		/**
		 * I return a page matching an id
		 */
		Page function getPage(required numeric pageid) {
			return get("Page", arguments.pageid);
		}

		/**
		 * I return a page matching a slug
		 */
		Page function getPageBySlug(required string slug) {
			var Page = EntityLoad("Page", {slug=arguments.slug}, TRUE);
			if(IsNull(Page)) Page = new("Page");
			return Page;
		}
	</cfscript>

	<cffunction name="getNavigation" output="false" returntype="query" hint="I return the pages used to build the navigation">
		<cfargument name="left" required="false" hint="The left position">
		<cfargument name="right" required="false" hint="The right position">
		<cfargument name="depth" required="false" hint="The page depth">
		<cfargument name="clearcache" required="false" default="false">
		<cfset var qPages = "">
		<cfif arguments.clearcache>
			<cfset var timespan = CreateTimeSpan(0,0,0,0)>
		<cfelse>
			<cfset var timespan = CreateTimeSpan(0,0,0,30)>
		</cfif>
		<cfquery name="qPages" cachedwithin="#timespan#">
			select
				page.page_id as pageid
				, page.page_slug as slug
				, page.page_title as title
				, page.page_updated as updated
				, page.page_left as positionleft
				, page.page_right as positionright
				, page.page_updatedby as updatedby
				, case when page.page_left = 1 then 1 else (
					select count(*)
					from pages as pageSubQuery
					where pageSubQuery.page_left < page.page_left
						and pageSubQuery.page_right > page.page_right
					) end as depth
				, ((page.page_right - page.page_left - 1) / 2) as descendants
			from pages as page
			where 1 = 1
			<cfif StructKeyExists(arguments, "left")>
				and page_left > <cfqueryparam value="#arguments.left#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(arguments, "right")>
				and page_right < <cfqueryparam value="#arguments.right#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(arguments, "depth")>
				and page_depth <= <cfqueryparam value="#arguments.depth#" cfsqltype="cf_sql_integer">
			</cfif>
			order by page_left
		</cfquery>
		<cfreturn qPages>
	</cffunction>

	<cffunction name="getNavigationPath" output="false" returntype="query" hint="returns the pages forming the path to the website root">
		<cfargument name="pageid" required="true" hint="the page id for the end of the trail">
		<cfset var qPages = "">
		<cfquery name="qPages">
			select
				ancestor.page_id as pageid
				, ancestor.page_title as title
				, ancestor.page_slug as slug
			from pages as child,
				pages as ancestor
			where child.page_left >= ancestor.page_left and child.page_left <= ancestor.page_right
				and child.page_id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_integer">
				and ancestor.page_id <> <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_integer"><!--- exclude passed page --->
			order by ancestor.page_left
		</cfquery>
		<cfreturn qPages>
	</cffunction>

	<cffunction name="getPages" output="false" returntype="Array" hint="I return an array of pages">
		<cfargument name="searchterm" type="string" required="false" default="">
		<cfargument name="sortorder" type="string" required="false" default="leftvalue">
		<cfargument name="maxresults" type="numeric" required="false" default="0">
		<cfset var qPages = "">
		<cfset var thesearchterm = Trim(arguments.searchterm)>
		<cfset var ormoptions = {}>
		<cfif arguments.maxresults>
			<cfset ormoptions.maxresults = arguments.maxresults>
		</cfif>
		<cfquery name="qPages" dbtype="hql" ormoptions="#ormoptions#">
			from Page
			where 1=1
			<cfif Len(thesearchterm)>
				and
				(
				 	title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%">
				 	or content like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%">
				)
			</cfif>
			order by #arguments.sortorder#
		</cfquery>
		<cfreturn qPages>
	</cffunction>

	<cfscript>
		/**
		 * I return the root page (i.e. home page)
		 */
		Page function getRoot() {
			return EntityLoad("Page", {leftvalue=1}, true);
		}

		/**
		 * I save a page
		 */
		Page function savePage(required Page thePage, required numeric ancestorid, required string defaultslug) {
			if(!arguments.thePage.isPersisted() && arguments.ancestorid) {
				var Ancestor = get("Page", arguments.ancestorid);
				var slug = "";
				if(Len(Trim(Ancestor.getSlug())) && Ancestor.getSlug() != arguments.defaultslug) slug = Ancestor.getSlug() & "/";
				slug &= ReReplace(LCase(arguments.thePage.getTitle()), "[^a-z0-9]{1,}", "-", "all");
				while (!isSlugUnique(slug)) slug &= "-";
				arguments.thePage.setSlug(slug);
				arguments.thePage.setAncestorID(Ancestor.getPageID());
				arguments.thePage.setDepth(Ancestor.getDepth() + 1);
				arguments.thePage.setLeftValue(Ancestor.getRightValue());
				arguments.thePage.setRightValue(Ancestor.getRightValue() + 1);
				ORMExecuteQuery("update Page set leftvalue = leftvalue + 2 where leftvalue > :startingvalue", {startingvalue=Ancestor.getRightValue() - 1});
				ORMExecuteQuery("update Page set rightvalue = rightvalue + 2 where rightvalue > :startingvalue", {startingvalue=Ancestor.getRightValue() - 1});
				return save(arguments.thePage);
			}else if(arguments.thePage.isPersisted()) {
				return save(arguments.thePage);
			}
		}
	</cfscript>

	<cffunction name="shiftPages" output="false" returntype="void">
		<cfargument name="affectedpages" required="true" hint="The moved page's id">
		<cfargument name="shift" required="true" hint="The number of positions to shift">

		<cfquery>
			update Pages set
				page_left = page_left + #shift#,
				page_right = page_right + #shift#
			where page_id in (
				<cfqueryparam value="#arguments.affectedpages#" cfsqltype="cf_sql_integer" list="true">
			)
		</cfquery>
	</cffunction>

	<cfscript>
		// ------------------------ PRIVATE METHODS ------------------------ //

		private boolean function isSlugUnique(required string slug) {
			var matches = ORMExecuteQuery("from Page where slug=:slug", {slug=arguments.slug});
			return !ArrayLen(matches);
		}
	</cfscript>
</cfcomponent>

