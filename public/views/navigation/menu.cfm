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

<cfset local.previouslevel = -1>

<cfoutput>
	<cfprocessingdirective suppresswhitespace="true">	
		<!--- check pages exist --->
		<cfif ArrayLen( rc.navigation )>
			<!--- loop through pages --->
			<cfloop array="#rc.navigation#" index="local.Page">
				<!--- create page link --->
				<cfsavecontent variable="local.link">
					<!--- 
						if the current page is not the root, has a child page and ancestor page links 
						are used to toggle dropdowns we need to initiate a Bootstrap dropdown 
					--->
					<cfif local.Page.hasChild() and rc.config.pagesettings.ancestorlinkstoggledropdown and !local.Page.isRoot()>
						<a href="#buildURL( local.Page.getSlug() )#" class="dropdown-toggle" data-toggle="dropdown">#local.Page.getTitle()# <b class="caret"></b></a>
					<cfelse>
						<a href="#buildURL( local.Page.getSlug() )#">#local.Page.getTitle()#</a>	
					</cfif>
				</cfsavecontent>		
				
				<!--- if the current page level is greater than the previous page level initiate a new tier in the menu --->
				<cfif local.Page.getLevel() gt local.previouslevel>
					<cfif local.Page.isRoot()>
						<ul class="nav nav-pills">
					<cfelseif local.Page.getLevel() gt 1>
						<ul class="dropdown-menu">
						<!--- 
							if ancestor page links are used to toggle dropdowns we need to display a duplicated 
							ancestor page link in the sub menu so the page remains accessible 
						--->
						<cfif rc.config.pagesettings.ancestorlinkstoggledropdown>
							<cfset local.Ancestor = local.Page.getAncestor()[ 1 ] />
							<li><a href="#buildURL( local.Ancestor.getSlug() )#">#local.Ancestor.getTitle()#</a></li> 
						</cfif>
					</cfif>
					<!--- if the current page is the page being viewed apply 'active' class --->
					<li <cfif IsDefined( "rc.Page" ) and rc.Page.getPageID() eq local.Page.getPageID()>class="active"</cfif>>#local.link#
					<cfif local.Page.isRoot()></li></cfif>
				<!--- if the current page level is less than the previous page level we need to go up a tier in the menu --->
				<cfelseif local.Page.getLevel() lt local.previouslevel>
					<cfset local.temporary = local.previouslevel>
					<!--- keep going up a tier whilst the previous page level is greater than the current page level --->		
					<cfloop condition="local.temporary gt local.Page.getLevel()">
		 				</li></ul>
						<cfset local.temporary = local.temporary - 1>
					</cfloop>
					<!--- if the current page is the page being viewed apply 'active' class --->
					</li><li <cfif IsDefined( "rc.Page" ) and rc.Page.getPageID() eq local.Page.getPageID()>class="active"</cfif>>#local.link#
				<!--- if the current page level is the same as the previous page level just display a link --->
				<cfelse>
					<!--- if the current page is the page being viewed apply 'active' class --->
					</li><li <cfif IsDefined( "rc.Page" ) and rc.Page.getPageID() eq local.Page.getPageID()>class="active"</cfif>>#local.link#
				</cfif>
				<cfset local.previouslevel = local.Page.getLevel()>
			</cfloop>
			
			<!--- finally we need to ensure our nested menu is closed correctly --->
			<!--- keep going up a tier whilst the previous page level is greater than or equal to zero --->
			<cfset local.temporary = local.Page.getLevel()>
			<cfloop condition="local.temporary ge 1">
				</li></ul>
				<cfset local.temporary = local.temporary - 1>
			</cfloop>
		</cfif>
	</cfprocessingdirective>
</cfoutput>