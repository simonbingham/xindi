<cfoutput>
	<div class="page-header clear"><h1>Forms</h1></div>
	
	<p><a href="#buildURL( 'forms.maintain' )#" class="btn btn-primary">Add form <i class="icon-chevron-right icon-white"></i></a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.forms )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Name</th>
					<th>Published</th>
					<!---<th>Last Updated</th>--->
					<th class="center">View</th>
					<th class="center"><abbr title="Add a new section to this form">New</abbr></th>
					<th class="center"><abbr title="Sort the sections and fields in this form">Sort</abbr></th>
					<th class="center">Edit</th>
					<th class="center">Delete</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.forms#" index="local.Form">
					<tr>
						<td>#local.Form.getName()#</td>
						<td>#YesNoFormat( local.Form.getIsPublished() )#</td>
						<!---<td>#DateFormat( local.Form.getUpdated(), "full" )# #TimeFormat( local.Form.getUpdated() )# by #local.Form.getUpdatedBy()#</td>--->
						<td class="center"><cfif local.Form.getIsPublished()><a href="#buildURL( action='public:forms.form', querystring='slug=#local.Form.getSlug()#' )#" title="View" target="_blank"><i class="icon-eye-open"></i></a></cfif></td>
						<td class="center"><a href="#buildURL( action='formsections.maintain', querystring='formid/#local.Form.getFormID()#' )#" title="Add Section"><i class="icon-plus-sign"></i></a></td>
						<td class="center"><cfif arrayLen(local.Form.getSections())><a href="#buildURL( action='formsections.sort', querystring='formid/#local.Form.getFormID()#' )#" title="Sort Form Sections"><i class="icon-retweet"></i></a></cfif></td>
						<td class="center"><a href="#buildURL( action='forms.maintain', querystring='formid/#local.Form.getFormID()#' )#" title="Edit"><i class="icon-pencil"></i></a></td>
						<td class="center"><a href="#buildURL( 'forms.delete' )#/formid/#local.Form.getFormID()#" title="Delete"><i class="icon-trash"></i></a></td>
					</tr>
					<cfif arrayLen(local.Form.getSections())>
						<cfloop array="#local.Form.getSections()#" index="local.Section">
							<tr>
								<td class="chevron-right" style="padding-left:30px; background-position:10px 50%"><a href="#buildURL( action='formfields.default', querystring='sectionid/#local.Section.getSectionID()#' )#" title="View Form Fields for this Section">#local.Section.getName()#</a></td>
								<td></td>
								<!---<td>#DateFormat( local.Form.getUpdated(), "full" )# #TimeFormat( local.Form.getUpdated() )# by #local.Form.getUpdatedBy()#</td>--->
								<td class="center"></td>
								<td class="center"></td>
								<td class="center"><cfif arrayLen(local.Form.getSections())><a href="#buildURL( action='formfields.sort', querystring='sectionid/#local.Section.getSectionID()#' )#" title="Sort Form Fields for this Section"><i class="icon-retweet"></i></a></cfif></td>
								<td class="center"><a href="#buildURL( action='formsections.maintain', querystring='sectionid/#local.Section.getSectionID()#' )#" title="Edit"><i class="icon-pencil"></i></a></td>
								<td class="center"><a href="#buildURL( 'formsections.delete' )#/sectionid/#local.Section.getSectionID()#" title="Delete"><i class="icon-trash"></i></a></td>
							</tr>
						</cfloop>
					</cfif>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no forms at this time.</p>
	</cfif>
</cfoutput>