<cfoutput>
	<div class="page-header clear">		
		<h1>Form Submissions</h1>
		<h2>#rc.Form.getName()#</h2>
	</div>
	
	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('forms')#" class="btn"><i class="icon-arrow-left"></i> Back to Forms</a>
	</div>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.submissions )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<cfloop index="local.Field" array="#rc.FirstFields#">
						<th>#local.Field.getName()#</th>
					</cfloop>
					<th>Received</th>
					<th class="center">View</th>
					<th class="center">Delete</th>
					<th class="center">Print</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.submissions#" index="local.Submission">
					<cfset local.formData = deserializeJSON(local.Submission.getData())> 
					<tr>
						<cfloop index="local.data" array="#local.formData#">
							<cfif arrayLen(rc.FirstFields) GTE 1 AND local.data.ID IS rc.FirstFields[1].getFieldID()>
								<td>#local.data.DATA#</td>
							</cfif>
							<cfif arrayLen(rc.FirstFields) GTE 2 AND local.data.ID IS rc.FirstFields[2].getFieldID()>
								<td>#local.data.DATA#</td>
							</cfif>
						</cfloop>
						<td>#DateFormat(local.submission.getSubmission_Date(), "medium")# #TimeFormat(local.submission.getSubmission_Date(), "medium")#</td>
						<td class="center"><a href="#buildURL( action='formsubmissions.view', querystring='submissionid/#local.Submission.getSubmissionID()#' )#" title="View"><i class="fa fa-eye fa-lg"></i></a></td>
						<td class="center"><a href="#buildURL( action='formsubmissions.delete', querystring='submissionid/#local.Submission.getSubmissionID()#' )#" title="Delete"><i class="fa fa-trash-o fa-lg"></i></a></td>
						<td class="center"><a href="#buildURL( action='formsubmissions.print', querystring='submissionid/#local.Submission.getSubmissionID()#' )#" target="_new" title="Print"><i class="fa fa-print fa-lg"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no submissions for this form yet.</p>
	</cfif>
</cfoutput>