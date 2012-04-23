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

<cfset request.layout = false />

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
			<link href="assets/css/core.css?r=#rc.revision#" rel="stylesheet">

			<!--[if lt IE 9]>
				<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
			<![endif]-->
			
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
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
								<!---<cfif rc.loggedin>--->
									<li><a href="#buildURL( 'pages' )#">Pages</a></li>
									<li><a href="#buildURL( 'users' )#">Users</a></li>
									<li><a href="#buildURL( '' )#">Logout</a></li>
								<!---</cfif>--->
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