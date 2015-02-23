<cfoutput>
	<cfif !rc.Page.isRoot()>
		<ul class="breadcrumb">
			<cfloop query="rc.breadcrumbs"><li><a href="#buildURL(rc.breadcrumbs.slug)#">#rc.breadcrumbs.title#</a></li></cfloop>
			<li class="active">#rc.Page.getTitle()#</li>
		</ul>
	</cfif>

	#rc.Page.getContent()#
</cfoutput>
