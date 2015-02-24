<!---
	To run the automation test suite browse to the following url:

	http://127.0.0.1:8500/xindi/_tests/automation/runner.cfm
--->

<cfsetting requesttimeout="600">

<cfset testbox = new testbox.system.TestBox(directory = "tests.automation")>

<cfoutput>#testbox.run()#</cfoutput>
