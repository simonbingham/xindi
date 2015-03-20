<cfcomponent displayname="News Gateway" hint="I am the news gateway component" accessors="true" extends="model.abstract.BaseGateway" output="false">
	<cfscript>
		// ------------------------ PUBLIC METHODS ------------------------ //

		/**
		 * I delete an article
		 */
		void function deleteArticle(required Article theArticle) {
			delete(arguments.theArticle);
		}

		/**
		 * I return an article matching an id
		 */
		Article function getArticle(required numeric articleId) {
			return get(entityName = "Article", id = arguments.articleId);
		}

		/**
		 * I return an article matching a unique id
		 */
		Article function getArticleBySlug(required string slug) {
			local.Article = ORMExecuteQuery("from Article where slug = :slug and published <= :published", {slug = arguments.slug, published = Now()}, true);
			if (IsNull(local.Article)) {
				local.Article = new("Article");
			}
			return local.Article;
		}

		/**
		 * I return the count of articles
		 */
		numeric function getArticleCount() {
			return ORMExecuteQuery("select count(*) from Article", [], true);
		}
	</cfscript>

	<cffunction name="getArticles" output="false" returntype="Array" hint="I return an array of articles">
		<cfargument name="searchTerm" type="string" required="false" default="" hint="The search term">
		<cfargument name="sortOrder" type="string" required="false" default="published desc" hint="The column upon which to sort">
		<cfargument name="published" type="boolean" required="false" default="false" hint="True if only published articles should be returned">
		<cfargument name="maxResults" type="numeric" required="false" default="0" hint="The maximum number of results to return">
		<cfargument name="offset" type="numeric" required="false" default="0" hint="The offset">

		<cfset local.theSearchTerm = Trim(arguments.searchTerm)>
		<cfset local.ormOptions = {}>

		<cfif arguments.maxResults>
			<cfset local.ormOptions.maxresults = arguments.maxResults>
		</cfif>

		<cfif arguments.offset>
			<cfset local.ormOptions.offset = arguments.offset>
		</cfif>

		<cfquery name="local.articles" dbtype="hql" ormoptions="#local.ormOptions#">
			FROM Article
			WHERE 1 = 1
			<cfif arguments.published>
				AND published < <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			</cfif>
			<cfif Len(local.thesearchterm)>
				AND
				(
				 	title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.thesearchterm#%">
				 	OR content LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#local.thesearchterm#%">
				)
			</cfif>
			ORDER BY #arguments.sortOrder#
		</cfquery>

		<cfreturn local.articles>
	</cffunction>

	<cfscript>
		/**
		 * I save an article
		 */
		Article function saveArticle(required Article theArticle) {
			return save(arguments.theArticle);
		}
	</cfscript>
</cfcomponent>
