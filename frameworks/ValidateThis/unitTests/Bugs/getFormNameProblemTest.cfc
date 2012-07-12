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
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/";
			BOValidator = validationFactory.getValidator("getFormNameProblem",defPath);
			/*
			customer = mock();
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			customer.isUsernameAvailable().returns(customResult);
			*/
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="getFormNameWithEmptyStringShouldReturnDefaultFromConfig" access="public" returntype="void">
		<cfscript>
			assertEquals("frmMain",BOValidator.getFormName(""));
		</cfscript>  
	</cffunction>

	<cffunction name="getFormNameWithContextWithRulesShouldReturnContextsFormName" access="public" returntype="void">
		<cfscript>
			assertEquals("frmRegister",BOValidator.getFormName("Register"));
			assertEquals("frmProfile",BOValidator.getFormName("Profile"));
		</cfscript>  
	</cffunction>

	<cffunction name="getFormNameWithContextWithoutRulesShouldReturnContextsFormName" access="public" returntype="void">
		<cfscript>
			assertEquals("frmOther",BOValidator.getFormName("Other"));
		</cfscript>  
	</cffunction>

</cfcomponent>

