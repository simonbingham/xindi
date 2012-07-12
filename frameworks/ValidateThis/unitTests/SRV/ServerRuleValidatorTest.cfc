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
<cfcomponent extends="validatethis.unitTests.SRV.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="defaultFailureMessagesShouldBePrependedWithTheDefaultPrefix" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("required");
			objectValue = "";
			failureMessage = "The PropertyDesc is required.";
            
            configureValidationMock();			
            
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>

	<cffunction name="propertyIsRequiredShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(true);
			makePublic(SRV,"propertyIsRequired");
			assertEquals(true,SRV.propertyIsRequired(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredShouldReturnFalseIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(false);
			makePublic(SRV,"propertyIsRequired");
			assertEquals(false,SRV.propertyIsRequired(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(true);
			validation.getObjectValue().returns("");
			validation.propertyHasValue().returns(false);
			makePublic(SRV,"shouldTest");
			assertEquals(true,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnTrueIfPropertyHasValue" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(false);
			validation.getObjectValue().returns("Something");
			validation.propertyHasValue().returns(true);
			makePublic(SRV,"shouldTest");
			assertEquals(true,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnTrueIfPropertyHasValueAndIsRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(true);
			validation.getObjectValue().returns("Something");
			validation.propertyHasValue().returns(true);
			makePublic(SRV,"shouldTest");
			assertEquals(true,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="shouldTestShouldReturnFalseIfPropertyNotPopulatedAndNotRequired" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("email");
			validation.getIsRequired().returns(false);
			validation.propertyHasValue().returns(false);
			validation.getObjectValue().returns("");
			makePublic(SRV,"shouldTest");
			assertEquals(false,SRV.shouldTest(validation));
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void" hint="Inherited method that is not applicable to this test case.">
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="Inherited method that is not applicable to this test case.">
	</cffunction>

	<cffunction name="validate" access="private" returntype="Any">
		<cfargument name="theObject" />
		<cfargument name="validation" />
		<cfargument name="Parameters" required="false" default="#StructNew()#" />
		<cfargument name="Condition" required="false" default="#StructNew()#" />
		<cfargument name="PropertyName" required="false" default="FirstName" />
		<cfargument name="PropertyDesc" required="false" default="First Name" />
		
		<cfset Validation = CreateObject("component","ValidateThis.core.validation").init(arguments.theObject,ObjectChecker).load(arguments) />
		<cfset CreateObject("component","ValidateThis.server.ServerRuleValidator_#arguments.validation#").init(ObjectChecker).validate(Validation) />
		<cfreturn Validation />
		
	</cffunction>

</cfcomponent>


