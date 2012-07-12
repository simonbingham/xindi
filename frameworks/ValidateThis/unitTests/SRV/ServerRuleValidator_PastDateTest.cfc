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
			SRV = getSRV("PastDate");
			defaultBefore="12/29/1968";
            hasBefore = true;
			shouldPassDefault = ["12/21/1920","Dec. 21 1920"];
			shouldFail = ["12/31/1969","Dec. 31 2010","12/31/90","31/12/2012"];
			shouldPass = ["12/28/1968","12/29/1968","1/2/1920","01/1969","12/31/1967"];
		</cfscript>
	</cffunction>
	
	<cffunction name="configureValidationMock" access="private">
        <cfscript>
			if (not isDefined("parameters")) {parameters = {before="12/29/1968"};}
           super.configureValidationMock();
           validation.hasParameter("before").returns(hasBefore);
           validation.getParameterValue("before").returns(defaultBefore);      
        </cfscript>
    </cffunction>
	
	<cffunction name="validateReturnsTrueForDateWithNoBeforeParam" access="public" returntype="void" mxunit:dataprovider="shouldPassDefault">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			super.setup();
			parameters = structNew();
			hasBefore = false;
			objectValue = arguments.value;
			configureValidationMock();

			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForExamplesThatShouldPass" access="public" returntype="void" mxunit:dataprovider="shouldPass">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			
			super.setup();
            hasBefore = true;
            defaultBefore = "1/2/1969";
            objectValue = arguments.value;
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForExamplesThatShouldNotPass" access="public" returntype="void" mxunit:dataprovider="shouldFail">
		<cfargument name="value" hint="each item in the shouldFail dataprovider array" />
		<cfscript>
			
			super.setup();
			hasBefore = true;
            objectValue = arguments.value;
            configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			hasBefore = true;
            objectValue = "";
            isRequired=false;
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="Overriding this as it actually should return true.">
		<cfscript>
			hasBefore = true;
            objectValue = "";
            isRequired=true;
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
			hasBefore = false;
            objectValue = "";
            isRequired=true;
            failureMessage = "The PropertyDesc must be a date in the past.";
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="failureMessageIsCorrectWithAfter" access="public" returntype="void">
		<cfscript>
			objectValue = "";
            parameters = {before="12/29/1969"};
            hasBefore = true;
            defaultBefore="12/29/1969";
            isRequired=true;
            failureMessage = "The PropertyDesc must be a date in the past. The date entered must come before 12/29/1969.";
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
		
</cfcomponent>
