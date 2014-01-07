<cfset request.layout = false>

<cfoutput>
	<!DOCTYPE html>

	<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">

			<base href="#rc.basehref##request.subsystem#/">

			<title>Xindi Site Manager</title>

			<link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
			<link href="assets/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet">
			<link href="assets/css/smoothness/jquery-ui-1.8.19.custom.css" rel="stylesheet">
			<link href="assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">

			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
			<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
			<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js" type="text/javascript"></script>
			<script src="assets/js/jquery.field.min.js"></script>
			<script src="assets/bootstrap/js/bootstrap.min.js"></script>
			<script src="assets/ckeditor/ckeditor.js"></script>
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
				<span class="dev-mode label label-warning">Development Mode</span>
			</cfif>

			<div class="navbar navbar-fixed-top" role="banner">
				<div class="navbar-inner">
					<div class="container">
						<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</a>

						<a class="brand" href="#rc.basehref##request.subsystem#/" title="Return to home page"><img src="assets/img/xindi-logo.png" alt="Xindi logo" /></a>

						<div class="nav-collapse">
							<ul class="nav pull-right" role="navigation">
								<cfif StructKeyExists(rc, "CurrentUser")>
									<li><a href="#rc.basehref##request.subsystem#/">Dashboard</a></li>
									<li><a href="#buildURL('pages')#">Pages</a></li>
									<cfif rc.config.news.enabled><li><a href="#buildURL('news')#">News</a></li></cfif>
									<cfif rc.config.enquiry.enabled><li><a href="#buildURL('enquiries')#">Enquiries<cfif rc.unreadenquirycount> <span class="badge badge-info">#NumberFormat(rc.unreadenquirycount)#</span></cfif></a></li></cfif>
									<li><a href="#buildURL('users')#">Users</a></li>
									<li><a href="#buildURL('security/logout')#">Logout</a></li>
								</cfif>
							</ul>
						</div>
					</div>
				</div>
			</div>

			<div id="container" class="container">
				<div class="row">
					<div id="content" class="span12" role="main">
						<h2 class="pull-right"><cfif StructKeyExists(rc, "CurrentUser")><small class="pull-right">#rc.CurrentUser.getName()#</small></cfif></h2>

						#body#

						<div class="clearfix append-bottom"></div>
					</div>
				</div>
			</div>

			<div id="footer" role="contentinfo">
				<div class="container">
					<div class="row">
						<div class="span12">
							<p>
								<a href="http://www.getxindi.com/">Version #rc.config.version#</a>
								<a href="##" id="top-of-page" class="pull-right">Back to top <i class="icon-chevron-up"></i></a>
							</p>
						</div>
					</div>
				</div>
			</div>
		</body>
	</html>
</cfoutput>
