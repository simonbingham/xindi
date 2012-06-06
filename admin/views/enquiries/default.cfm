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
	<div class="page-header clear"><h1>Enquiries</h1></div>
	
	<cfif rc.unreadenquirycount>
		<p><a href="#buildURL( 'enquiries.markallread' )#" class="btn btn-primary">Mark all as read <i class="icon-chevron-right icon-white"></i></a></p>
	</cfif>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.enquiries )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>&nbsp;</th>
					<th>Name</th>
					<th>Received</th>
					<th class="center">View</th>
					<th class="center">Delete</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.enquiries#" index="local.Enquiry">
					<tr>
						<td class="center"><cfif local.Enquiry.isUnread()><span class="label label-info">new</span></cfif></td>
						<td>#local.Enquiry.getFullName()#</td>
						<td>#DateFormat( local.Enquiry.getCreated(), "full" )# at #TimeFormat( local.Enquiry.getCreated(), "full" )#</td>
						<td class="center"><a href="#buildURL( action='enquiries.enquiry', querystring='enquiryid=#local.Enquiry.getEnquiryID()#' )#" title="View Enquiry"><i class="icon-eye-open"></i></a></td>
						<td class="center"><a href="#buildURL( 'enquiries.delete' )#/enquiryid/#local.Enquiry.getEnquiryID()#" title="Delete"><i class="icon-remove"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are currently no enquiries.</p>
	</cfif>
</cfoutput>