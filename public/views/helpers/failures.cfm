<cfoutput>
	<cfif StructKeyExists( rc.result.getFailureMessagesByProperty(), local.property )>
		<span class="error">
			<cfloop array="#rc.result.getFailureMessagesByProperty()[ local.property ]#" index="local.message">
				#local.message#
			</cfloop> 
		</span>
	</cfif>
</cfoutput>