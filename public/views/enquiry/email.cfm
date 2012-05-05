<!---
	Xindi (http://simonbingham.github.com/xindi/)
	
	Copyright (c) 2012, Simon Bingham (http://www.simonbingham.me.uk/)
	
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
			
			<title>Website Enquiry</title>
		</head>

		<body>
			<p>Hello,</p>
			
			<p>Please find attached an enquiry from your website.</p>
		
			<table>
				<tbody>
					<tr>
						<th style="text-align:left; vertical-align:top;">Name</th>
						<td style="text-align:left; vertical-align:top;">#Enquiry.getFullName()#</td>
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