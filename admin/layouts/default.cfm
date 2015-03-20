<cfset request.layout = false>

<cfoutput>
	<!DOCTYPE html>

	<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">

			<base href="#rc.baseHref##request.subSystem#/">

			<title>Xindi Site Manager</title>

			<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" rel="stylesheet">
			<link href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css" rel="stylesheet">
			<link href="assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">

			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
			<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>
			<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
			<script src="assets/js/jquery.field.min.js"></script>
			<script src="assets/ckeditor/ckeditor.js"></script>
			<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
			<script src="assets/js/core.js?r=#rc.config.revision#"></script>

			<link rel="shortcut icon" href="assets/ico/favicon.ico">
			<link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144x144-precomposed.png">
			<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114x114-precomposed.png">
			<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72x72-precomposed.png">
			<link rel="apple-touch-icon-precomposed" sizes="57x57" href="assets/ico/apple-touch-icon-57x57-precomposed.png">
			<link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-precomposed.png">
			<link rel="apple-touch-icon" href="assets/ico/apple-touch-icon.png">
		</head>

		<body>
			<cfif rc.config.development>
				<span class="development-mode label label-warning">Development Mode</span>
			</cfif>

			<nav class="navbar navbar-default" role="navigation">
				<div class="container">
					<div class="navbar-header">
						<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##navbar" aria-expanded="false" aria-controls="navbar">
							<span class="sr-only">Toggle navigation</span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>

						<a class="navbar-brand" href="#rc.baseHref##request.subSystem#/" title="Return to home page"><img src="assets/img/xindi-logo.png" alt="Xindi logo" /></a>
					</div>

					<div id="navbar" class="navbar-collapse collapse">
						<ul class="nav navbar-nav">
							<cfif StructKeyExists(rc, "CurrentUser")>
								<li><a href="#rc.baseHref##request.subSystem#/">Dashboard</a></li>
								<li><a href="#buildURL('pages')#">Pages</a></li>
								<cfif rc.config.news.enabled>
									<li><a href="#buildURL('news')#">News</a></li>
								</cfif>
								<cfif rc.config.enquiry.enabled>
									<li><a href="#buildURL('enquiries')#">Enquiries<cfif rc.unreadEnquiryCount> <span class="badge badge-info">#NumberFormat(rc.unreadEnquiryCount)#</span></cfif></a></li>
								</cfif>
								<li><a href="#buildURL('users')#">Users</a></li>
								<li><a href="#buildURL('security/logout')#">Logout</a></li>
							</cfif>
						</ul>
					</div>
				</div>
			</nav>

			<div id="container" class="container" role="main">
				<h2 class="pull-right">
					<cfif StructKeyExists(rc, "CurrentUser")>
						<small class="pull-right">#rc.CurrentUser.getName()#</small>
					</cfif>
				</h2>

				#body#

				<div class="clearfix append-bottom"></div>
			</div>

			<div id="footer" role="contentinfo">
				<div class="container">
					<p>
						<a href="http://www.getxindi.com/">Version #rc.config.version#</a>
						<a href="##" id="top-of-page" class="pull-right">Back to top <i class="icon-chevron-up"></i></a>
					</p>
				</div>
			</div>
		</body>
	</html>
</cfoutput>
