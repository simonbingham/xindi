<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="validatethis.unitTests.BaseTestCase" output="false">
	
	<cfset ServerValidator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="createServerValidator" access="private" returntype="any">
		<cfargument name="addToConfig" type="struct" required="false" default="#structNew()#" />
		<cfscript>
			ValidateThisConfig = getVTConfig();
			structAppend(ValidateThisConfig,arguments.addToConfig,true);
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig);
			validationFactory = ValidateThis.getBean("ValidationFactory");
			serverValidator = validationFactory.getBean("ServerValidator");
		</cfscript>
	</cffunction>

	<cffunction name="setUpUser" access="private" returntype="any">
		<cfargument name="emptyUser" type="boolean" required="false" default="false" />
		<cfscript>
			user = createObject("component","validatethis.unitTests.Fixture.User").init();
			if (not arguments.emptyUser) {
				user.setUserName("bob.silverberg@gmail.com");
				user.setUserPass("Bobby");
				user.setVerifyPassword("Bobby");
				user.setSalutation("Mr.");
				user.setFirstName("Bob");
				user.setLastName("Silverberg");
				user.setLikeCheese(1);
				user.setUserGroup("Something");
			}
			injectMethod(user, this, "evaluateExpression", "evaluateExpression");
			BOValidator = validationFactory.getValidator("User",getDirectoryFromPath(getMetadata(user).path));
			return user;
		</cfscript>
	</cffunction>

	<cffunction name="setupCustomRuleTester" access="private" returntype="void">
		<cfscript>
			customRuleTester = createObject("component","validatethis.unitTests.Fixture.CustomRuleTester").init();
			BOValidator = validationFactory.getValidator("CustomRuleTester",getDirectoryFromPath(getMetadata(customRuleTester).path));
		</cfscript>  
	</cffunction>

	<cffunction name="ResultShouldBeInjectedIntoBOWithInjectResultIntoBOTrue" access="public" returntype="void">
		<cfscript>
			extra = {injectResultIntoBO=true};
			createServerValidator(extra);
			user = setUpUser(true);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",result);
			AssertFalse(user.getVTResult().getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="ResultShouldNotBeInjectedIntoBOWithInjectResultIntoBOFalse" access="public" returntype="void" mxunit:expectedException="Application">
		<cfscript>
			extra = {injectResultIntoBO=false};
			createServerValidator(extra);
			user = setUpUser(true);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",result);
			user.getVTResult();
		</cfscript>  
	</cffunction>

	<cffunction name="ResultShouldNotBeInjectedIntoBOWithDefaultConfig" access="public" returntype="void" mxunit:expectedException="Application">
		<cfscript>
			createServerValidator();
			user = setUpUser(true);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",result);
			user.getVTResult();
		</cfscript>  
	</cffunction>

	<cffunction name="RuleValidatorsShouldBeLoadedCorrectly" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			RuleValidators = serverValidator.getRuleValidators();
			assertTrue(IsStruct(RuleValidators));
			assertTrue(GetMetadata(RuleValidators.Custom).name CONTAINS "ServerRuleValidator_Custom");
			assertTrue(GetMetadata(RuleValidators.Required).name CONTAINS "ServerRuleValidator_Required");
			assertTrue(StructKeyExists(RuleValidators.Required,"validate"));
		</cfscript>  
	</cffunction>

	<cffunction name="ExtraRuleValidatorShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			extra = {ExtraRuleValidatorComponentPaths="validatethis.unitTests.Fixture.ServerRuleValidators"};
			createServerValidator(extra);
			RuleValidators = serverValidator.getRuleValidators();
			assertTrue(GetMetadata(RuleValidators.Custom).name CONTAINS "ServerRuleValidator_Custom");
			assertTrue(GetMetadata(RuleValidators.Required).name CONTAINS "ServerRuleValidator_Required");
			assertTrue(StructKeyExists(RuleValidators.Required,"validate"));
			assertEquals(true,structKeyExists(RuleValidators,"Extra"));
			assertEquals("validatethis.unitTests.fixture.serverrulevalidators.serverrulevalidator_extra",GetMetadata(RuleValidators.Extra).name);
			assertTrue(StructKeyExists(RuleValidators.Extra,"validate"));
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideRuleValidatorsShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			extra = {ExtraRuleValidatorComponentPaths="validatethis.unitTests.Fixture.OverrideServerRuleValidators"};
			createServerValidator(extra);
			RuleValidators = serverValidator.getRuleValidators();
			assertEquals(true,structKeyExists(RuleValidators,"Custom"));
			assertEquals(true,structKeyExists(RuleValidators,"Extra"));
			assertEquals(true,structKeyExists(RuleValidators,"Required"));
			assertEquals("validatethis.unitTests.fixture.overrideserverrulevalidators.serverrulevalidator_custom",GetMetadata(RuleValidators.Custom).name);
			assertEquals("validatethis.unitTests.fixture.overrideserverrulevalidators.serverrulevalidator_extra",GetMetadata(RuleValidators.Extra).name);
			assertEquals("validatethis.server.serverrulevalidator_required",GetMetadata(RuleValidators.Required).name);
			assertTrue(StructKeyExists(RuleValidators.Custom,"validate"));
		</cfscript>  
	</cffunction>

	<cffunction name="ValidateFailsWithCorrectMessages" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser(true);
			result = validationFactory.newResult();
			user.setVerifyPassword("Something that won't match");
			serverValidator.validate(BOValidator,user,"Register",result);
			AssertFalse(result.getIsSuccess());
			Failures = result.getFailures();
			assertEquals(7,ArrayLen(Failures));
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserName");
			assertEquals(Failure.Message,"The Email Address is required.");
			Failure = Failures[2];
			assertEquals(Failure.Type,"email");
			assertEquals(Failure.PropertyName,"UserName");
			assertEquals(Failure.Message,"Hey, buddy, you call that an Email Address?");
			Failure = Failures[3];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password is required.");
			Failure = Failures[4];
			assertEquals(Failure.Type,"rangelength");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password must be between 5 and 10 characters long.");
			Failure = Failures[5];
			assertEquals(Failure.Type,"equalTo");
			assertEquals(Failure.PropertyName,"VerifyPassword");
			assertEquals(Failure.Message,"The Verify Password must be the same as the Password.");
			Failure = Failures[6];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserGroup");
			assertEquals(Failure.Message,"The User Group is required.");
			Failure = Failures[7];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LikeOther");
			assertEquals(Failure.Message,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",result);
			AssertFalse(result.getIsSuccess());
			Failures = result.getFailures();
			assertEquals(10,ArrayLen(Failures));
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserName");
			assertEquals(Failure.Message,"The Email Address is required.");
			Failure = Failures[2];
			assertEquals(Failure.Type,"email");
			assertEquals(Failure.PropertyName,"UserName");
			assertEquals(Failure.Message,"Hey, buddy, you call that an Email Address?");
			Failure = Failures[3];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password is required.");
			Failure = Failures[4];
			assertEquals(Failure.Type,"rangelength");
			assertEquals(Failure.PropertyName,"UserPass");
			assertEquals(Failure.Message,"The Password must be between 5 and 10 characters long.");
			Failure = Failures[5];
			assertEquals(Failure.Type,"equalTo");
			assertEquals(Failure.PropertyName,"VerifyPassword");
			assertEquals(Failure.Message,"The Verify Password must be the same as the Password.");
			Failure = Failures[6];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"UserGroup");
			assertEquals(Failure.Message,"The User Group is required.");
			Failure = Failures[7];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"Salutation");
			assertEquals(Failure.Message,"The Salutation is required.");
			Failure = Failures[8];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"FirstName");
			assertEquals(Failure.Message,"The First Name is required.");
			Failure = Failures[9];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LastName");
			assertEquals(Failure.Message,"The Last Name is required.");
			Failure = Failures[10];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LikeOther");
			assertEquals(Failure.Message,"If you don't like Cheese and you don't like Chocolate, you must like something!");

		</cfscript>  
	</cffunction>

	<cffunction name="OverrideMessageShouldGenerateCorrectMessage" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			user.setUserName("AnInvalidEmailAddress");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			Failures = Result.getFailures();
			Failure = Failures[1];
			AssertEquals(Failure.Message,"Hey, buddy, you call that an Email Address?");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyWithoutValueShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			AssertTrue(Result.getIsSuccess());
			user.setFirstName("");
			user.setLastName("");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			AssertTrue(Result.getIsSuccess());
			user.setFirstName("Bob");
			user.setLastName("");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LastName");
			assertEquals(Failure.Message,"The Last Name is required if you specify a value for the First Name.");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyAsExpressionWithoutValueShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			BOValidator = validationFactory.getValidator("User_Expression",getDirectoryFromPath(getMetadata(user).path));
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			AssertTrue(Result.getIsSuccess());
			user.setFirstName("");
			user.setLastName("");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			AssertTrue(Result.getIsSuccess());
			user.setFirstName("Bob");
			user.setLastName("");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals("required",Failure.Type);
			assertEquals("LastName",Failure.PropertyName);
			assertEquals("The Last Name is required if you specify a value for the First Name.",Failure.Message);
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyWithValueShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
			user.setAllowCommunication(1);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"CommunicationMethod");
			assertEquals(Failure.Message,"If you are allowing communication, you must choose a communication method.");
			user.setCommunicationMethod("Email");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyAsExpressionWithValueShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			BOValidator = validationFactory.getValidator("User_Expression",getDirectoryFromPath(getMetadata(user).path));
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
			user.setAllowCommunication(1);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"CommunicationMethod");
			assertEquals(Failure.Message,"If you are allowing communication, you must choose a communication method.");
			user.setCommunicationMethod("Email");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyWithValueThatReturnsNullShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			// TODO: This needs to be tested with CF9 only
			/*
			createServerValidator();
			user = setUpUser(createNull=true);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
			user.setAllowCommunication(1);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"CommunicationMethod");
			assertEquals(Failure.Message,"If you are allowing communication, you must choose a communication method.");
			user.setCommunicationMethod("Email");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
			*/
		</cfscript>  
	</cffunction>

	<cffunction name="ServerConditionShouldWorkAsExpected" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
			user.setLikeCheese(0);
			user.setLikeChocolate(0);
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertFalse(Result.getIsSuccess());
			Failures = Result.getFailures();
			Failure = Failures[1];
			assertEquals(Failure.Type,"required");
			assertEquals(Failure.PropertyName,"LikeOther");
			assertEquals(Failure.Message,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			user.setLikeOther("Cake");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Profile",Result);
			AssertTrue(Result.getIsSuccess());
		</cfscript>  
	</cffunction>

	<cffunction name="failureMessageReturnedByMethodOnCustomRuleShouldTakePrecedenceOverFailureMessageInXML" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			setupCustomRuleTester();
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,customRuleTester,"",Result);
			failures = Result.getFailuresAsStruct();
			assertEquals("The message returned from the method.",failures.a);
		</cfscript>  
	</cffunction>

	<cffunction name="determineFailureMessageReturnsFrameworkGeneratedFailureMessageIfNotOverridenInXML" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			makePublic(serverValidator,"determineFailureMessage");
			generatedMessage = "A generated message.";
			theVal = mock();
			theVal.getFailureMessage().returns(generatedMessage);
			theVal.getValType().returns("required");
			v = {};
			failureMessage = serverValidator.determineFailureMessage(v,theVal);
			assertEquals(generatedMessage,failureMessage);
		</cfscript>  
	</cffunction>

	<cffunction name="determineFailureMessageReturnsCustomFailureMessageIfOverridenInXML" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			makePublic(serverValidator,"determineFailureMessage");
			generatedMessage = "A generated message.";
			theVal = mock();
			theVal.getFailureMessage().returns(generatedMessage);
			theVal.getValType().returns("required");
			customMessage = "A custom message.";
			v = {FailureMessage=customMessage};
			failureMessage = serverValidator.determineFailureMessage(v,theVal);
			assertEquals(customMessage,failureMessage);
		</cfscript>  
	</cffunction>

	<cffunction name="determineFailureMessageReturnsGeneratedFailureMessageOnCustomRuleIfOverridenInXMLAndNonBlankGeneratedMessage" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			makePublic(serverValidator,"determineFailureMessage");
			generatedMessage = "A generated message.";
			theVal = mock();
			theVal.getFailureMessage().returns(generatedMessage);
			theVal.getValType().returns("custom");
			customMessage = "A custom message.";
			v = {FailureMessage=customMessage};
			failureMessage = serverValidator.determineFailureMessage(v,theVal);
			assertEquals(generatedMessage,failureMessage);
		</cfscript>
	</cffunction>

	<cffunction name="determineFailureMessageReturnsCustomFailureMessageOnCustomRuleIfOverridenInXMLAndBlankGeneratedMessage" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			makePublic(serverValidator,"determineFailureMessage");
			generatedMessage = "";
			theVal = mock();
			theVal.getFailureMessage().returns(generatedMessage);
			theVal.getValType().returns("custom");
			customMessage = "A custom message.";
			v = {FailureMessage=customMessage};
			failureMessage = serverValidator.determineFailureMessage(v,theVal);
			assertEquals(customMessage,failureMessage);
		</cfscript>
	</cffunction>

	<cffunction name="validateDoesNotValidateTheSameObjectTwice" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			user.setUserName("AnInvalidEmailAddress");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"Register",Result);
			assertEquals(1,arrayLen(Result.getFailures()));
			objectList = [user];
			serverValidator.validate(BOValidator,user,"Register",Result,objectList);
			assertEquals(1,arrayLen(Result.getFailures()));
		</cfscript>  
	</cffunction>

	<cffunction name="validateWithAMissingPropertyThrowsErrorWithoutIgnoreMissingPropertiesOption" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.serverValidator.propertyNotFound">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			BOValidator = validationFactory.getValidator("rulesWithMissingProperty",getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"normal",Result);
		</cfscript>  
	</cffunction>

	<cffunction name="validateWithAMissingPropertyIgnoresRuleWithIgnoreMissingPropertiesOption" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			BOValidator = validationFactory.getValidator("rulesWithMissingProperty",getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator=BOValidator,theObject=user,Context="normal",Result=Result,ignoreMissingProperties=true);
			assertEquals(0,arrayLen(Result.getFailures()));
		</cfscript>  
	</cffunction>

	<cffunction name="validateWithAMissingPropertyIgnoresMissingPropertyForCustomValidationType" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			BOValidator = validationFactory.getValidator("rulesWithMissingProperty",getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator,user,"custom",Result);
			assertEquals(0,arrayLen(Result.getFailures()));
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldEnforceRuleWhenProcessOnIsServer" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			user.setUserName("");
			BOValidator = validationFactory.getValidator("rulesForProcessOnTest",getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator=BOValidator,theObject=user,Context="",Result=Result);
			failures = Result.getFailures();
			assertEquals(1,arrayLen(failures));
			assertEquals("UserName",failures[1].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldEnforceRuleWhenProcessOnIsBoth" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			user.setLastName("");
			BOValidator = validationFactory.getValidator("rulesForProcessOnTest",getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator=BOValidator,theObject=user,Context="",Result=Result);
			failures = Result.getFailures();
			assertEquals(1,arrayLen(failures));
			assertEquals("LastName",failures[1].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldEnforceRuleWhenProcessOnIsNotSpecified" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			user.setUserPass("");
			BOValidator = validationFactory.getValidator("rulesForProcessOnTest",getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator=BOValidator,theObject=user,Context="",Result=Result);
			failures = Result.getFailures();
			assertEquals(1,arrayLen(failures));
			assertEquals("UserPass",failures[1].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldNotEnforceRuleWhenProcessOnIsClient" access="public" returntype="void">
		<cfscript>
			createServerValidator();
			user = setUpUser();
			user.setFirstName("");
			BOValidator = validationFactory.getValidator("rulesForProcessOnTest",getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/");
			result = validationFactory.newResult();
			serverValidator.validate(BOValidator=BOValidator,theObject=user,Context="",Result=Result);
			failures = Result.getFailures();
			assertEquals(0,arrayLen(failures));
		</cfscript>  
	</cffunction>

	<cffunction name="evaluateExpression" access="Public" returntype="any" output="false" hint="I dynamically evaluate an expression and return the result.">
		<cfargument name="expression" type="any" required="false" default="1" />
		
		<cfreturn Evaluate(arguments.expression)>

	</cffunction>

</cfcomponent>

