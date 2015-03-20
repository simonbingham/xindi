<cfoutput>
	<div class="page-header clear">
		<h1>Enquiries</h1>
	</div>

	<cfif rc.unreadenquirycount>
		<p><a href="#buildURL('enquiries.markread')#" class="btn btn-primary">Mark All Read</a></p>
	</cfif>

	#view("partials/messages")#

	<cfif ArrayLen(rc.enquiries)>
		<table class="table table-striped">
			<thead>
				<tr>
					<th>Name</th>
					<th>Received</th>
					<th class="center">View</th>
					<th class="center">Delete</th>
				</tr>
			</thead>

			<tbody>
				<cfloop array="#rc.enquiries#" index="local.Enquiry">
					<tr <cfif !local.Enquiry.isRead()>style="font-weight:bold;"</cfif>>
						<td>#local.Enquiry.getName()#</td>
						<td>#DateFormat(local.Enquiry.getCreated(), "full")# at #TimeFormat(local.Enquiry.getCreated())#</td>
						<td class="center"><a href="#buildURL(action = 'enquiries.enquiry', queryString = 'enquiryId=#local.Enquiry.getEnquiryId()#')#" title="View"><i class="glyphicon glyphicon-eye-open"></i></a></td>
						<td class="center"><a href="#buildURL('enquiries.delete')#/enquiryid/#local.Enquiry.getEnquiryId()#" title="Delete"><i class="glyphicon glyphicon-trash"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>

		<p><span class="label label-info">Note</span> Unread enquiries are highlighted in bold.</p>
	<cfelse>
		<p>There are no enquiries at this time.</p>
	</cfif>
</cfoutput>
