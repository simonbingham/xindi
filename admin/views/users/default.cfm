<cfoutput>
	<div class="page-header clear">
		<h1>Users</h1>
	</div>

	<p><a href="#buildURL('users.maintain')#" class="btn btn-primary">Add user <i class="glyphicon glyphicon-chevron-right glyphicon-white"></i></a></p>

	#view("partials/messages")#

	<cfif ArrayLen(rc.users)>
		<table class="table table-striped">
			<thead>
				<tr>
					<th>Name</th>
					<th>Email</th>
					<th>Last Updated</th>
					<th class="center">Edit</th>
					<th class="center">Delete</th>
				</tr>
			</thead>

			<tbody>
				<cfloop array="#rc.users#" index="local.User">
					<tr>
						<td>#local.User.getName()#</td>
						<td><a href="mailto:#local.User.getEmail()#">#local.User.getEmail()#</a></td>
						<td>#DateFormat(local.User.getUpdated(), "full")# #TimeFormat(local.User.getUpdated())#</td>
						<td class="center"><a href="#buildURL(action = 'users.maintain', queryString = 'userid/#local.User.getUserId()#')#" title="Edit"><i class="glyphicon glyphicon-pencil"></i></a></td>
						<td class="center">
							<cfif local.User.getUserId() neq rc.CurrentUser.getUserId()>
								<a href="#buildURL('users.delete')#/userid/#local.User.getUserId()#" title="Delete"><i class="glyphicon glyphicon-trash"></i></a>
							</cfif>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no user accounts at this time.</p>
	</cfif>
</cfoutput>
