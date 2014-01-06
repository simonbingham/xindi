<cfset request.layout = false>

<cfoutput>
	<!DOCTYPE html>

	<html lang="en">
		<head>
			<meta charset="utf-8">

			<title>Reset Password</title>
		</head>

		<body>
			<p>Hello,</p>

			<p>Your new password is &quot;#password#&quot;.</p>

			<p>Kind regards,</p>

			<p>#arguments.name#</p>
		</body>
	</html>
</cfoutput>
