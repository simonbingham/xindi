<cfoutput>
	<h1>Oops!</h1>

	<cfif !rc.config.exceptionTracker.emailNewExceptions>
		<p>An error has occurred.</p>

		<h2>Failed Action</h2>

		<p>#request.failedAction#</p>

		<h2>Exception</h2>

		<cfdump var="#request.exception#">
	<cfelse>
		<p>An error has occurred and the site administrator has been notified.</p>
	</cfif>
</cfoutput>
