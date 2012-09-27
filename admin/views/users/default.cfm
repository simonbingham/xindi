<cfoutput>
	<div class="page-header clear"><h1>Users</h1></div>
	
	<p><a href="#buildURL( 'users.maintain' )#" class="btn btn-primary">Add user <i class="icon-chevron-right icon-white"></i></a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.users )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Name</th>
					<th>Email</th>
					<th>Last Updated</th>
					<th class="center">Delete</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.users#" index="local.User">
					<tr>
						<td><a href="#buildURL( action='users.maintain', querystring='userid/#local.User.getUserID()#' )#" title="Edit #local.User.getName()#">#local.User.getName()#</a></td>
						<td><a href="mailto:#local.User.getEmail()#">#local.User.getEmail()#</a></td>
						<td>#DateFormat( local.User.getUpdated(), "full" )# #TimeFormat( local.User.getUpdated() )#</td>
						<td class="center"><cfif local.User.getUserID() neq rc.CurrentUser.getUserID()><a href="#buildURL( 'users.delete' )#/userid/#local.User.getUserID()#" title="Delete"><i class="icon-remove"></i></a></cfif></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no user accounts.</p>
	</cfif>
</cfoutput>