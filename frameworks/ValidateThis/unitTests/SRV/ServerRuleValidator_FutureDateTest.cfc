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
			SRV = getSRV("FutureDate");
			defaultAfter="12/29/1968";
			hasAfter = true;
			shouldPassDefault = ["12/21/2012","Dec. 21 2012"];
			shouldPass = ["12/31/1969","Dec. 31 2010","12/31/90","31/12/2012"];
			shouldFail = ["12/28/1968","12/29/1968","1/2/1920","01/1969","12/31/1967"];
		</cfscript>
	</cffunction>

	<cffunction name="configureValidationMock" access="private">
        <cfscript>
           super.configureValidationMock();
           validation.hasParameter("after").returns(hasAfter);
           validation.getParameterValue("after").returns(defaultAfter);      
        </cfscript>
    </cffunction>

	<cffunction name="validateReturnsTrueForDateWithNoBeforeParam" access="public" returntype="void" mxunit:dataprovider="shouldPassDefault">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			super.setup();
			objectValue = arguments.value;
			parameters = structNew();
			hasAfter = false;

			configureValidationMock();			

			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForExamplesThatShouldPass" access="public" returntype="void" mxunit:dataprovider="shouldPass">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			super.setup();
			objectValue = arguments.value;
            parameters = {after="12/29/1969"};
            hasAfter = true;
            defaultAfter="12/29/1969";
            
            configureValidationMock();                     			

			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsFalseForExamplesThatShouldNotPass" access="public" returntype="void" mxunit:dataprovider="shouldFail">
		<cfargument name="value" hint="each item in the shouldFail dataprovider array" />
		<cfscript>
			super.setup();
			objectValue = arguments.value;
            parameters = {after="12/29/1969"};
            hasAfter = true;
            defaultAfter="12/29/1969";
            
            configureValidationMock(); 
                   
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
            parameters = {after="12/29/1969"};
            hasAfter = true;
            defaultAfter="12/29/1969";
            isRequired=false;
            
            configureValidationMock();  
                  
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="Overriding this as it actually should return true.">
		<cfscript>
			objectValue = "";
            parameters = {after="12/29/1969"};
            hasAfter = true;
            defaultAfter="12/29/1969";
            isRequired=true;
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
			objectValue = "";
            hasAfter = false;
            isRequired=true;
            failureMessage = "The PropertyDesc must be a date in the future.";
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="failureMessageIsCorrectWithAfter" access="public" returntype="void">
		<cfscript>
			objectValue = "";
            parameters = {after="12/29/1969"};
            hasAfter = true;
            defaultAfter="12/29/1969";
            isRequired=true;
            failureMessage = "The PropertyDesc must be a date in the future. The date entered must come after 12/29/1969.";
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
