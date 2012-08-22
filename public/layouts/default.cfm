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

<cfoutput><!DOCTYPE html>
	<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta name="description" content="#rc.MetaData.getMetaDescription()#">
			<meta name="keywords" content="#rc.MetaData.getMetaKeywords()#">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">

			<base href="#rc.basehref#">

			<title>#rc.MetaData.getMetaTitle()#</title>

			<link href="public/assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">

			<!--[if lt IE 9]>
				<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
			<![endif]-->

			<link rel="shortcut icon" href="favicon.ico">

			<link rel="apple-touch-icon-precomposed" sizes="114x114" href="public/assets/ico/apple-touch-icon-114-precomposed.png">
			<link rel="apple-touch-icon-precomposed" sizes="72x72" href="public/assets/ico/apple-touch-icon-72-precomposed.png">
			<link rel="apple-touch-icon-precomposed" href="public/assets/ico/apple-touch-icon-57-precomposed.png">
			
			<cfif rc.config.news.enabled><link rel="alternate" type="application/rss+xml" href="#buildURL( 'news.rss' )#"></cfif>			
		</head>		
		
		<body>
			<cfif rc.config.development>
				<span class="dev-mode label label-warning">Development Mode</span>
			</cfif>
			
			<div class="navbar navbar-fixed-top">
				<div class="navbar-inner">
					<div class="container">
						<a class="brand" href="#rc.basehref#" title="Return to home page"><img src="public/assets/img/global/xindi-logo.png" alt="Xindi logo" /></a>
						
					    <form action="#buildURL( 'search' )#" method="post" class="navbar-search pull-right" id="search">
					    	<input type="text" name="searchterm" id="searchterm" class="search-query" placeholder="Search">
					    </form>							
					</div>
				</div>
			</div>			
			
			<div id="container" class="container">
				<div class="row">
					<nav class="span12" id="primary-navigation">
						<cfset local.prevLevel = -1>
						<cfset local.currLevel = -1>

						<cfloop query="rc.navigation">
							<cfset local.currLevel = rc.navigation.depth>

							<cfif local.currLevel gt local.prevLevel>
								<ul class="<cfif local.prevLevel eq -1>nav nav-pills<cfelse>dropdown-menu</cfif>"><li><a href="#buildURL( rc.navigation.slug )#">#rc.navigation.title#</a>
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
					</nav>
				</div>
				
				<div id="content" class="row" role="main">
					<div class="span12">#body#</div>
				</div>

				<footer id="footer" class="row">
					<div class="span12"><a href="#buildURL( 'navigation/map' )#">Site Map</a></div>
				</footer>
			</div>
			
			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
			<script src="public/assets/js/core.js?r=#rc.config.revision#"></script>
		</body>
	</html>
</cfoutput>