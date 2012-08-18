<!---
			
	Copyright 2009, Bob Silverberg
	
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
			variables.CSGenerator = validationFactory.getBean("CommonScriptGenerator");
			variables.JSLib = "jQuery";
			variables.ExpectedInJSIncludes = '<script src="//ajax.microsoft.com/ajax/jquery/jquery';
			variables.ExpectedInVTSetup = '$.validator.addMethod("regex",function(v,e,p)';
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptDefaultReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			script = variables.CSGenerator.getInitializationScript(JSLib=variables.JSLib);
			assertTrue(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptNoIncludesReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			script = variables.CSGenerator.getInitializationScript(JSLib=variables.JSLib,JSIncludes=false);
			assertFalse(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptOnFacadeWithNoIncludesInVTConfigReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			ValidateThisConfig.JSIncludes=false;
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig);
			script = ValidateThis.getInitializationScript(JSLib=variables.JSLib);
			assertFalse(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptOnBOVWithNoIncludesInVTConfigReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			ValidateThisConfig.JSIncludes=false;
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig);
			script = ValidateThis.getInitializationScript(JSLib=variables.JSLib);
			assertFalse(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptWithLocaleReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			script = variables.CSGenerator.getInitializationScript(JSLib=variables.JSLib,locale="fr_FR");
			assertTrue(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

	<cffunction name="getInitializationScriptWithLocaleNoIncludesReturnsCorrectScript" returntype="void" access="public">
		<cfscript>
			script = variables.CSGenerator.getInitializationScript(JSLib=variables.JSLib,JSIncludes=false,locale="fr_FR");
			assertFalse(script CONTAINS variables.ExpectedInJSIncludes);
			assertTrue(script CONTAINS variables.ExpectedInVTSetup);
		</cfscript>
	</cffunction>

</cfcomponent>

