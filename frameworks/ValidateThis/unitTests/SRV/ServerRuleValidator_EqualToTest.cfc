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
			SRV = getSRV("equalTo");
		</cfscript>
	</cffunction>

	<cffunction name="configureValidationMock" access="private">
        <cfscript>
			
			super.configureValidationMock();
			
			validation.getParameterValue("ComparePropertyName").returns("VerifyPassword");
			validation.getObjectValue("VerifyPassword").returns(otherObjectValue);

        </cfscript>
    </cffunction>

	<cffunction name="validateReturnsTrueWhenPropertiesAreEqual" access="public" returntype="void">
		<cfscript>
			validation.getParameterValue("ComparePropertyDesc","").returns("Verify The Password");
			objectValue = "12345";
			otherObjectValue = "12345";
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenPropertiesAreNotEqual" access="public" returntype="void">
		<cfscript>
			validation.getParameterValue("ComparePropertyDesc","").returns("Verify The Password");
			objectValue = "12345";
			otherObjectValue = "";
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateSetsFailureMessageFromDescParameterWhenADescParamaterIsProvided" access="public" returntype="void">
		<cfscript>
			validation.getParameterValue("ComparePropertyDesc","").returns("Verify The Password");
			failureMessage = "The PropertyDesc must be the same as the Verify The Password.";
			objectValue = "12345";
			otherObjectValue = "";
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateSetsFailureMessageWithCorrectDescFromMetadataWhenNoDescParamaterIsProvided" access="public" returntype="void">
		<cfscript>
			ValidateThis = mock();
			ValidateThis.getPropertyDescription(objectType="mockObjectType",propertyName="otherPropertyName").returns("mock description");
			validation.getObjectType().returns("mockObjectType");
			validation.getParameterValue("ComparePropertyDesc","").returns("");
			failureMessage = "The PropertyDesc must be the same as the mock description.";
			objectValue = "12345";
			otherObjectValue = "";
            configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void" hint="This test is not applicable to this SRV">
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="This test is not applicable to this SRV">
	</cffunction>
	
</cfcomponent>
