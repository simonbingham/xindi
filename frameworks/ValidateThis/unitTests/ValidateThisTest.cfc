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
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			VTConfig = {definitionPath="/validatethis/unitTests/Fixture"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			JSLib = "jQuery";
			ExpectedInJSIncludes = '<script src="//ajax.microsoft.com/ajax/jquery/jquery';
			ExpectedInVTSetup = '$.validator.addMethod("regex",function(v,e,p)';
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="getVersionReturnsCurrentVersion" access="public" returntype="void">
		<cfscript>
			assertEquals("1.2",ValidateThis.getVersion());
		</cfscript>  
	</cffunction>

	<cffunction name="getVTFolderReturnsVTFolder" access="public" returntype="void">
		<cfscript>
			assertEqualsCase("ValidateThis",ValidateThis.getVTFolder());
		</cfscript>  
	</cffunction>

	<cffunction name="defaultVTConfigShouldBeAccurate" access="public" returntype="void">
		<cfscript>
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(structNew());
			injectMethod(ValidateThis, this, "getVTConfig", "getVTConfig");
			VTConfig = ValidateThis.getVTConfig();
			expectedLocaleMap = {en_US="/ValidateThis/locales/en_US.properties"};
			assertEquals("ValidateThis.core.BOValidator",VTConfig.BOValidatorPath);
			assertEquals("jQuery",VTConfig.DefaultJSLib);
			assertEquals("",VTConfig.ExtraClientScriptWriterComponentPaths);
			assertEquals("",VTConfig.ExtraRuleValidatorComponentPaths);
			assertEquals(true,VTConfig.JSIncludes);
			assertEquals("js/",VTConfig.JSRoot);
			assertEquals("ValidateThis.core.BaseLocaleLoader",VTConfig.LocaleLoaderPath);
			assertEquals("ValidateThis.util.Result",VTConfig.ResultPath);
			assertEquals("ValidateThis.core.BaseTranslator",VTConfig.TranslatorPath);
			assertEquals("getValue",VTConfig.abstractGetterMethod);
			assertEquals("The ",VTConfig.defaultFailureMessagePrefix);
			assertEquals("frmMain",VTConfig.defaultFormName);
			assertEquals("en_US",VTConfig.defaultLocale);
			assertEquals("/model/",VTConfig.definitionPath);
			assertEquals("xml,json",VTConfig.externalFileTypes);
			assertEquals("",VTConfig.extraFileReaderComponentPaths);
			assertEquals(false,VTConfig.injectResultIntoBO);
			assertEquals(expectedLocaleMap,VTConfig.localeMap);
			assertEquals("",VTConfig.BOComponentPaths);
			assertEquals("",VTConfig.ExtraAnnotationTypeReaderComponentPaths);
			assertEqualsCase("ValidateThis",VTConfig.vtFolder);
		</cfscript>  
	</cffunction>

	<cffunction name="getVTConfig" access="public" output="false" returntype="any" hint="Used to retrieve the VTConfig for testing.">
		<cfparam name="variables.ValidateThisConfig" default="#structNew()#" />
		<cfreturn variables.ValidateThisConfig />
	</cffunction>

	<cffunction name="getInitializationScriptWithDefaultVTConfigReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			script = ValidateThis.getInitializationScript(JSLib=variables.JSLib);
			assertTrue(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptWithNoIncludesInVTConfigReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			VTConfig.JSIncludes=false;
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			script = ValidateThis.getInitializationScript(JSLib=variables.JSLib);
			assertFalse(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="validateShouldBeAbleToCallValidateOnAStruct" access="public" returntype="void">
		<cfscript>
			theStruct = setUpUserStruct(true);
			result = ValidateThis.validate(theStruct);
		</cfscript>
	</cffunction>

	<cffunction name="validateStructFailsWithCorrectMessages" access="public" returntype="void">
		<cfscript>
			theStruct = setUpUserStruct(true);
			theStruct.VerifyPassword="Something that won't match";
			result = ValidateThis.validate(theObject=theStruct,context="Register");
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
			result = ValidateThis.validate(theObject=theStruct,context="Profile");
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

	<cffunction name="validateStructPassesWithCorrectData" access="public" returntype="void">
		<cfscript>
			theStruct = setUpUserStruct();
			result = ValidateThis.validate(theObject=theStruct,context="Register");
			AssertTrue(result.getIsSuccess());
			Failures = result.getFailures();
		</cfscript>  
	</cffunction>

	<cffunction name="determineObjectTypeShouldReturnObjectNameFromStructWithObjectTypeKey" access="public" returntype="void">
		<cfscript>
			theStruct = {objectType="user"};
			assertEquals("user",ValidateThis.determineObjectType(theObject=theStruct));
		</cfscript>  
	</cffunction>

	<cffunction name="determineObjectTypeShouldReturnObjectTypeIfOneExplicitlyPassedIn" access="public" returntype="void">
		<cfscript>
			theStruct = {};
			assertEquals("user",ValidateThis.determineObjectType(theObject=theStruct,objectType="user"));
		</cfscript>  
	</cffunction>

	<cffunction name="determineObjectTypeShouldThrowWithStructWithNoObjectTypeKey" access="public" returntype="void" mxunit:expectedException="ValidateThis.ValidateThis.ObjectTypeRequired">
		<cfscript>
			theStruct = {};
			assertEquals("user",ValidateThis.determineObjectType(theObject=theStruct));
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture");
			BOValidator = ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlCfmRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture_cfm");
			BOValidator = ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlFileIsInAConfiguredFolder" access="public" returntype="void">
		<cfscript>
			VTConfig = 	{definitionPath=getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			theObject = createObject("component","Fixture.ObjectWithSeparateRulesFile");
			BOValidator = ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="newResultShouldReturnBuiltInResultObjectWithDefaultConfig" access="public" returntype="void">
		<cfscript>
			result = ValidateThis.newResult();
			assertEquals("validatethis.util.Result",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="newResultShouldReturnCustomResultObjectWhenspecifiedViaConfig" access="public" returntype="void">
		<cfscript>
			vtConfig = {ResultPath="validatethis.unitTests.Fixture.CustomResult"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(vtConfig);
			result = ValidateThis.newResult();
			assertEquals("validatethis.unitTests.Fixture.CustomResult",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="transientFactoryShouldHaveVTFacadeInjectedIntoIt" access="public" returntype="void">
		<cfscript>
			transientFactory = ValidateThis.getBean("TransientFactory");
			validation = transientFactory.newValidation();
			assertEquals("validatethis.ValidateThis",GetMetadata(validation.getValidateThis()).name);
		</cfscript>
	</cffunction>

	<cffunction name="getValidationScriptShouldAllowForAnObjectToBePassedInAndUsedInAnExpressionTypeParameter" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.CFCWithMethodForExpressionTypeParameter").init();
			script = ValidateThis.getValidationScript(theObject=theObject);
			assertTrue(script contains "rules('add',{""inlist"":{""list"":""1,2,3""},""messages"":{""inlist"":""The Test Prop was not found in the list: 1,2,3.""}});",htmlEditFormat(script));
		</cfscript>  
	</cffunction>

	<cffunction name="getValidationScriptShouldAllowForAnEmptyStringToBePassedInAsTheObject" access="public" returntype="void">
		<cfscript>
			theObject = "";
			script = ValidateThis.getValidationScript(theObject=theObject,objectType="RuleWithADynamicParameterThatDoesNotNeedAnObject");
			assertTrue(script contains "fm['testProp'] = $("":input[name='testProp']"",$form_frmMain);");
			assertTrue(script contains "if(fm['testProp'].length)");
			assertTrue(script contains "fm['testProp'].rules('add',{""inlist""");
		</cfscript>  
	</cffunction>


	<cffunction name="setUpUserStruct" access="private" returntype="any">
		<cfargument name="emptyUser" type="boolean" required="false" default="false" />
		<cfscript>
			userStruct = {objectType="user_struct"};
			userStruct.LikeCheese=0;
			userStruct.LikeChocolate=0;
			if (not arguments.emptyUser) {
				userStruct.UserName="bob.silverberg@gmail.com";
				userStruct.UserPass="Bobby";
				userStruct.VerifyPassword="Bobby";
				userStruct.Salutation="Mr.";
				userStruct.FirstName="Bob";
				userStruct.LastName="Silverberg";
				userStruct.LikeCheese=1;
				userStruct.UserGroup="Something";
			}
			return userStruct;
		</cfscript>
	</cffunction>

</cfcomponent>

