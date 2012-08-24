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

<cfoutput>
	<div class="page-header clear"><h1>Dashboard</h1></div>

	#view( "helpers/messages" )#

	<p>Please use the options above to maintain your site.</p>

	<cfif ArrayLen( rc.recentenquiries )>
		<hr />
		
		<p class="pull-right"><a href="#buildURL( 'enquiries' )#" class="btn btn-primary">View enquiries <i class="icon-chevron-right icon-white"></i></a></p>
		
		<h2>Enquiries</h2>
		
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th style="width:5%;">&nbsp;</th>
					<th>Name</th>
					<th style="width:25%;">Received</th>
					<th style="width:25%;" class="center">View</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.recentenquiries#" index="local.Enquiry">
					<tr>
						<td class="center"><cfif !local.Enquiry.isRead()><span class="label label-info">new</span></cfif></td>
						<td>#local.Enquiry.getFullName()#</td>
						<td>#DateFormat( local.Enquiry.getCreated(), "full" )# #TimeFormat( local.Enquiry.getCreated() )#</td>
						<td class="center"><a href="#buildURL( action='enquiries.enquiry', querystring='enquiryid=#local.Enquiry.getEnquiryID()#' )#" title="View Enquiry"><i class="icon-eye-open"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</cfif>		
</cfoutput>