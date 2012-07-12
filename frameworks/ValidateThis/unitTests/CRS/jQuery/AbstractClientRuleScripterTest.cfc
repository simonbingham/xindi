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
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="getSafeFormNameShouldReturnFormNameWithOnlyAlphanumericChars" access="public" returntype="void">
		<cfscript>
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			assertEquals("formName",ScriptWriter.getSafeFormName("formName"));
			assertEquals("formName2",ScriptWriter.getSafeFormName("form-Name2"));
		</cfscript>  
	</cffunction>

	<cffunction name="ClientRuleScriptersShouldBeLoadedCorrectly" access="public" returntype="void">
		<cfscript>
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			CRSs = ClientValidator.getScriptWriter("jQuery").getRuleScripters();
			assertTrue(IsStruct(CRSs));
			assertTrue(GetMetadata(CRSs.Boolean).name CONTAINS "ClientRuleScripter_Boolean");
			assertTrue(GetMetadata(CRSs.Boolean).name CONTAINS "ValidateThis");
			assertTrue(StructKeyExists(CRSs.Boolean,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="ExtraClientRuleScriptersShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="validatethis.unitTests.Fixture.ClientScriptWriters.newCSW";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			CRSs = ClientValidator.getScriptWriter("newCSW").getRuleScripters();
			assertTrue(IsStruct(CRSs));
			assertTrue(GetMetadata(CRSs.Boolean).name CONTAINS "ClientRuleScripter_Boolean");
			assertTrue(GetMetadata(CRSs.Boolean).name CONTAINS "Fixture");
			assertTrue(StructKeyExists(CRSs.Boolean,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideClientScriptWritersShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="validatethis.unitTests.Fixture.ClientScriptWriters.jQuery";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			CRSs = ClientValidator.getScriptWriter("jQuery").getRuleScripters();
			assertTrue(IsStruct(CRSs));
			assertTrue(GetMetadata(CRSs.Boolean).name CONTAINS "ClientRuleScripter_Boolean");
			assertTrue(GetMetadata(CRSs.Boolean).name CONTAINS "Fixture");
			assertTrue(StructKeyExists(CRSs.Boolean,"generateValidationScript"));
		</cfscript>  
	</cffunction>

</cfcomponent>