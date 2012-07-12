<!---
	
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="validatethis.unitTests.SRV.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="beforeTests" access="public" returntype="void">
		<cfscript>
			setupValidUserFixture();
			setupInvalidUserFixture();
			setupValidCompanyFixture();
			setupInvalidCompanyFixture();
			setupNoruleCompanyFixture();
		</cfscript>
	</cffunction>

	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("IsValidObject");
			needsFacade = true;
			
			// Define Validation Mock Test Values
			parameters={};
			context="*";
			objectValue = {};
			isRequired = true;
			theObjectType="";
			hasObjectType=false;
			hasValue=false;
			
		</cfscript>
	</cffunction>
	
	<cffunction name="configureValidationMock" access="private">
		<cfscript>
			super.configureValidationMock();
			validation.getParameterValue("context","*").returns(context);
			validation.getParameterValue("context").returns(context);
			validation.getParameterValue("objectType").returns(theObjectType);
			validation.hasParameter("objectType").returns(hasObjectType);			
			validation.getParameterValue("objectType","#theObjectType#").returns(theObjectType);
			validation.getObjectList().returns([]);
			validation.failWithResult("{*}").returns();
		</cfscript>
	</cffunction>
	
	<cffunction name="setupValidCompanyFixture" access="private">
		<cfscript>
			validCompany = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.Company");
			validCompany.setCompanyName("Adam Drew");
		</cfscript>
	</cffunction>

	<cffunction name="setupInvalidCompanyFixture" access="private">
		<cfscript>
			invalidCompany = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.Company");
			invalidCompany.setCompanyName("A");
		</cfscript>
	</cffunction>

	<cffunction name="setupNoruleCompanyFixture" access="private">
		<cfscript>
			noruleCompany = createObject("component","validatethis.unitTests.Fixture.models.cf9.norules.Company");
			noruleCompany.setCompanyName("A");
		</cfscript>
	</cffunction>
	
	<cffunction name="setupValidUserFixture" access="private">
		<cfscript>
			validUser = createObject("component","validatethis.unitTests.Fixture.models.cf9.json.User").init();
			validUser.setUserName("epner81@gmail.com");
		</cfscript>
	</cffunction>
	
	<cffunction name="setupInvalidUserFixture" access="private">
		<cfscript>
			invalidUser = createObject("component","validatethis.unitTests.Fixture.models.cf9.json.User").init();
			invalidUser.setUserName("a");
		</cfscript>
	</cffunction>
	
	<cffunction name="validateTestIsReliableWithNoFalsePositives" access="public" returntype="void">
		<cfscript>
			objectValue = {}; // I know an empty struct should fail here. but does it?	
			isRequired=true;

			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForNonJSONSimpleValue" access="public" returntype="void">
		<cfscript>
			objectValue = "This is not JSON!";
			failureMessage = "The validation failed because a valid object cannot be a simple value.";	
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyStruct" access="public" returntype="void">
		<cfscript>
			objectValue = {};
			failureMessage = "The validation failed because a valid structure cannot be empty.";	
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyArray" access="public" returntype="void">
		<cfscript>
			objectValue = [];	
			failureMessage = "The validation failed because a valid array cannot be empty.";	
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidArray" access="public" returntype="void">
		<cfscript>			
			objectValue = [validCompany,invalidCompany];	

			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidArrayOfOneObjectType" access="public" returntype="void">
		<cfscript>			
			validCompany2 = duplicate(validCompany);
			//validCompany2.setCompanyName("Majik Solutions");
			objectValue = [validCompany,validCompany2];	

			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidArrayMixedObjectTypes" access="public" returntype="void">
		<cfscript>			
			validCompany2 = duplicate(validCompany);
			validUser2 = duplicate(validUser);
			
			objectValue = [validCompany,validUser,validCompany2,validUser2];	

			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).failWithResult("{*}"); 
			
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidArrayOfOneObjectType" access="public" returntype="void">
		<cfscript>			
			invalidCompany2  = duplicate(invalidCompany);
			objectValue = [invalidCompany,invalidCompany2];	

			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(arrayLen(objectValue)).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidArrayMixedObjectTypes" access="public" returntype="void">
		<cfscript>			
			invalidCompany2 = duplicate(invalidCompany);
			invalidUser2 = duplicate(invalidUser);
			
			objectValue = [invalidCompany,invalidUser,invalidCompany2,invalidUser2];	

			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(arrayLen(objectValue)).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForValidObjectWithNoValidationParameters" access="public" returntype="void">
		<cfscript>
			objectValue = validCompany;
			
			parameters={};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForObjectWithNoRules" access="public" returntype="void">
		<cfscript>
			objectValue = noruleCompany;
			
			parameters={};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForValidObjectWithVTML" access="public" returntype="void">
		<cfscript>
			objectValue = validCompany;
			
			parameters={};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsFalseForInvalidObjectWithVTML" access="public" returntype="void">
		<cfscript>
			objectValue = invalidCompany;
			
			parameters={};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsTrueForValidObjectWithJSON" access="public" returntype="void">
		<cfscript>
			objectValue = validUser;
			
			parameters={};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validationReturnsFalseForInvalidObjectWithJSON" access="public" returntype="void">
		<cfscript>
			objectValue = invalidUser;
			
			parameters={};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).failWithResult("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="expectedResultObjectShouldBeReturnedByValidationWith4LevelsContainingThreeUniqueObjects" access="public" returntype="void">
		<cfscript>
			setupRecursion();
			companyA.setCompanyName("a");
			userA.setUserName("a");
			companyB.setCompanyName("a");
			userB.setUserName("a");
			
			validation = validateThis.getBean("TransientFactory").newValidation(companyA);
			validation.setObjectList([companyA]);
			valStruct = {parameters={},propertyName="user",PropertyDesc="user"};

			validation.load(valStruct);

			executeValidate(validation);
			failures = validation.getResult().getFailures();
			assertEquals(3,arrayLen(failures));
			expectedStruct = failures[1];
			assertEquals("userName",expectedStruct.clientFieldName);
			assertEquals("Hey, buddy, you call that an Email Address?",expectedStruct.message);
			assertEquals("User_With_Company",expectedStruct.objectType);
			assertEquals("userName",expectedStruct.propertyName);
			assertEquals(userA,expectedStruct.theObject);
			assertEquals("email",expectedStruct.type);
			expectedStruct = failures[2];
			assertEquals("companyName",expectedStruct.clientFieldName);
			assertEquals("The Company Name must be between 2 and 10 characters long.",expectedStruct.message);
			assertEquals("Company_With_User",expectedStruct.objectType);
			assertEquals("companyName",expectedStruct.propertyName);
			assertEquals(companyB,expectedStruct.theObject);
			assertEquals("rangelength",expectedStruct.type);
			expectedStruct = failures[3];
			assertEquals("userName",expectedStruct.clientFieldName);
			assertEquals("Hey, buddy, you call that an Email Address?",expectedStruct.message);
			assertEquals("User_With_Company",expectedStruct.objectType);
			assertEquals("userName",expectedStruct.propertyName);
			assertEquals(userB,expectedStruct.theObject);
			assertEquals("email",expectedStruct.type);
		</cfscript>  
	</cffunction>

	<cffunction name="setupRecursion" access="private" returntype="void">
		<cfscript>
			companyA = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.Company_With_User");
			userA = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.User_With_Company");
			companyB = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.Company_With_User");
			userB = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.User_With_Company");
			
			companyA.setUser(userA);
			userA.setCompany(companyB);
			companyB.setUser(userB);
			userB.setCompany(companyA);
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldIncludeMessagesFromAllFailuresForAllObjects" access="public" returntype="void">
		<cfscript>
			container = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.Container");
			objA = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.sample");
			objB = createObject("component","validatethis.unitTests.Fixture.models.cf9.vtml.sample");
			
			objA.setId("objA");
			objA.setProp1("");
			objA.setProp2("");
			objB.setId("objB");
			objB.setProp1("");
			objB.setProp2("");
			container.setObjects([objA,objB]);
			
			validation = validateThis.getBean("TransientFactory").newValidation(container);
			valStruct = {parameters={},propertyName="objects",PropertyDesc="objects"};

			validation.load(valStruct);

			executeValidate(validation);
			failures = validation.getResult().getFailures();
			
			assertEquals(6,arrayLen(failures));
		</cfscript>  
	</cffunction>

</cfcomponent>

