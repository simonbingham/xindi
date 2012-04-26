<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ServerRuleValidator_Required" extends="AbstractServerRuleValidator" hint="I am responsible for performing the Required validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />

		<cfscript>
		
		var parameters = arguments.validation.getParameters();
		var theCondition = arguments.validation.getCondition();
		var conditionDesc = "";
		var otherPropertyDesc = "";
		var theValue = arguments.validation.getObjectValue();
		var args = [arguments.validation.getPropertyDesc()];
		var msgKey = "defaultMessage_Required";

		if (isSimpleValue(theValue) AND Len(theValue) EQ 0) {
			
			if (StructKeyExists(theCondition,"Desc")) {

				msgKey = "defaultMessage_Required_Condition";
				arrayAppend(args,theCondition.Desc);

			} else {
				
				if (StructKeyExists(parameters,"DependentPropertyName")) {
					
					arrayAppend(args,variables.defaultFailureMessagePrefix);

					if (StructKeyExists(parameters,"DependentPropertyDesc")) {
						
						otherPropertyDesc = parameters.DependentPropertyDesc;

					} else {
						
						otherPropertyDesc = arguments.validation.getValidateThis().getPropertyDescription(objectType=arguments.validation.getObjectType(),propertyName=parameters.DependentPropertyName);
						
					}

					arrayAppend(args,otherPropertyDesc);

					if (StructKeyExists(parameters,"DependentPropertyValue")) {
						
						msgKey = "defaultMessage_Required_DependentPropertyValue";

					} else {
						
						msgKey = "defaultMessage_Required_DependentProperty";

					}
				}
			}
			fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage(msgKey,args,arguments.locale));
		}
		</cfscript>
	</cffunction>
	
</cfcomponent>