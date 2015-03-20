<cfcomponent displayname="Content Gateway" hint="I am the content gateway component" accessors="true" extends="model.abstract.BaseGateway" output="false">
	<cfscript>
		// ------------------------ PUBLIC METHODS ------------------------ //

		/**
		 * I delete a page
		 */
		void function deletePage(required Page thePage) {
			local.startValue = arguments.thePage.getLeftValue();
			if (!IsNull(local.startValue)) {
				ORMExecuteQuery("update Page set leftValue = leftValue - 2 where leftValue > :startValue", {startValue = local.startValue});
				ORMExecuteQuery("update Page set rightValue = rightValue - 2 where rightValue > :startValue", {startValue = local.startValue});
			}
			delete(arguments.thePage);
		}
	</cfscript>

	<cffunction name="findContentBySearchTerm" output="false" returntype="query" hint="I return a query of pages and articles that match the search term">
		<cfargument name="searchTerm" type="string" required="true" hint="The search term">
		<cfargument name="maxResults" type="numeric" required="false" default="50" hint="The maximum number of results to return">

		<cfset local.findFunction = variables.dbEngine eq "MYSQL" ? "locate" : "charindex">

		<cfquery name="local.pages" maxrows="#arguments.maxResults#">
			SELECT
				page_id AS id
				, page_title AS title
				, page_slug AS slug
				, page_updated AS published
				, page_content AS content
				, #local.findFunction#('#arguments.searchTerm#', page_content) - (#local.findFunction#('#arguments.searchTerm#', page_title) * 100) AS weighting
				, 'page' AS type
			FROM pages
			WHERE 1 = 1
			<cfloop list="#arguments.searchTerm#" index="local.keyword" delimiters=" ">
				AND
				(
				 	page_title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.keyword#%">
				 	OR page_content LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.keyword#%">
				)
			</cfloop>
			UNION ALL
			SELECT
				article_id AS id
				, article_title AS title
				, article_slug AS slug
				, article_published AS published
				, article_content AS content
				, #local.findFunction#('#arguments.searchTerm#', article_content) - (#local.findFunction#('#arguments.searchTerm#', article_title) * 100) AS weighting
				, 'article' AS type
			FROM articles
			WHERE 1 = 1
			<cfloop list="#arguments.searchTerm#" index="local.keyword" delimiters=" ">
				AND
				(
				 	article_title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.keyword#%">
				 	OR article_content LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.keyword#%">
				)
			</cfloop>
			ORDER BY weighting
		</cfquery>

		<cfreturn local.pages>
	</cffunction>

	<cffunction name="getChildren" output="false" returntype="query" hint="I return a query of child pages based upon the left and right value arguments">
		<cfargument name="left" required="true" hint="The left position">
		<cfargument name="right" required="true" hint="The right position">
		<cfargument name="clearCache" required="false" default="false" hint="If true clear the cache">

		<cfset local.timespan = arguments.clearCache ? CreateTimeSpan(0, 0, 0, 0) : CreateTimeSpan(0, 0, 0, 30)>

		<cfquery name="local.children" cachedwithin="#local.timespan#">
			SELECT
				page.page_id AS pageid
				, page.page_slug AS slug
				, page.page_title AS title
				, page.page_updated AS updated
				, page.page_left AS positionleft
				, page.page_right AS positionright
				, page.page_updatedby AS updatedby
			FROM pages AS page
			WHERE 1 = 1
			AND (
					SELECT count(*)
					FROM pages AS pageSubQuery
					WHERE pageSubQuery.page_left < page.page_left
					AND pageSubQuery.page_right > page.page_right
				) =
				(
					SELECT count(*)
					FROM pages
					WHERE page_left < <cfqueryparam value="#arguments.left#" cfsqltype="cf_sql_integer">
					AND page_right > <cfqueryparam value="#arguments.right#" cfsqltype="cf_sql_integer">) + 1
			AND page_left > <cfqueryparam value="#arguments.left#" cfsqltype="cf_sql_integer">
			AND page_right < <cfqueryparam value="#arguments.right#" cfsqltype="cf_sql_integer">
			ORDER BY page_left;
		</cfquery>

		<cfreturn local.children>
	</cffunction>

	<cfscript>
		/**
		 * I return a page matching an id
		 */
		Page function getPage(required numeric pageId) {
			return get(entityName = "Page", id = arguments.pageId);
		}

		/**
		 * I return a page matching a slug
		 */
		Page function getPageBySlug(required string slug) {
			local.Page = EntityLoad("Page", {slug = arguments.slug}, TRUE);
			if (IsNull(local.Page)) {
				local.Page = new("Page");
			}
			return local.Page;
		}
	</cfscript>

	<cffunction name="getNavigation" output="false" returntype="query" hint="I return the pages used to build the navigation">
		<cfargument name="left" required="false" hint="The left position">
		<cfargument name="right" required="false" hint="The right position">
		<cfargument name="depth" required="false" hint="The page depth">
		<cfargument name="clearCache" required="false" default="false" hint="If true clear the cache">

		<cfset local.timespan = arguments.clearCache ? CreateTimeSpan(0, 0, 0, 0) : CreateTimeSpan(0, 0, 0, 30)>

		<cfquery name="local.pages" cachedwithin="#local.timespan#">
			SELECT
				page.page_id AS pageid
				, page.page_slug AS slug
				, page.page_title AS title
				, page.page_updated AS updated
				, page.page_left AS positionleft
				, page.page_right AS positionright
				, page.page_updatedby AS updatedby
				, case when page.page_left = 1 then 1 else (
					SELECT count(*)
					FROM pages AS pageSubQuery
					WHERE pageSubQuery.page_left < page.page_left
						AND pageSubQuery.page_right > page.page_right
					) end AS depth
				, ((page.page_right - page.page_left - 1) / 2) AS descendants
			FROM pages AS page
			WHERE 1 = 1
			<cfif StructKeyExists(arguments, "left")>
				AND page_left > <cfqueryparam value="#arguments.left#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(arguments, "right")>
				AND page_right < <cfqueryparam value="#arguments.right#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(arguments, "depth")>
				AND page_depth <= <cfqueryparam value="#arguments.depth#" cfsqltype="cf_sql_integer">
			</cfif>
			ORDER BY page_left
		</cfquery>

		<cfreturn local.pages>
	</cffunction>

	<cffunction name="getNavigationPath" output="false" returntype="query" hint="returns the pages forming the path to the website root">
		<cfargument name="pageId" required="true" hint="The page id for the end of the trail">

		<cfquery name="local.pages">
			SELECT
				ancestor.page_id AS pageid
				, ancestor.page_title AS title
				, ancestor.page_slug AS slug
			FROM pages AS child,
				pages AS ancestor
			WHERE child.page_left >= ancestor.page_left AND child.page_left <= ancestor.page_right
				AND child.page_id = <cfqueryparam value="#arguments.pageId#" cfsqltype="cf_sql_integer">
				AND ancestor.page_id <> <cfqueryparam value="#arguments.pageId#" cfsqltype="cf_sql_integer"><!--- exclude passed page --->
			ORDER BY ancestor.page_left
		</cfquery>

		<cfreturn local.pages>
	</cffunction>

	<cffunction name="getPages" output="false" returntype="Array" hint="I return an array of pages">
		<cfargument name="searchTerm" type="string" required="false" default="" hint="The search term">
		<cfargument name="sortOrder" type="string" required="false" default="leftValue" hint="The column upon which to sort">
		<cfargument name="maxResults" type="numeric" required="false" default="0" hint="The maximum number of results to return">

		<cfset local.theSearchTerm = Trim(arguments.searchTerm)>
		<cfset local.ormOptions = {}>

		<cfif arguments.maxResults>
			<cfset local.ormOptions.maxResults = arguments.maxResults>
		</cfif>

		<cfquery name="local.pages" dbtype="hql" ormoptions="#local.ormOptions#">
			FROM Page
			WHERE 1 = 1
			<cfif Len(Trim(local.theSearchTerm))>
				AND
				(
				 	title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.theSearchTerm#%">
				 	OR content LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.theSearchTerm#%">
				)
			</cfif>
			ORDER BY #arguments.sortOrder#
		</cfquery>

		<cfreturn local.pages>
	</cffunction>

	<cfscript>
		/**
		 * I return the root page (i.e. home page)
		 */
		Page function getRoot() {
			return EntityLoad("Page", {leftValue = 1}, true);
		}

		/**
		 * I save a page
		 */
		Page function savePage(required Page thePage, required numeric ancestorId, required string defaultSlug) {
			if (!arguments.thePage.isPersisted() && arguments.ancestorId) {
				local.Ancestor = get(entityName = "Page", id = arguments.ancestorId);
				local.slug = "";
				if (Len(Trim(local.Ancestor.getSlug())) && local.Ancestor.getSlug() != arguments.defaultSlug) {
					local.slug = local.Ancestor.getSlug() & "/";
				}
				local.slug &= ReReplace(LCase(arguments.thePage.getTitle()), "[^a-z0-9]{1,}", "-", "all");
				while (!isSlugUnique(local.slug)) {
					local.slug &= "-";
				}
				arguments.thePage.setSlug(local.slug);
				arguments.thePage.setAncestorId(local.Ancestor.getPageId());
				arguments.thePage.setDepth(local.Ancestor.getDepth() + 1);
				arguments.thePage.setLeftValue(local.Ancestor.getRightValue());
				arguments.thePage.setRightValue(local.Ancestor.getRightValue() + 1);
				ORMExecuteQuery("update Page set leftValue = leftValue + 2 where leftValue > :startingValue", {startingValue = local.Ancestor.getRightValue() - 1});
				ORMExecuteQuery("update Page set rightValue = rightValue + 2 where rightValue > :startingValue", {startingValue = local.Ancestor.getRightValue() - 1});
				return save(arguments.thePage);
			} else if (arguments.thePage.isPersisted()) {
				return save(arguments.thePage);
			}
		}
	</cfscript>

	<cffunction name="shiftPages" output="false" returntype="void" hint="I update the left and right values of the pages being moved">
		<cfargument name="affectedPages" required="true" hint="The ids of the moved pages">
		<cfargument name="shift" required="true" hint="The number of positions to shift by">

		<cfquery>
			UPDATE Pages SET
				page_left = page_left + #arguments.shift#,
				page_right = page_right + #arguments.shift#
			WHERE page_id IN (
				<cfqueryparam value="#arguments.affectedPages#" cfsqltype="cf_sql_integer" list="true">
			)
		</cfquery>
	</cffunction>

	<cfscript>
		// ------------------------ PRIVATE METHODS ------------------------ //

		/**
		 * I return true if a slug is unique
		 */
		private boolean function isSlugUnique(required string slug) {
			local.matches = ORMExecuteQuery("from Page where slug = :slug", {slug = arguments.slug});
			return !ArrayLen(local.matches);
		}
	</cfscript>
</cfcomponent>

