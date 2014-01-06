<cfset request.layout = false>

<cfoutput>
	<!DOCTYPE html>

	<html lang="en">
		<head>
			<meta charset="utf-8">

			<title>Website Enquiry</title>
		</head>

		<body>
			<p>Hello,</p>

			<p>Please find attached an enquiry from your website.</p>

			<table>
				<tbody>
					<tr>
						<th style="text-align:left; vertical-align:top;">Name</th>
						<td style="text-align:left; vertical-align:top;">#Enquiry.getName()#</td>
					</tr>
					<tr>
						<th style="text-align:left; vertical-align:top;">Email Address</th>
						<td style="text-align:left; vertical-align:top;"><a href="mailto:#Enquiry.getEmail()#">#Enquiry.getEmail()#</a></td>
					</tr>
					<tr>
						<th style="text-align:left; vertical-align:top;">Message</th>
						<td style="text-align:left; vertical-align:top;">#Enquiry.getDisplayMessage()#</td>
					</tr>
				</tbody>
			</table>

			<p>Kind regards,</p>

			<p>Your Website</p>
		</body>
	</html>
</cfoutput>
