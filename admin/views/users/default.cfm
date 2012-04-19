<!---
   Copyright 2012, Simon Bingham

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<cfoutput>
	<h1>Users</h1>
	
	<p><a href="#buildURL( 'users.maintain' )#"><i class="icon-plus"></i> Add User</a></p>
	
	#view( "helpers/messages" )#
	
	<cfif ArrayLen( rc.users )>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>Name</th>
					<th>Email</th>
					<th>Created</th>
					<th>Delete</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop array="#rc.users#" index="local.User">
					<tr>
						<td><a href="#buildURL( action='users.maintain', querystring='userid/#local.User.getUserID()#' )#" title="Edit #local.User.getFullName()#">#local.User.getFullName()#</a></td>
						<td>#local.User.getEmail()#</td>
						<td>#DateFormat( local.User.getCreated(), "full" )#</td>
						<td><a href="#buildURL( 'users.delete' )#/userid/#local.User.getUserID()#" title="Delete"><i class="icon-remove"></i></a></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p>There are no user accounts.</p>
	</cfif>
</cfoutput>