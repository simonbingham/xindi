<cfoutput>
	<div class="page-header clear"><h1>News</h1></div>
	
	<p><a href="#buildURL( 'news.maintain' )#" class="btn btn-primary">Add article <i class="icon-chevron-right icon-white"></i></a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.articles )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Title</th>
					<th>Published</th>
					<th>Last Updated</th>
					<th class="center">View</th>
					<th class="center">Delete</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.articles#" index="local.Article">
					<tr>
						<td><a href="#buildURL( action='news.maintain', querystring='articleid/#local.Article.getArticleID()#' )#" title="Edit #local.Article.getTitle()#">#local.Article.getTitle()#</a></td>
						<td>#DateFormat( local.Article.getPublished(), "full" )#</td>
						<td>#DateFormat( local.Article.getUpdated(), "full" )# #TimeFormat( local.Article.getUpdated() )# by #local.Article.getUpdatedBy()#</td>
						<td class="center"><cfif local.Article.isPublished()><a href="#buildURL( action='public:news.article', querystring='slug=#local.Article.getSlug()#' )#" title="Preview Page" target="_blank"><i class="icon-eye-open"></i></a></cfif></td>
						<td class="center"><a href="#buildURL( 'news.delete' )#/articleid/#local.Article.getArticleID()#" title="Delete"><i class="icon-remove"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are currently no news stories.</p>
	</cfif>
</cfoutput>