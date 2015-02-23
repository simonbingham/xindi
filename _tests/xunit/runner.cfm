<!---
	To run the xunit test suite browse to the following url:

	http://127.0.0.1:8500/xindi/_tests/xunit/runner.cfm
--->

<cfsetting requesttimeout="600">

<cfset testbox = new testbox.system.TestBox(directory = "tests.xunit")>

<cfoutput>#testbox.run()#</cfoutput>
