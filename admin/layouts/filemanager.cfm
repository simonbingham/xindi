<cfset request.layout = false>

<cfsetting enablecfoutputonly="true">

<cfoutput>
	<!DOCTYPE html>

	<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta name="author" content="Simon Bingham (http://www.simonbingham.me.uk/)">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">

			<base href="#rc.basehref##request.subsystem#/">

			<title>Xindi File Manager</title>

			<link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
			<link href="assets/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet">
			<link href="assets/css/smoothness/jquery-ui-1.8.19.custom.css" rel="stylesheet">
			<link href="assets/css/imgareaselect-animated.css?r=#rc.config.revision#" rel="stylesheet">
			<link href="assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">

			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
			<script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
			<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
			<script src="assets/bootstrap/js/bootstrap.min.js"></script>
			<script src="assets/js/jquery.imgareaselect.min.js"></script>
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
			<div id="container" class="container">
				<div class="row">
					<div id="content" class="span12">
						#body#
					</div>
				</div>
			</div>
		</body>
	</html>
</cfoutput>
