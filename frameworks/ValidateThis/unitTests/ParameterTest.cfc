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
<cfcomponent extends="validatethis.unitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			parameter = createObject("component","ValidateThis.core.Parameter").init();
			VTConfig = {definitionPath="/UnitTests/Fixture"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			validation = createValidation();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="ParameterShouldLoadFromStruct" access="public" returntype="void">
		<cfscript>
			paramStruct = {value="1",type="value"};
			parameter.load(paramStruct);
			assertEquals(paramStruct.value,parameter.getValue());
		</cfscript>
	</cffunction>

	<cffunction name="ParameterWithValueTypeShouldReturnCorrectValue" access="public" returntype="void">
		<cfscript>
			paramStruct = {value="1",type="value"};
			parameter.load(paramStruct);
			assertEquals(paramStruct.value,parameter.getValue());
			paramStruct = {value="1*10",type="value"};
			parameter.load(paramStruct);
			assertEquals("1*10",parameter.getValue());
		</cfscript>
	</cffunction>

	<cffunction name="ParameterWithExpressionTypeShouldReturnCorrectValue" access="public" returntype="void">
		<cfscript>
			paramStruct = {value="1*10",type="expression"};
			parameter.load(paramStruct);
			assertEquals(10,parameter.getValue());
		</cfscript>
	</cffunction>

	<cffunction name="ParameterWithExpressionTypeAndObjectShouldReturnCorrectValueFromObjectContext" access="public" returntype="void">
		<cfscript>
			validation.setup(ValidateThis,obj);
			paramStruct = {value="getMetadata(this).name",type="expression"};
			parameter.load(paramStruct);
			assertEquals(true,parameter.getValue() contains "aplaincfc_fixture");
		</cfscript>
	</cffunction>

	<cffunction name="ParameterWithPropertyTypeShouldReturnCorrectValue" access="public" returntype="void">
		<cfscript>
			validation.setup(ValidateThis,obj);
			paramStruct = {value="FirstName",type="property"};
			parameter.load(paramStruct);
			assertEquals("Bob",parameter.getValue());
		</cfscript>
	</cffunction>

	<cffunction name="createValidation" access="private" returntype="any">
		<cfscript>
			obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			injectMethod(obj, this, "evaluateExpression", "evaluateExpression");
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			validation.load(valStruct);
			return validation;
		</cfscript>  
	</cffunction>
	
	<cffunction name="evaluateExpression" access="Public" returntype="any" output="false" hint="I dynamically evaluate an expression and return the result.">
		<cfargument name="expression" type="any" required="false" default="1" />
		
		<cfreturn Evaluate(arguments.expression)>

	</cffunction>


	<!---

	<cffunction name="getObjectValueCFCWithPropertyNameArgumentShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getLastName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Silverberg",Validation.getObjectValue("LastName"));
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueCFCWithAbstractGetterShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.CFCWithAbstractGetter_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getProperty('FirstName')");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueMissingPropertyShouldFail" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.validation.propertyNotFound">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "Blah";
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueWheelsShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","models.FakeWheelsObject_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("$propertyvalue('WheelsName')");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "WheelsName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueGroovyShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","groovy.lang.FakeGroovyObject_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getGroovyName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "GroovyName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getIsRequiredShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "email";
			valStruct.PropertyName = "FirstName";
			valStruct.isRequired = true;
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals(true,Validation.getIsRequired());
		</cfscript>  
	</cffunction>

	<cffunction name="getIsRequiredShouldReturnFalseIfPropertyIsNotRequired" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "email";
			valStruct.PropertyName = "FirstName";
			valStruct.isRequired = false;
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.setup(obj);
			Validation.load(valStruct);
			assertEquals(false,Validation.getIsRequired());
		</cfscript>  
	</cffunction>

	<cffunction name="getParametersShouldReturnStructWithKeyPerParameterContainingValue" access="public" returntype="void">
		<cfscript>
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameters().Param1);
			assertEquals(20,Validation.getParameters().Param2);
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterShouldReturnRequestedParameter" access="public" returntype="void">
		<cfscript>
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={value=1,type="value"},Param2={value=2,type="value"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameter("Param1").value);
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterShouldThrowWithUndefinedParameter" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.validation.parameterDoesNotExist">
		<cfscript>
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={value=1,type="value"},Param2={value=2,type="value"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameter("Param3").Param1);
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterValueShouldReturnRequestedParameterValueWithTypeValue" access="public" returntype="void">
		<cfscript>
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="value",value=2}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameterValue("Param1"));
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterValueShouldReturnRequestedParameterValueWithTypeExpression" access="public" returntype="void">
		<cfscript>
			var ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(ObjectChecker);
			Validation.load(valStruct);
			assertEquals(20,Validation.getParameterValue("Param2"));
		</cfscript>  
	</cffunction>
	--->

</cfcomponent>

