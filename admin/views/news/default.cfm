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

<cfoutput>
	<div class="page-header"><h1>News</h1></div>
	
	<p><a href="#buildURL( 'news.maintain' )#"><i class="icon-plus"></i> Add Article</a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.articles )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Title</th>
					<th>Published</th>
					<th>Delete</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.articles#" index="local.Article">
					<tr>
						<td><a href="#buildURL( action='news.maintain', querystring='articleid/#local.Article.getArticleID()#' )#" title="Edit #local.Article.getTitle()#">#local.Article.getTitle()#</a></td>
						<td>#DateFormat( local.Article.getPublished(), "full" )#</td>
						<td><a href="#buildURL( 'news.delete' )#/articleid/#local.Article.getArticleID()#" title="Delete"><i class="icon-remove"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are currently no news stories.</p>
	</cfif>
</cfoutput>