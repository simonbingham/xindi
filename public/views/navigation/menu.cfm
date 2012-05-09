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

<!--- here's lots of code that renders an indented list of pages - could probably be improved! --->

<cfset local.previouslevel = -1>

<cfoutput>
	<cfif ArrayLen( rc.navigation )>
		<cfloop array="#rc.navigation#" index="local.Page">
			<cfsavecontent variable="local.link">
				<a href="#buildURL( local.Page.getSlug() )#">#local.Page.getNavigationTitle()#</a>
			</cfsavecontent>		
			
			<cfif local.Page.getLevel() gt local.previouslevel>
				<ul><li>
					
				#local.link#
			<cfelseif local.Page.getLevel() lt local.previouslevel>
				<cfset local.temporary = local.previouslevel>
				
				<cfloop condition="local.temporary gt local.Page.getLevel()">
	 				</li></ul>
		
					<cfset local.temporary = local.temporary - 1>
				</cfloop>
			
				</li><li>
	
				#local.link#
			<cfelse>
				</li><li>
					
				#local.link#
			</cfif>
			
			<cfset local.previouslevel = local.Page.getLevel()>
		</cfloop>
	
		<cfset local.temporary = local.Page.getLevel()>
	
		<cfloop condition="local.temporary ge 0">
			</li></ul>
			
			<cfset local.temporary = local.temporary - 1>
		</cfloop>
	</cfif>
</cfoutput>