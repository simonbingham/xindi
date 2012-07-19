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
		 * I delete an article
		 */				
		void function deleteArticle( required Article theArticle ){
			delete( arguments.theArticle );
		}

		/**
		 * I return an article matching an id
		 */				
		Article function getArticle( required numeric articleid ){
			return get( "Article", arguments.articleid );
		}
		
		/**
		 * I return an article matching a unique id
		 */				
		Article function getArticleByLabel( required string label ){
			var Article = ORMExecuteQuery( "from Article where label=:label and published<=:published", { label=arguments.label, published=Now() }, true );
			if( IsNull( Article ) ) Article = new( "Article" );
			return Article;
		}
		
		/**
		 * I return the count of articles
		 */				
		numeric function getArticleCount(){
			return ORMExecuteQuery( "select count( * ) from Article", true );
		}
	</cfscript>
	
	<cffunction name="getArticles" output="false" returntype="Array" hint="I return an array of articles">
		<cfargument name="searchterm" type="string" required="false" default="">
		<cfargument name="sortorder" type="string" required="false" default="published desc">
		<cfargument name="published" type="boolean" required="false" default="false">
		<cfargument name="maxresults" type="numeric" required="false" default="0">
		<cfargument name="offset" type="numeric" required="false" default="0">
		<cfset var qArticles = "">
		<cfset var thesearchterm = Trim( arguments.searchterm )>
		<cfset var ormoptions = {}>
		<cfif arguments.maxresults>
			<cfset ormoptions.maxresults = arguments.maxresults>
		</cfif>
		<cfif arguments.offset>
			<cfset ormoptions.offset = arguments.offset>
		</cfif>
		<cfquery name="qArticles" dbtype="hql" ormoptions="#ormoptions#">
			from Article
			where 1=1
			<cfif arguments.published>
				and published < <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			</cfif>
			<cfif Len( thesearchterm )>
				and 
				(	
				 	title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%"> 
				 	or content like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%">
				) 
			</cfif>
			order by #arguments.sortorder#
		</cfquery>
		<cfreturn qArticles>
	</cffunction> 
	
	<cfscript>
		/**
		 * I save an article
		 */				
		Article function saveArticle( required Article theArticle ){
			return save( arguments.theArticle );
		}
	</cfscript>
</cfcomponent>