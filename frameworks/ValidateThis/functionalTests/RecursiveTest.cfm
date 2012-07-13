<cfscript>
	VTConfig = {definitionPath="/validatethis/unitTests/Fixture/models/cf9"};
	ValidateThis = createObject("component","ValidateThis.ValidateThis").init(VTConfig);
	companyA = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.Company_With_User");
	userA = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.User_With_Company");
	companyB = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.Company_With_User");
	userB = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.User_With_Company");
	
	companyA.setUser(userA);
	userA.setCompany(companyB);
	companyB.setUser(userA);
	//userB.setCompany(companyA);

	companyA.setCompanyName("a");
	userA.setUserName("a");
	companyB.setCompanyName("a");
	userB.setUserName("a");
	
	result = ValidateThis.validate(companyA);
	writeDump(result.getFailures());
</cfscript>  

