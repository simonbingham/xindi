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
	<h1>Search Results</h1>
	
	<cfif StructKeyExists( rc, "pages" ) and rc.pages.recordcount>
		<div class="alert alert-success">#rc.pages.recordcount# <cfif rc.pages.recordcount eq 1>record was<cfelse>records were</cfif> found matching &quot;#rc.searchterm#&quot;.</div>
		
		<cfloop query="rc.pages">
			<cfset local.slug = rc.pages.slug>
			<cfif rc.pages.type eq 'article'><!--- TODO: this is a horrible hack! --->
				<cfset local.slug = 'news/article/slug/' & local.slug>
			</cfif>
			<h2><a href="#buildURL( local.slug )#">#rc.pages.title#</a></h2>
			<p>#snippet( rc.pages.content, 200 )#</p>
		</cfloop>
	<cfelseif StructKeyExists( rc, "pages" )>
		<div class="alert alert-info">No records were found matching &quot;#rc.searchterm#&quot;.</div>
	<cfelse>
		<div class="alert alert-error">Please enter a search team.</div>
	</cfif>
</cfoutput>