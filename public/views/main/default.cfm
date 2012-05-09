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

<!--- specify canonical url for page (http://support.google.com/webmasters/bin/answer.py?hl=en&answer=139394) --->
<cfsavecontent variable="local.canonicalurl">
	<cfoutput>
		<link rel="canonical" href="#buildURL( rc.Page.getSlug() )#">
	</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#local.canonicalurl#">

<cfoutput>
	#view( "navigation/breadcrumbs", { Page=rc.Page } )#
	
	<h1>#rc.Page.getTitle()#</h1>
	
	#rc.Page.getContent()#
</cfoutput>