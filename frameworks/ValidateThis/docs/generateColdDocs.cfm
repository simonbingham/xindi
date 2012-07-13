<cfscript>
	colddoc = createObject("component", "colddoc.ColdDoc").init();

	strategy = createObject("component", "colddoc.strategy.api.HTMLAPIStrategy").init(expandPath("../../validatethis/samples/docs/api"), "ValidateThis API Documentation");
	colddoc.setStrategy(strategy);

	colddoc.generate(expandPath("/ValidateThis"), "ValidateThis");
</cfscript>

<h1>Done!</h1>

<a href="docs">Documentation</a>
