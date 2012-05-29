<<<<<<< HEAD
﻿<!---
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
=======
﻿<!---
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
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			
			<base href="#rc.basehref#">

			<title>#rc.MetaData.getMetaTitle()#</title>

			<link href="assets/css/superfish.css" rel="stylesheet">
			<link href="assets/css/superfish-vertical.css" rel="stylesheet">
			<link href="assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">

			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
			<script src="assets/bootstrap/js/bootstrap.min.js"></script>
			<script src="assets/js/jquery.hoverIntent.js"></script>
			<script src="assets/js/jquery.superfish.js"></script>			
			<script src="assets/js/core.js?r=#rc.config.revision#"></script>
			
			<link rel="shortcut icon" href="favicon.ico">
			<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
			<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
			<link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">
			
			<cfif rc.config.newssettings.enabled><link rel="alternate" type="application/rss+xml" href="#buildURL( 'news.rss' )#"></cfif>			
		</head>		
		
		<body>
			<div class="navbar navbar-fixed-top">
				<div class="navbar-inner">
					<div class="container">
						<a class="brand" href="#rc.basehref#" title="Return to home page"><img src="assets/img/global/xindi-logo.png" alt="Xindi logo" /></a>
						
					    <form action="#buildURL( 'search' )#" method="post" class="navbar-search pull-right">
					    	<input type="text" name="searchterm" id="searchterm" class="search-query" placeholder="Search">
					    </form>							
					</div>
				</div>
			</div>			
			
			<div id="container" class="container">
				<div class="row">
					<div class="span3">#view( "navigation/menu" )#</div> 
				
					<div class="span9">#body#</div>
				</div>
			</div>
			
			<div id="footer">
				<div class="container">			
					<div class="row">
						<div class="span12">
							<a href="#buildURL( 'navigation/map' )#">Site Map</a>
						</div>
					</div>
				</div>
			</div>	
		</body>
	</html>
>>>>>>> origin/develop
</cfoutput>