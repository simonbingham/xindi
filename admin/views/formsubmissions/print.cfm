<cfdocument format="PDF">
<cfoutput>
	<div class="page-header clear">	
		<h2>#rc.Form.getName()#:</h2>
		<h4>Submission Received on #DateFormat(rc.Submission.getSubmission_Date(), "long")# at #TimeFormat(rc.Submission.getSubmission_Date(), "medium")#</h4>
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

	
</cfdocument>