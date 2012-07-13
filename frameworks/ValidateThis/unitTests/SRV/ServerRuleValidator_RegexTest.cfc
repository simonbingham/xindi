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
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("Regex");
			parameters = {Regex="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$"};
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidRegex" access="public" returntype="void">
		<cfscript>
			objectValue= "Mr.";
			configureValidationMock();

			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidRegex" access="public" returntype="void">
		<cfscript>
			objectValue= 1;
            configureValidationMock();
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidRegexWithServerRegexParameter" access="public" returntype="void">
		<cfscript>
            objectValue= 1;
			parameters = {ServerRegex="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$"};
            configureValidationMock();
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
			objectValue = 1;
            failureMessage = "The PropertyDesc must match the specified pattern.";
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>

</cfcomponent>
