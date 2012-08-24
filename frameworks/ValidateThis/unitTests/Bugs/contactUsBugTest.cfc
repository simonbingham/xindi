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
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/";
			validateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig);
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="getValidationScriptWithContextPassedShouldReturnOnlyRulesForThatContext" access="public" returntype="void">
		<cfscript>
			script = validateThis.getValidationScript(objectType="ContactUs",Context="backEnd");
			assertTrue(script contains '{required:true,messages:{required:"The Full Name is required."}}');
			assertTrue(script contains '{required:true,messages:{required:"The A category must be selected is required."}}');
			script = validateThis.getValidationScript(objectType="ContactUs",Context="contactUsForm");
			assertTrue(script contains '{required:true,messages:{required:"The Full Name is required."}}');
			assertFalse(script contains '{required:true,messages:{required:"The A category must be selected is required."}}');
		</cfscript>  
	</cffunction>

</cfcomponent>

