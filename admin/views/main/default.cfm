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
						<td>#local.Enquiry.getName()#</td>
						<td>#DateFormat( local.Enquiry.getCreated(), "full" )# #TimeFormat( local.Enquiry.getCreated() )#</td>
						<td class="center"><a href="#buildURL( action='enquiries.enquiry', querystring='enquiryid=#local.Enquiry.getEnquiryID()#' )#" title="View Enquiry"><i class="icon-eye-open"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</cfif>		
</cfoutput>