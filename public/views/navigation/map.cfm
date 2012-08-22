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
	<h1>Site Map</h1>
	
	<cfset local.prevLevel = -1>
	<cfset local.currLevel = -1>
	
	<cfloop query="rc.navigation">
		<cfset local.currLevel = rc.navigation.depth>

		<cfif local.currLevel gt local.prevLevel>
			<ul class="depth-#rc.navigation.depth#"><li><a href="#buildURL( rc.navigation.slug )#">#rc.navigation.title#</a>
		<cfelseif local.currLevel lt local.prevLevel>
			<cfset local.tmp = local.prevLevel>

			<cfloop condition="local.tmp gt local.currLevel">
				</li></ul>
				<cfset local.tmp -= 1>
			</cfloop>

			</li><li><a href="#buildURL( rc.navigation.slug )#">#rc.navigation.title#</a>
		<cfelse>
			</li><li><a href="#buildURL( rc.navigation.slug )#">#rc.navigation.title#</a>
		</cfif>

		<cfset local.prevLevel = rc.navigation.depth>
	</cfloop>

	<cfset local.tmp = local.currLevel>

	<cfloop condition="local.tmp gt 0">
		</li></ul>
		<cfset local.tmp -= 1>
	</cfloop>
</cfoutput>