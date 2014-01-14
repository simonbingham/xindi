<cfoutput>
	<div class="page-header clear">		
		<h1>Manage Form Fields</h1>
		<h2>#rc.Section.getForm().getName()#:</h2>
		<h3>#rc.Section.getName()#</h3>
	</div>
	
	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL('forms')#" class="btn"><i class="icon-arrow-left"></i> Back to Forms</a>
	</div>
	
	<p><a href="#buildURL( action='formfields.maintain', querystring='sectionid/#rc.Section.getSectionID()#' )#" class="btn btn-primary">Add new field <i class="icon-chevron-right icon-white"></i></a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.fields )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Short Name</th>
					<th class="center">Field Type</th>
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
						<td class="center"><a href="#buildURL( action='formfields.maintain', querystring='fieldid/#local.Field.getFieldID()#' )#" title="Edit"><i class="icon-pencil"></i></a></td>
						<td class="center"><a href="#buildURL( action='formfields.delete', querystring='fieldid/#local.Field.getFieldID()#' )#" title="Delete"><i class="icon-trash"></i></a></td>
						<td class="center"><a href="#buildURL( action='formfields.clone', querystring='fieldid/#local.Field.getFieldID()#' )#" title="Clone"><i class="icon-copy"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no form fields for this section yet.</p>
	</cfif>
</cfoutput>