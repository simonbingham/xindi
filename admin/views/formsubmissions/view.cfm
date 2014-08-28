<cfoutput>
	<div class="page-header clear">	
		<h2>#rc.Form.getName()#:</h2>
		<h4>Submission Received on #DateFormat(rc.Submission.getSubmission_Date(), "long")# at #TimeFormat(rc.Submission.getSubmission_Date(), "medium")#</h4>
	</div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL( action='formsubmissions.default', querystring='formid/#rc.Form.getFormID()#' )#" class="btn"><i class="icon-arrow-left"></i> Back to Submission List</a>
		<a href="#buildURL( 'formsubmissions.delete' )#/submissionid/#rc.Submission.getSubmissionID()#" title="Delete" class="btn btn-danger"><i class="fa fa-trash-o"></i> Delete</a>
	</div>

	<div class="clear"></div>

	<table class="table table-striped table-bordered">
		<tbody>
			<cfloop index="item" array="#rc.FormData#">
				<tr>
					<td>#item.Name#:</td>
					<td>#item.Data#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>

</cfoutput>
	