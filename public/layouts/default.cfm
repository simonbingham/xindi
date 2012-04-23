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
			
			<link href="assets/css/core.css?r=#rc.revision#" rel="stylesheet">
			
			<!--[if lt IE 9]>
				<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
			<![endif]-->
			
			<script src="assets/js/core.js?r=#rc.revision#"></script>			
		</head>

		<body>
			<div id="navigation">#view( "main/navigation", { pages=rc.navigation } )#</div> 
			
			<div id="content">#body#</div>
			
			<div id="footer">
				<ul>
					<li><a href="#buildURL( 'main/sitemap' )#">Site Map</a></li>
				</ul>
			</div>
		</body>
	</html>
</cfoutput>