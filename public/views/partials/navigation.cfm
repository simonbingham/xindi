<cfoutput>
	<cfset local.prevLevel = -1>
	<cfset local.currLevel = -1>

	<cfloop query="rc.navigation">
		<cfset local.currLevel = rc.navigation.depth>

		<cfif local.currLevel gt local.prevLevel>
			<ul><li><a href="#buildURL(rc.navigation.slug)#">#rc.navigation.title#</a>
		<cfelseif local.currLevel lt local.prevLevel>
			<cfset local.tmp = local.prevLevel>

			<cfloop condition="local.tmp gt local.currLevel">
				</li></ul>

				<cfset local.tmp -= 1>
			</cfloop>
			</li><li><a href="#buildURL(rc.navigation.slug)#">#rc.navigation.title#</a>
		<cfelse>
			</li><li><a href="#buildURL(rc.navigation.slug)#">#rc.navigation.title#</a>
		</cfif>

		<cfset local.prevLevel = rc.navigation.depth>
	</cfloop>

	<cfset local.tmp = local.currLevel>

	<cfloop condition="local.tmp gt 0">
		</li></ul>

		<cfset local.tmp -= 1>
	</cfloop>
</cfoutput>
