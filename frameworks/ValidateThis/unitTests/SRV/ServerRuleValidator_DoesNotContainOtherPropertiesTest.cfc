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
			SRV = getSRV("DoesNotContainOtherProperties");
            hasPropertyNames = true;
			shouldPass = ["goodStuff"];
			shouldFail = ["badStuff"];
		</cfscript>
	</cffunction>
	
	<cffunction name="configureValidationMock" access="private">
		<cfscript>
			parameters = {propertyNames="name"};
			hasValue = true;
			super.configureValidationMock();
			validation.getObjectValue("name").returns("badStuff");
			validation.getParameterValue("propertyNames").returns(parameters.propertyNames);
			validation.hasParameter("delim").returns(true);
			validation.getParameterValue("delim").returns(",");
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForExamplesThatShouldPass" access="public" returntype="void" mxunit:dataprovider="shouldPass">
		<cfargument name="value" hint="each item in the shouldPass dataprovider array" />
		<cfscript>
			objectValue = arguments.value;
			configureValidationMock();
            
			makePublic(SRV,"shouldTest");
            assertEquals(true,SRV.shouldTest(validation));
            
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	<cffunction name="validateReturnsFalseForExamplesThatShouldNotPass" access="public" returntype="void" mxunit:dataprovider="shouldFail">
        <cfargument name="value" hint="each item in the shouldFail dataprovider array" />
        <cfscript>
            objectValue = arguments.value;
            isRequired = false;
            configureValidationMock();
            
            makePublic(SRV,"shouldTest");
            assertEquals(true,SRV.shouldTest(validation));
            
            executeValidate(validation);
            validation.verifyTimes(1).fail("{*}"); 
        </cfscript>  
    </cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			// just an empty test to override the behaviour in the base object
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			objectValue = "";
			hasValue = false;
			isRequired = true;
            configureValidationMock();
			
			executeValidate(validation);
            validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="failureMessageIsCorrect" access="public" returntype="void">
		<cfscript>
            objectValue = "badStuff";
            isRequired = false;
            failureMessage = "The PropertyDesc must not contain the values of properties named: name.";
            configureValidationMock();
            
            makePublic(SRV,"shouldTest");
            assertEquals(true,SRV.shouldTest(validation));
            
            executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>

</cfcomponent>
