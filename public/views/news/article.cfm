<cfoutput>
	#rc.Article.getContent()#
	
	<hr>
	
	<p>
		Published: #DateFormat( rc.Article.getPublished(), "full" )#
		<cfif rc.Article.hasAuthor()><br>Author: #rc.Article.getAuthor()#</cfif>
	</p>
</cfoutput>