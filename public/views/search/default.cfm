<cfoutput>
	<ul class="breadcrumb">
		<li><a href="#rc.baseHref#">#rc.Page.getTitle()#</a></li>
		<li class="active">Search Results</li>
	</ul>

	<h1>Search Results</h1>

	<cfif StructKeyExists(rc, "pages") and rc.pages.recordCount>
		<div class="alert alert-success">#rc.pages.recordCount# <cfif rc.pages.recordCount eq 1>record was<cfelse>records were</cfif> found matching &quot;#rc.searchTerm#&quot;.</div>

		<cfloop query="rc.pages">
			<cfset local.slug = rc.pages.slug>

			<cfif rc.pages.type eq "article">
				<cfset local.slug = "news/article/slug/" & local.slug>
			</cfif>

			<h2><a href="#buildURL(local.slug)#">#rc.pages.title#</a></h2>

			#snippet(rc.pages.content, 200)#
		</cfloop>
	<cfelseif StructKeyExists(rc, "pages")>
		<div class="alert alert-info">No records were found matching &quot;#rc.searchTerm#&quot;.</div>
	<cfelse>
		<div class="alert alert-error">Please enter a search team.</div>
	</cfif>
</cfoutput>
