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

<cfcomponent accessors="true" output="false">
	<!---
		Dependency injection
	--->	
	
	<cfproperty name="MetaData" getter="false">
	<cfproperty name="Validator" getter="false">	
		
	<cfscript>
		/*
		 * Public methods
		 */	
		
		function deleteArticle( required articleid ){
			var Article = getArticleByID( Val( arguments.articleid ) );
			var result = variables.Validator.newResult();
			if( Article.isPersisted() ){ 
				EntityDelete( Article );
				result.setSuccessMessage( "The article &quot;#Article.getTitle()#&quot; has been deleted." );
			}else{
				result.setErrorMessage( "The article could not be deleted." );
			}
			return result;
		}
		
		function getArticleByID( required articleid ){
			var Article = EntityLoadByPK( "Article", Val( arguments.articleid ) );
			if( IsNull( Article ) ) Article = newArticle();
			return Article;
		}
		
		function getArticleByUUID( required string uuid ){
			var Article = ORMExecuteQuery( "from Article where uuid=:uuid and published<=:published", { uuid=arguments.uuid, published=Now() }, true );
			if( IsNull( Article ) ) Article = newArticle();
			return Article;
		}
		
		numeric function getArticleCount(){
			return Val( ORMExecuteQuery( "select count( * ) from Article", true ) );
		}
	</cfscript>
	
	<cffunction name="getArticles" output="false" returntype="Array">
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
				 	lower( title ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%"> 
				 	or lower( content ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%">
				) 
			</cfif>
			order by #arguments.sortorder#
		</cfquery>
		<cfreturn qArticles>
	</cffunction> 
	
	<cfscript>
		function getValidator( required any Article ){
			return variables.Validator.getValidator( theObject=arguments.Article );
		}
		
		function saveArticle( required struct properties ){
			param name="arguments.properties.articleid" default="0";
			var Article = ""; 
			Article = getArticleByID( Val( arguments.properties.articleid ) );
			try{
				arguments.properties.published = CreateDate( ListGetAt( arguments.properties.published, 3, "/" ), ListGetAt( arguments.properties.published, 2, "/" ), ListGetAt( arguments.properties.published, 1, "/" ) );
			}
			catch(any e){
				arguments.properties.published = "";
			}
			Article.populate( arguments.properties );
			if( IsNull( Article.getContent() ) ) Article.setContent( "" );
			if( Article.isMetaGenerated() ){
				Article.setMetaTitle( Article.getTitle() );
				Article.setMetaDescription( variables.MetaData.generateMetaDescription( Article.getContent() ) );
				Article.setMetaKeywords( variables.MetaData.generateMetaKeywords( Article.getContent() ) );
			}
			var result = variables.Validator.validate( theObject=Article );
			if( !result.hasErrors() ){
				EntitySave( Article );
				result.setSuccessMessage( "The article &quot;#Article.getTitle()#&quot; has been saved." );
			}else{
				result.setErrorMessage( "Your article could not be saved. Please amend the highlighted fields." );
			}
			return result;
		}
		
		/*
		 * Private methods
		 */	
		
		private function newArticle(){
			return EntityNew( "Article" );
		}				
	</cfscript>
</cfcomponent>