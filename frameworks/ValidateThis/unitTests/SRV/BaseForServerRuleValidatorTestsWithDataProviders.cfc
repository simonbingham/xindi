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
<cfcomponent extends="BaseForServerRuleValidatorTests"output="false">
	
	<cffunction name="validateReturnsTrueForExamplesThatShouldPass" access="public" returntype="void" mxunit:dataprovider="shouldPass" hint="Tests a set of valid values to see if they pass">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			super.setup();
			objectValue = arguments.value;
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForExamplesThatShouldNotPass" access="public" returntype="void" mxunit:dataprovider="shouldFail" hint="Tests a set of invalid values to see if they fail">
		<cfargument name="value" hint="each item in the shouldFail dataprovider array" />
		<cfscript>
			super.setup();
			objectValue = arguments.value;
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<!--- These two tests will be identical for each SRV, but should be run for each --->
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			super.setup();
			objectValue = "";
			isRequired=false;
			failureMessage = "";
			
			configureValidationMock();			
			
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			super.setup();
			objectValue = "";
			isRequired = true;
			failureMessage = "";
			
			configureValidationMock();
			
			executeValidate(validation);			
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
