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
			ValidateThisConfig = getVTConfig();
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			variables.className = "user";
			JSLib = "jQuery";
			ExpectedInJSIncludes = '<script src="//ajax.microsoft.com/ajax/jquery/jquery';
			ExpectedInVTSetup = '$.validator.addMethod("regex",function(v,e,p)';
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithExplicitExpandedPath" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadExplicitExpandedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture" & "_Doesnt_Exist/";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithExplicitMappedPath" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadExplicitMappedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = "/validatethis/samples/validatethis/unitTests/Fixture/_Doesnt_Exist/";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithMappingInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.definitionPath = "/validatethis/unitTests/Fixture";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadMappingInValidateThisConfig" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			ValidateThisConfig.definitionPath = "/validatethis/samples/validatethis/unitTests/Fixture/_DoesntExist";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithPhysicalPathInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadPhysicalPathInValidateThisConfig" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture" & "DoesntExist";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
		</cfscript>  
	</cffunction>

	<cffunction name="getRequiredPropertiesReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			FieldList = BOValidator.getRequiredProperties();
			assertEquals(4,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			FieldList = BOValidator.getRequiredProperties("Register");
			assertEquals(4,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			FieldList = BOValidator.getRequiredProperties("Profile");
			assertEquals(7,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"FirstName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"LastName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"Salutation"));
		</cfscript>  
	</cffunction>

	<cffunction name="getRequiredFieldsReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			FieldList = BOValidator.getRequiredFields("Register");
			assertEquals(4,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroupId"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			FieldList = BOValidator.getRequiredFields("Profile");
			assertEquals(7,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroupId"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"FirstName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"LastName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"Salutation"));
		</cfscript>  
	</cffunction>

	<cffunction name="getAllContextsReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			AllContexts = BOValidator.getAllContexts();
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

	<cffunction name="propertyIsRequiredWithDefaultContextShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(true,BOValidator.propertyIsRequired("UserName"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredWithDefaultContextShouldReturnFalseIfPropertyIsNotRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(false,BOValidator.propertyIsRequired("Nickname"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredWithSpecificContextShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(true,BOValidator.propertyIsRequired("FirstName","Profile"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredWithSpecificContextShouldReturnFalseIfPropertyIsNotRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(false,BOValidator.propertyIsRequired("FirstName","Register"));
		</cfscript>  
	</cffunction>

	<cffunction name="fieldIsRequiredWithDefaultContextShouldReturnTrueIfFieldIsRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(true,BOValidator.fieldIsRequired("UserGroupId"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="fieldIsRequiredWithDefaultContextShouldReturnFalseIfFieldIsNotRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(false,BOValidator.fieldIsRequired("Nickname"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="fieldIsRequiredWithSpecificContextShouldReturnTrueIfFieldIsRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(true,BOValidator.fieldIsRequired("FirstName","Profile"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="fieldIsRequiredWithSpecificContextShouldReturnFalseIfFieldIsNotRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(false,BOValidator.fieldIsRequired("FirstName","Register"));
		</cfscript>  
	</cffunction>

	<cffunction name="getInitializationScriptWithDefaultVTConfigReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			BOValidator = createDefaultBOV();
			script = BOValidator.getInitializationScript(JSLib=variables.JSLib);
			assertTrue(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptWithNoIncludesInVTConfigReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			ValidateThisConfig.JSIncludes=false;
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = createDefaultBOV();
			script = BOValidator.getInitializationScript(JSLib=variables.JSLib);
			assertFalse(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getPropertyDescriptionReturnsCorrectPropertyDescriptionFromMetadata" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals("Email Address",BOValidator.getPropertyDescription("UserName"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="getPropertyDescriptionReturnsFormattedPropertyDescriptionWhenPropertyDoesNotExistInMetadata" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals("I Dont Exist",BOValidator.getPropertyDescription("IDontExist"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="getPropertyDescriptionReturnsFormattedPropertyDescriptionWhenPropertyDoesExistInMetadata" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals("First Name",BOValidator.getPropertyDescription("FirstName"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="getClientFieldNameReturnsCorrectClientFieldNameFromMetadata" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals("UserGroupId",BOValidator.getClientFieldName("UserGroup"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="createDefaultBOV" access="private" returntype="any">
		<cfscript>
			// Note, the following contains hardcoded path delimeters - had to change when moving to a Mac
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			return validationFactory.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="isBOVCorrect" access="private" returntype="void">
		<cfargument name="BOValidator">
		<cfscript>
			AllContexts = arguments.BOValidator.getAllContexts();
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

</cfcomponent>

