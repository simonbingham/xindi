<cfoutput>
	<ul class="breadcrumb">
		<li><a href="#rc.baseHref#">Home</a></li>
		<li class="active">News</li>
	</ul>

	<div><h1>News</h1></div>

	<cfif ArrayLen(rc.articles)>
		<cfloop array="#rc.articles#" index="local.Article">
			<div class="well">
				<h2>
					<a href="#buildURL(action='news.article', querystring='slug=#local.Article.getSlug()#')#">#local.Article.getTitle()#</a>

					<small class="pull-right">#DateFormat(local.Article.getPublished(), "full")#</small>
				</h2>

				#snippet(local.Article.getContent(), 500)#
			</div>
		</cfloop>

		<ul class="pager">
			<cfif rc.offset>
				<li class="previous"><a href="#buildURL(action='news', querystring='offset=#rc.offset-rc.maxResults#')#">&larr; Newer</a></li>
			<cfelse>
				<li class="previous disabled"><a href="">&larr; Newer</a></li>
			</cfif>

			<cfif rc.maxresults + rc.offset lt rc.articlecount>
				<li class="next"><a href="#buildURL(action='news', querystring='offset=#rc.offset+rc.maxResults#')#">Older &rarr;</a></li>
			<cfelse>
				<li class="next disabled"><a href="">Older &rarr;</a></li>
			</cfif>
		</ul>
	<cfelse>
		<p>There are currently no news stories.</p>
	</cfif>

	<script>
		jQuery(function($){
			$(".previous.disabled,.next.disabled").click(function(e){
				e.preventDefault();
			});
		});
	</script>
</cfoutput>
