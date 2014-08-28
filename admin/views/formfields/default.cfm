<cfoutput>
	<div class="page-header clear">		
		<h1>Manage Form Fields</h1>
		<h2>#rc.Form.getName()#:</h2>
	</div>
	
	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('forms')#" class="btn"><i class="icon-arrow-left"></i> Back to Forms</a>
		<cfif arrayLen(rc.Form.getFields())><a href="#buildURL( action='formfields.sort', querystring='formid/#rc.Form.getFormID()#' )#" title="Sort Form Fields" class="btn btn-danger"><i class="fa fa-refresh"></i> Sort Fields</a></cfif>
	</div>
	
	<p><a href="#buildURL( action='formfields.maintain', querystring='formid/#rc.Form.getFormID()#' )#" class="btn btn-primary"><i class="fa fa-plus-square-o"></i> Add new field <i class="icon-chevron-right icon-white"></i></a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.fields )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Short Name</th>
					<th>Field Type</th>
					<th class="center">Required</th>
					<th class="center">Edit</th>
					<th class="center">Delete</th>
					<th class="center">Clone</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.fields#" index="local.Field">
					<tr>
						<td>#local.Field.getName()#</td>
						<td>#local.Field.getFieldType().getName()#</td>
						<td class="center">#YesNoFormat( local.Field.getRequired() )#</td>
						<td class="center"><a href="#buildURL( action='formfields.maintain', querystring='fieldid/#local.Field.getFieldID()#' )#" title="Edit"><i class="fa fa-edit fa-lg"></i></a></td>
						<td class="center"><a href="#buildURL( action='formfields.delete', querystring='fieldid/#local.Field.getFieldID()#' )#" title="Delete"><i class="fa fa-trash-o fa-lg"></i></a></td>
						<td class="center"><a href="#buildURL( action='formfields.clone', querystring='fieldid/#local.Field.getFieldID()#' )#" title="Clone"><i class="fa fa-copy fa-lg"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no form fields for this form yet.</p>
	</cfif>
</cfoutput>