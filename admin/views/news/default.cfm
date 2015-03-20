<cfoutput>
	<div class="page-header clear">
		<h1>News</h1>
	</div>

	<p><a href="#buildURL('news.maintain')#" class="btn btn-primary">Add article <i class="glyphicon glyphicon-chevron-right glyphicon-white"></i></a></p>

	#view("partials/messages")#

	<cfif ArrayLen(rc.articles)>
		<table class="table table-striped">
			<thead>
				<tr>
					<th>Title</th>
					<th>Published</th>
					<th>Last Updated</th>
					<th class="center">View</th>
					<th class="center">Edit</th>
					<th class="center">Delete</th>
				</tr>
			</thead>

			<tbody>
				<cfloop array="#rc.articles#" index="local.Article">
					<tr>
						<td>#local.Article.getTitle()#</td>
						<td>#DateFormat(local.Article.getPublished(), "full")#</td>
						<td>#DateFormat(local.Article.getUpdated(), "full")# #TimeFormat(local.Article.getUpdated())# by #local.Article.getUpdatedBy()#</td>
						<td class="center">
							<cfif local.Article.isPublished()>
								<a href="#buildURL(action = 'public:news.article', queryString = 'slug=#local.Article.getSlug()#')#" title="View" target="_blank"><i class="glyphicon glyphicon-eye-open"></i></a>
							</cfif>
						</td>
						<td class="center"><a href="#buildURL(action = 'news.maintain', queryString = 'articleid/#local.Article.getArticleId()#')#" title="Edit"><i class="glyphicon glyphicon-pencil"></i></a></td>
						<td class="center"><a href="#buildURL('news.delete')#/articleid/#local.Article.getArticleId()#" title="Delete"><i class="glyphicon glyphicon-trash"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no articles at this time.</p>
	</cfif>
</cfoutput>
