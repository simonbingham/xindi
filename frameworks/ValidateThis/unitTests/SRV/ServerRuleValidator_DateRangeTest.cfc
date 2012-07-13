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
<cfcomponent extends="validatethis.unitTests.SRV.BaseForServerRuleValidatorTestsWithDataproviders" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("dateRange");
			//parameters = {from="12/29/1968",until="1/1/1969"};
			
			shouldPass = ["12/29/1968","1/1/1969","1968/12/29","1968-12-29","12/31/1968","31-Dec-68","December 31, 1968","Dec. 31 1968","12/31/68","31/12/1968","1968-12-31"];
			shouldFail = ["12/28/1969","1/2/1969","01/02/1969","12/31/1969","2010-12-31","abc",-1];
		</cfscript>
	</cffunction>
	
	<cffunction name="configureValidationMock" access="private">
        <cfscript>
            
           super.configureValidationMock();
            
           validation.getParameterValue("from").returns("12/29/1968");
           validation.getParameterValue("until").returns("1/1/1969");

        </cfscript>
    </cffunction>
    
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="Overriding this as it actually should return true.">
		<cfscript>
			objectValue = "";
			isRequired = true;
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
			objectValue = "12/28/1969";
            failureMessage = "The PropertyDesc must be a valid date between 12/29/1968 and 1/1/1969.";
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
