<!---
   Copyright 2012, Simon Bingham

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<cfoutput>
	<h1>Pages</h1>
	
	#view( "helpers/messages" )#
	
	<table class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>Title</th>
				<th>Published</th>
				<cfif application.pagesettings.enableadddelete><th>Add Sub Page</th></cfif>
				<th>Move Up</th>
				<th>Move Down</th>
				<cfif application.pagesettings.enableadddelete><th>Delete</th></cfif>
			</tr>
		</thead>
		
		<tbody>
			<cfloop array="#rc.pages#" index="local.Page">
				<tr>
					<td <cfif !local.Page.isRoot()>class="chevron-right" style="padding-left:#( ( Page.getLevel()-1 ) * 26 ) + 26#px; background-position:#( ( local.Page.getLevel() - 1 ) * 26 ) + 5#px 50%"</cfif>>
						<a href="#buildURL( action='pages.maintain', querystring='pageid/#local.Page.getPageID()#' )#" title="Edit #local.Page.getTitle()#">#local.Page.getNavigationTitle()#</a>							
					</td>
					<td>#DateFormat( local.Page.getCreated(), "full" )#</td>
					<cfif application.pagesettings.enableadddelete><td><a href="#buildURL( action='pages.maintain', querystring='ancestorid/#local.Page.getPageID()#' )#" title="Add Page"><i class="icon-plus-sign"></i></a></td></cfif>
					<td><cfif local.Page.hasPreviousSibling()><a href="#buildURL( action='pages.move', querystring='pageid/#local.Page.getPageID()#/direction/up' )#" title="Move Up"><i class="icon-chevron-up"></i></a></cfif></td>
					<td><cfif local.Page.hasNextSibling()><a href="#buildURL( action='pages.move', querystring='pageid/#local.Page.getPageID()#/direction/down' )#" title="Move Down"><i class="icon-chevron-down"></i></a></cfif></td>
					<cfif application.pagesettings.enableadddelete><td><cfif local.Page.isLeaf() and !local.Page.isRoot()><a href="#buildURL( 'pages.delete' )#/pageid/#local.Page.getPageID()#" title="Delete"><i class="icon-remove"></i></a></cfif></td></cfif>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>