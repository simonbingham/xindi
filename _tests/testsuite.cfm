<!--- open this file in a web browser to run the tests --->
<cfif IsLocalHost(CGI.REMOTE_ADDR)>
	<cfset testsuite = new mxunit.framework.TestSuite() />
	
	<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#model" name="tests" recurse="true" filter="*.cfc">
	
	<cfloop query="tests">
		<cfset filepath = Replace(Right(directory, Len(directory) - FindNoCase("tests", directory) - 5), "\", ".", "all") />
		
		<!--- fix Railo file path issue --->
		<cfif server.coldfusion.productname eq "railo">
			<cfset filepath = "xindi.tests." & filepath>
		</cfif>
		
		<cfset testSuite.addAll(filepath & "." & Replace(name, ".cfc", "")) />
	</cfloop>
	
	<cfset results = testsuite.run() />
	
	<cfoutput>#ReplaceNoCase(results.getResultsOutput("html"), "/model", "model", "ALL")#</cfoutput>
<cfelse>
	<p>Tests can only be run in the development environment.</p>
</cfif>