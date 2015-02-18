<!---
	To run the test suite browse to the following url:

	http://127.0.0.1:8500/xindi/_tests/runner.cfm
--->

<cfsetting requesttimeout="600">

<cfset testbox = new testbox.system.TestBox(directory = "tests")>

<cfoutput>#testbox.run()#</cfoutput>
