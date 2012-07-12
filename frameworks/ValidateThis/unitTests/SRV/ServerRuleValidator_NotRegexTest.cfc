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
			SRV = getSRV("NotRegex");
			parameters = {Regex="[,\.\*]+"};
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidRegex" access="public" returntype="void">
		<cfscript>
			objectValue= "abc123";
			configureValidationMock();

			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidRegex" access="public" returntype="void">
		<cfscript>
			objectValue="abc.123";
            configureValidationMock();
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidRegexWithServerRegexParameter" access="public" returntype="void">
		<cfscript>
            objectValue= "abc,123";
			parameters = {ServerRegex="[,\.\*]+"};
            configureValidationMock();
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
			objectValue = "abc*123";
            failureMessage = "The PropertyDesc must not match the specified pattern.";
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
            isRequired= false;
            
            configureValidationMock();
            
            validation.hasParameter("regexp").returns(true);
            validation.getParameterValue("regexp").returns(parameters.Regex);
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="Overriding this as it actually should return true.">
		<cfscript>
			objectValue = "";
            isRequired= true;
            
            configureValidationMock();
            
            validation.hasParameter("regexp").returns(true);
            validation.getParameterValue("regexp").returns(parameters.Regex);
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>


</cfcomponent>
