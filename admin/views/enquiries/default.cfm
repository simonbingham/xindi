<cfoutput>
	<div class="page-header clear"><h1>Enquiries</h1></div>

	<cfif rc.unreadenquirycount>
		<p><a href="#buildURL('enquiries.markread')#" class="btn btn-primary">Mark All Read</a></p>
	</cfif>

	#view("helpers/messages")#

	<cfif ArrayLen(rc.enquiries)>
		<table class="table table-striped table-bordered table-condensed">
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
						<td class="center"><a href="#buildURL(action='enquiries.enquiry', querystring='enquiryid=#local.Enquiry.getEnquiryID()#')#" title="View"><i class="icon-eye-open"></i></a></td>
						<td class="center"><a href="#buildURL('enquiries.delete')#/enquiryid/#local.Enquiry.getEnquiryID()#" title="Delete"><i class="icon-trash"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>

		<p><span class="label label-info">Note</span> Unread enquiries are highlighted in bold.</p>
	<cfelse>
		<p>There are no enquiries at this time.</p>
	</cfif>
</cfoutput>
