<cfoutput>
	<ul class="breadcrumb">
		<li><a href="#rc.basehref#">#rc.Page.getTitle()#</a> <span class="divider">/</span></li>
		<li class="active">Search Results</li>
	</ul>

	<h1>Search Results</h1>

	<cfif StructKeyExists(rc, "pages") and rc.pages.recordcount>
		<div class="alert alert-success">#rc.pages.recordcount# <cfif rc.pages.recordcount eq 1>record was<cfelse>records were</cfif> found matching &quot;#rc.searchterm#&quot;.</div>

		<cfloop query="rc.pages">
			<cfset local.slug = rc.pages.slug>

			<!--- TODO: this is a horrible hack! --->
			<cfif rc.pages.type eq 'article'>
				<cfset local.slug = 'news/article/slug/' & local.slug>
			</cfif>

			<h2><a href="#buildURL(local.slug)#">#rc.pages.title#</a></h2>

			#snippet(rc.pages.content, 200)#
		</cfloop>
	<cfelseif StructKeyExists(rc, "pages")>
		<div class="alert alert-info">No records were found matching &quot;#rc.searchterm#&quot;.</div>
	<cfelse>
		<div class="alert alert-error">Please enter a search team.</div>
	</cfif>
</cfoutput>
