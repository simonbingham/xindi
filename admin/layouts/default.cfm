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
			<meta name="author" content="Simon Bingham (http://www.simonbingham.me.uk/)">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			
			<base href="#rc.basehref##request.subsystem#/">

			<title>Xindi</title>

			<link href="assets/css/bootstrap.min.css" rel="stylesheet">
			<link href="assets/css/bootstrap-responsive.min.css" rel="stylesheet">
			<link href="assets/css/smoothness/jquery-ui-1.8.19.custom.css" rel="stylesheet">
			<link href="assets/css/core.css?r=#rc.revision#" rel="stylesheet">

			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
			<script src="assets/js/jquery-ui-1.8.19.custom.min.js"></script>
			<script src="assets/js/jquery.validate.pack.js"></script>	
			<script src="assets/js/jquery.field.min.js"></script>
			<script src="assets/js/bootstrap.min.js"></script>
			<script src="assets/ckeditor/ckeditor.js"></script>
			<script src="assets/js/core.js?r=#rc.revision#"></script>
			
			<link rel="shortcut icon" href="assets/ico/favicon.ico">
			<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
			<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
			<link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">
		</head>
		
		<body>
			<div class="navbar navbar-fixed-top">
				<div class="navbar-inner">
					<div class="container">
						<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</a>
						
						<a class="brand" href="#rc.basehref##request.subsystem#/" title="Return to home page">Xindi</a>
						
						<div class="nav-collapse">
							<ul class="nav pull-right">
								<cfif rc.loggedin>
									<li><a href="#buildURL( 'pages' )#">Pages</a></li>
									<cfif application.config.newssettings.enabled><li><a href="#buildURL( 'news' )#">News</a></li></cfif>
									<li><a href="#buildURL( 'users' )#">Users</a></li>
									<li><a href="#buildURL( 'security/logout' )#">Logout</a></li>
								</cfif>
							</ul>
						</div>
					</div>
				</div>
			</div>		
		
			<div id="container" class="container">
				<div class="row">
					<div id="content" class="span12">
						#body#
						
						<div class="clearfix append-bottom"></div>
					</div>
				</div>
			</div>
	
			<div id="footer">
				<div class="container">
					<div class="row">
						<div class="span12">
							<p class="pull-right"><a href="##" id="top-of-page">Back to top <i class="icon-chevron-up"></i></a></p>
						</div>
					</div>
				</div>
			</div>		
		</body>		
	</html>
</cfoutput>