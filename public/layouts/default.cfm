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

<cfset request.layout = false>

<cfoutput>
	<!DOCTYPE html>
	
	<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta name="description" content="#rc.MetaData.getMetaDescription()#">
			<meta name="keywords" content="#rc.MetaData.getMetaKeywords()#">
			
			<title>#rc.MetaData.getMetaTitle()#</title>
			
			<base href="#rc.basehref#">
			
			<cfif rc.config.newssettings.enabled><link rel="alternate" type="application/rss+xml" href="#buildURL( 'news.rss' )#"></cfif>
			
			<link href="assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">
			
			<script src="assets/js/core.js?r=#rc.config.revision#"></script>			
		</head>

		<body>
			<div id="search">
				<form action="#buildURL( 'search' )#" method="post">
					<input type="text" name="searchterm" id="searchterm" placeholder="Enter keywords" />
					<input type="submit" name="searchbutton" id="searchbutton" value="Search" />
				</form>
			</div>
			
			#view( "navigation/menu" )# 
			
			<div id="content">#body#</div>
			
			<div id="footer">
				<ul>
					<li><a href="#buildURL( 'navigation/map' )#">Site Map</a></li>
				</ul>
			</div>
		</body>
	</html>
</cfoutput>