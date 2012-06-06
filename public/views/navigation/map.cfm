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
		<div class="page-header"><h1>Site Map</h1></div>
	
		<!--- check pages exist --->
		<cfif ArrayLen( rc.navigation )>
			<!--- loop through pages --->
			<cfloop array="#rc.navigation#" index="local.Page">
				<!--- create page link --->
				<cfsavecontent variable="local.link">
					<!--- build url --->
					<a href="#buildURL( local.Page.getSlug() )#">#local.Page.getTitle()#</a>
				</cfsavecontent>		
				
				<!--- if the current page level is greater than the previous page level initiate a new tier in the menu --->
				<cfif local.Page.getLevel() gt local.previouslevel>
					<cfif local.Page.getLevel() neq 1><ul></cfif>
					<li>#local.link#
					<cfif local.Page.isRoot()></li></cfif>
				<!--- if the current page level is less than the previous page level we need to go up a tier in the menu --->
				<cfelseif local.Page.getLevel() lt local.previouslevel>
					<cfset local.temporary = local.previouslevel>
					<!--- keep going up a tier whilst the previous page level is greater than the current page level --->				
					<cfloop condition="local.temporary gt local.Page.getLevel()">
		 				</li></ul>
						<cfset local.temporary = local.temporary - 1>
					</cfloop>
					</li><li>#local.link#
				<!--- if the current page level is the same as the previous page level just display a link --->
				<cfelse>
					</li><li>#local.link#
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