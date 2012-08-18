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
<cfcomponent extends="validatethis.unitTests.BaseTestCase" output="false">
	
	<cfset ClientValidator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig);
			validation = {clientFieldName="clientFieldName",condition=structNew(),formName="formName",parameters=structNew(),propertyDesc="propertyDesc",propertyName="propertyName",valType="required",processOn="both"};
			validations = [validation];
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="ClientScriptWritersShouldBeLoadedCorrectly" access="public" returntype="void">
		<cfscript>
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.jQuery).name CONTAINS "ClientScriptWriter_jQuery");
			assertTrue(StructKeyExists(ClientScriptWriters.jQuery,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="ExtraClientScriptWriterShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="validatethis.unitTests.Fixture.ClientScriptWriters.newCSW";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.newCSW).name CONTAINS "ClientScriptWriter_newCSW");
			assertTrue(StructKeyExists(ClientScriptWriters.newCSW,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideClientScriptWritersShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="validatethis.unitTests.Fixture.ClientScriptWriters.newCSW,validatethis.unitTests.Fixture.ClientScriptWriters.jQuery";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.jQuery).name CONTAINS "Fixture");
			assertTrue(StructKeyExists(ClientScriptWriters.jQuery,"generateValidationScript"));
			assertTrue(GetMetadata(ClientScriptWriters.newCSW).name CONTAINS "ClientScriptWriter_newCSW");
			assertTrue(StructKeyExists(ClientScriptWriters.newCSW,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="getValidationScriptShouldHonourPassedInFormName" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery");
			assertTrue(script contains "$form_testFormName = $(""##testFormName"");");
			assertTrue(script contains "$form_testFormName.validate({ignore:'.ignore'});");
			assertTrue(script contains "fm['clientFieldName'] = $("":input[name='clientFieldName']"",$form_testFormName);");
		</cfscript>  
	</cffunction>

	<cffunction name="getValidationScriptShouldAllowForAnObjectToBePassedInAndUsedInAnExpressionTypeParameter" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			parameter = {name="list",value="getList()",type="expression"};
			parameters = {list=parameter};
			validation = {clientFieldName="clientFieldName",condition=structNew(),formName="formName",parameters=parameters,propertyDesc="propertyDesc",propertyName="propertyName",valType="inList",processOn="both"};
			validations = [validation];
			theObject = mock();
			theObject.evaluateExpression("getList()").returns("1,2");
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery",theObject=theObject);
			assertTrue(script contains "$form_testFormName = $(""##testFormName"");");
			assertTrue(script contains "$form_testFormName.validate({ignore:'.ignore'});");
			assertTrue(script contains "fm['clientFieldName'] = $("":input[name='clientFieldName']"",$form_testFormName);","invalid input selector");
			assertTrue(script contains "fm['clientFieldName'].rules","invalid field selector");
			assertTrue(script contains 'rules(''add'',{"inlist":{"list":"1,2"},"messages":{"inlist":"The propertyDesc was not found in the list: 1,2."}});',"Invalid Rules('add') script:" & htmlEditFormat(script));
		</cfscript>  
	</cffunction>

	<!---  ValidationJSON --->
	<cffunction name="getValidationRulesStructShouldReturnStruct" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			theStruct = ClientValidator.getValidationRulesStruct(validations=validations,formName="testFormName",jsLib="jQuery");
			assertTrue(isStruct(theStruct),"Did not return valid JSON #htmlEditFormat(serializeJSON(theStruct))#");
			assertTrue(structKeyExists(theStruct,"messages"),"Validation JSON does not contain messages struct");
			assertTrue(structKeyExists(theStruct['rules'],"clientFieldName"),"Validation JSON does not contain rules for property 'clientFieldName' - #htmlEditFormat(serializeJSON(theStruct))#");
			assertTrue(structKeyExists(theStruct['rules'],"clientFieldName"),"Validation JSON does not contain rules for property 'clientFieldName' - #htmlEditFormat(serializeJSON(theStruct))#");
			assertTrue(structKeyExists(theStruct['messages'],"clientFieldName"),"Validation JSON does not contain messages for property 'clientFieldName'");
		</cfscript>  
	</cffunction>
	
	<cffunction name="getValidationRulesStructShouldAllowForAnObjectToBePassedInAndUsedInAnExpressionTypeParameter" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			parameter = {name="list",value="getList()",type="expression"};
			parameters = {list=parameter};
			validation = {clientFieldName="clientFieldName",condition=structNew(),formName="formName",parameters=parameters,propertyDesc="propertyDesc",propertyName="propertyName",valType="inList"};
			validations = [validation];
			theObject = mock();
			theObject.evaluateExpression("getList()").returns("1,2");
			theStruct = ClientValidator.getValidationRulesStruct(validations=validations,formName="testFormName",jsLib="jQuery",theObject=theObject);
			
			// Test JSON format as expected based on the inlist testcase
			assertTrue(isStruct(theStruct),"Did not return valid JSON #htmlEditFormat(serializeJSON(theStruct))#");
			assertTrue(structKeyExists(theStruct,"rules"),"Validation JSON does not contain rules struct");
			assertTrue(structKeyExists(theStruct,"messages"),"Validation JSON does not contain messages struct");
			assertTrue(structKeyExists(theStruct.rules,"clientFieldName"),"Validation JSON does not contain rules for property 'clientFieldName' - #htmlEditFormat(serializeJSON(theStruct))#");
			assertTrue(structKeyExists(theStruct.messages,"clientFieldName"),"Validation JSON does not contain messages for property 'clientFieldName'");
			assertTrue(structKeyExists(theStruct.rules.clientFieldName,"inlist"),"Validation JSON does not contain inlist rule for clientFieldName.");
			assertTrue(structKeyExists(theStruct.messages.clientFieldName,"inlist"),"Validation JSON does not contain inlist message for clientFieldName");
			
			// Test actual Rule and Message contents
			assertEquals("{list={1,2}}",theStruct.rules.clientFieldName.inlist);
			assertEquals("The PropertyDesc was not found in the list: 1,2.",theStruct.messages.clientFieldName.inlist);
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldEnforceRuleWhenProcessOnIsClient" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			validations[1].processOn = "client";
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery");
			assertTrue(script contains "fm['clientFieldName'] = $("":input[name='clientFieldName']"",$form_testFormName);");
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateShouldNotEnforceRuleWhenProcessOnIsServer" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			validations[1].processOn = "server";
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery");
			assertFalse(script contains "fm['clientFieldName'] = $("":input[name='clientFieldName']"",$form_testFormName);");
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldEnforceRuleWhenProcessOnIsBoth" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			validations[1].processOn = "both";
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery");
			assertTrue(script contains "fm['clientFieldName'] = $("":input[name='clientFieldName']"",$form_testFormName);");
		</cfscript>  
	</cffunction>

	<cffunction name="validateShouldEnforceRuleWhenProcessOnIsNotSpecified" access="public" returntype="void">
		<cfscript>
			ClientValidator = validateThis.getBean("ClientValidator");
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery");
			assertTrue(script contains "fm['clientFieldName'] = $("":input[name='clientFieldName']"",$form_testFormName);");
		</cfscript>  
	</cffunction>

</cfcomponent>

