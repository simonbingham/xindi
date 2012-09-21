<cfoutput>
	<cfif StructKeyExists( rc, "result" ) and rc.result.hasMessage()>
    	<div class="alert alert-#rc.result.getMessageType()#">#rc.result.getMessage()#</div>
	</cfif>
</cfoutput>