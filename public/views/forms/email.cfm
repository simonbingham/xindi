<cfset request.layout = false>

<cfoutput>
	<!DOCTYPE html>

	<html lang="en">
		<head>
			<meta charset="utf-8">

			<title>New Form Submission</title>
		</head>

		<body>

			<p>#subject#:</p>

			<table>
				<tbody>
					<cfloop array="#formData#" index="key">
					<tr><td>#key.name# :</td><td>#key.data#</td></tr>
					</cfloop>
				</tbody>
			</table>
			<!---<cfdump var="#formData#">--->

		</body>
	</html>
</cfoutput>
