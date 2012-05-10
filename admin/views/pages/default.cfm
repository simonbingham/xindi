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

<cfset local.routes = variables.framework.routes />

<cfoutput>
	<div class="page-header"><h1>Pages</h1></div>
	
	#view( "helpers/messages" )#
	
	<table class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>Title</th>
				<th>Published</th>
				<th class="center">View</th>
				<cfif rc.config.pagesettings.enableadddelete><th class="center">Add Page</th></cfif>
				<th class="center">Move Up</th>
				<th class="center">Move Down</th>
				<cfif rc.config.pagesettings.enableadddelete><th class="center">Delete</th></cfif>
			</tr>
		</thead>
		
		<tbody>
			<cfloop array="#rc.pages#" index="local.Page">
				<tr>
					<td <cfif !local.Page.isRoot()>class="chevron-right" style="padding-left:#( ( Page.getLevel()-1 ) * 26 ) + 26#px; background-position:#( ( local.Page.getLevel() - 1 ) * 26 ) + 5#px 50%"</cfif>>
						<cfif !local.Page.hasRoute( local.routes )>
							<a href="#buildURL( action='pages.maintain', querystring='pageid/#local.Page.getPageID()#' )#" title="Edit #local.Page.getTitle()#">#local.Page.getNavigationTitle()#</a>
						<cfelse>
							#local.Page.getNavigationTitle()# *
						</cfif>							
					</td>
					<td>#DateFormat( local.Page.getCreated(), "full" )#</td>
					<td class="center"><a href="#buildURL( action="public:" & local.Page.getSlug() )#" title="View" target="_blank"><i class="icon-eye-open"></i></a></td>
					<cfif rc.config.pagesettings.enableadddelete><td class="center"><a href="#buildURL( action='pages.maintain', querystring='ancestorid/#local.Page.getPageID()#' )#" title="Add Page"><i class="icon-plus-sign"></i></a></td></cfif>
					<td class="center"><cfif local.Page.hasPreviousSibling()><a href="#buildURL( action='pages.move', querystring='pageid/#local.Page.getPageID()#/direction/up' )#" title="Move Up"><i class="icon-chevron-up"></i></a></cfif></td>
					<td class="center"><cfif local.Page.hasNextSibling()><a href="#buildURL( action='pages.move', querystring='pageid/#local.Page.getPageID()#/direction/down' )#" title="Move Down"><i class="icon-chevron-down"></i></a></cfif></td>
					<cfif rc.config.pagesettings.enableadddelete><td class="center"><cfif local.Page.isLeaf() and !local.Page.isRoot() and !local.Page.hasRoute( local.routes )><a href="#buildURL( 'pages.delete' )#/pageid/#local.Page.getPageID()#" title="Delete"><i class="icon-remove"></i></a></cfif></td></cfif>
				</tr>
			</cfloop>
		</tbody>
	</table>
	
	<cfif ArrayLen( local.routes )><p>* you cannot edit or delete this page because it routes to another website feature.</p></cfif>
</cfoutput>