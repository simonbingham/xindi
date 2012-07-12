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
			SRV = getSRV("Expression");
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenExpressionEvaluatesToFalse" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","validatethis.unitTests.Fixture.User").init();
			theObject.setUserId(1);
			theObject.setUserName(2);
			parameters = {expression="getUserId() eq getUserName()"};

            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueWhenExpressionEvaluatesToTrue" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","validatethis.unitTests.Fixture.User").init();
			theObject.setUserId(1);
			theObject.setUserName(1);
			parameters = {expression="getUserId() eq getUserName()"};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenExpressionEvaluatesToFalseWithAStructUsingGetValue" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","ValidateThis.core.StructWrapper").init();
			theStruct = {userId=1,userName=2};
			theObject.setup(theStruct);
			parameters = {expression="getValue('UserId') eq getValue('UserName')"};
            
            configureValidationMock();

			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueWhenExpressionEvaluatesToTrueWithAStructUsingGetValue" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","ValidateThis.core.StructWrapper").init();
			theStruct = {userId=1,userName=1};
			theObject.setup(theStruct);
			parameters = {expression="getValue('UserId') eq getValue('UserName')"};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenExpressionEvaluatesToFalseWithAStructUsingVariables" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","ValidateThis.core.StructWrapper").init();
			theStruct = {userId=1,userName=2};
			theObject.setup(theStruct);
			parameters = {expression="UserId eq UserName"};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueWhenExpressionEvaluatesToTrueWithAStructUsingVariables" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","ValidateThis.core.StructWrapper").init();
			theStruct = {userId=1,userName=1};
			theObject.setup(theStruct);
			parameters = {expression="UserId eq UserName"};
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	 <!--- Must override these from the base test as they are irrelevent for Expression --->	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
	</cffunction>
	
</cfcomponent>
