<cfoutput>
	<div class="page-header clear"><h1>Forms</h1></div>
	
	<p><a href="#buildURL( 'forms.maintain' )#" class="btn btn-primary"><i class="fa fa-plus-square-o"></i> Add form <i class="icon-chevron-right icon-white"></i></a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.forms )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Name</th>
					<th class="center">Published</th>
					<th class="center">Edit</th>
					<th class="center">Fields</th>
					<th class="center"><abbr title="Sort the fields in this form">Sort</abbr></th>
					<th class="center"><abbr title="View data submissions for this form">Data</abbr></th>
					<th class="center">Delete</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.forms#" index="local.Form">
					<tr>
						<td><cfif local.Form.getIsPublished()><a href="#buildURL( action='public:forms.form', querystring='slug=#local.Form.getSlug()#' )#" title="View" target="_blank"></cfif>#local.Form.getName()#<cfif local.Form.getIsPublished()></a></cfif></td>
						<td class="center">#YesNoFormat( local.Form.getIsPublished() )#</td>
						<td class="center"><a href="#buildURL( action='forms.maintain', querystring='formid/#local.Form.getFormID()#' )#" title="Edit"><i class="fa fa-edit fa-lg"></i></a></td>
						<td class="center"><a href="#buildURL( action='formfields.default', querystring='formid/#local.Form.getFormID()#' )#" title="View Form Fields for this Form"><i class="fa fa-list fa-lg"></i></a></td>
						<td class="center"><cfif arrayLen(local.Form.getFields())><a href="#buildURL( action='formfields.sort', querystring='formid/#local.Form.getFormID()#' )#" title="Sort Form Fields"></cfif><i class="fa fa-retweet fa-lg"></i><cfif arrayLen(local.Form.getFields())></a></cfif></td>
						<td class="center"><a href="#buildURL( action='formsubmissions.default', querystring='formid/#local.Form.getFormID()#' )#" title="View Data Submissions"><i class="fa fa-database fa-lg"></i></a></td>
						<td class="center"><a href="#buildURL( 'forms.delete' )#/formid/#local.Form.getFormID()#" title="Delete"><i class="fa fa-trash-o fa-lg"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no forms at this time.</p>
	</cfif>
</cfoutput>