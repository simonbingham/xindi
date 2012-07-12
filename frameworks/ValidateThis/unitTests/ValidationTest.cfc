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
	
	<cfset theObject = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			parameter = createObject("component","ValidateThis.core.Parameter").init();
			VTConfig = {definitionPath="/UnitTests/Fixture"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="ValidationShouldLoadFromStruct" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.FailureMessage = "A custom failure message.";
			valStruct.PropertyName = "FirstName";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.Param1 = {type="value",value="1"};
			valStruct.ObjectType = "user";
			theValue = "Bob";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(valStruct.ValType,Validation.getValType());
			assertEquals(valStruct.FailureMessage,Validation.getFailureMessage());
			assertEquals(valStruct.PropertyName,Validation.getPropertyName());
			assertEquals(valStruct.PropertyDesc,Validation.getPropertyDesc());
			expected = {Param1=1};
			assertEquals(expected,Validation.getParameters());
			assertTrue(IsObject(Validation.getTheObject()));
			assertEquals(theValue,Validation.getObjectValue());
			assertTrue(Validation.getIsSuccess());
			assertEquals("user",Validation.getObjectType());
		</cfscript>  
	</cffunction>

	<cffunction name="validationShouldContainVTFacade" access="public" returntype="void">
		<cfscript>
			VTConfig = {definitionPath="/UnitTests/Fixture"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			validation = ValidateThis.getBean("TransientFactory").newValidation();
			vtFacade = validation.getValidateThis();
			assertEquals(true,isObject(vtFacade));
			assertEquals("validatethis.validatethis",getMetadata(vtFacade).name);
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueCFCNoArgumentShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueCFCWithOnMissingMethodShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.CFCWithOnMM_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueCFCWithPropertyNameArgumentShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getLastName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals("Silverberg",Validation.getObjectValue("LastName"));
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueCFCWithAbstractGetterShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.CFCWithAbstractGetter_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getProperty('FirstName')");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueMissingPropertyShouldFail" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.validation.propertyNotFound">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "Blah";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueWheelsShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","models.FakeWheelsObject_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("$propertyvalue('WheelsName')");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "WheelsName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectValueGroovyShouldWork" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","groovy.lang.FakeGroovyObject_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getGroovyName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "GroovyName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals("Bob",Validation.getObjectValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getIsRequiredShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "email";
			valStruct.PropertyName = "FirstName";
			valStruct.isRequired = true;
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(true,Validation.getIsRequired());
		</cfscript>  
	</cffunction>

	<cffunction name="getIsRequiredShouldReturnFalseIfPropertyIsNotRequired" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "email";
			valStruct.PropertyName = "FirstName";
			valStruct.isRequired = false;
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(false,Validation.getIsRequired());
		</cfscript>  
	</cffunction>

	<cffunction name="getParametersShouldReturnStructWithKeyPerParameterContainingValue" access="public" returntype="void">
		<cfscript>
			obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			injectMethod(obj, this, "evaluateExpression", "evaluateExpression");
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameters().Param1);
			assertEquals(20,Validation.getParameters().Param2);
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterShouldReturnRequestedParameter" access="public" returntype="void">
		<cfscript>
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={value=1,type="value"},Param2={value=2,type="value"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameter("Param1").getValue());
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterShouldThrowWithUndefinedParameter" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.validation.parameterDoesNotExist">
		<cfscript>
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={value=1,type="value"},Param2={value=2,type="value"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameter("Param3").Param1);
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterValueShouldReturnRequestedParameterValue" access="public" returntype="void">
		<cfscript>
			var objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="value",value=2}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.load(valStruct);
			assertEquals(1,Validation.getParameterValue("Param1"));
		</cfscript>  
	</cffunction>

	<cffunction name="getParameterValueShouldReturnRequestedParameterValueWithTypeExpression" access="public" returntype="void">
		<cfscript>
			obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			injectMethod(obj, this, "evaluateExpression", "evaluateExpression");
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(20,Validation.getParameterValue("Param2"));
		</cfscript>  
	</cffunction>

	<cffunction name="addParameterAddsANewValueParameter" access="public" returntype="void">
		<cfscript>
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,ValidateThis.createWrapper(""));
			Validation.load(valStruct);
			validation.addParameter(name="Param3",value="3*3");
			parameters = validation.getParameters();
			assertEquals(3,structCount(parameters));
			assertEquals("3*3",parameters.Param3);
		</cfscript>  
	</cffunction>

	<cffunction name="addParameterAddsANewExpressionParameter" access="public" returntype="void">
		<cfscript>
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,ValidateThis.createWrapper(""));
			Validation.load(valStruct);
			validation.addParameter(name="Param3",value="3*3",type="Expression");
			parameters = validation.getParameters();
			assertEquals(3,structCount(parameters));
			assertEquals(9,parameters.Param3);
		</cfscript>  
	</cffunction>

	<cffunction name="addParameterReplacesAnExistingValueParameter" access="public" returntype="void">
		<cfscript>
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,ValidateThis.createWrapper(""));
			Validation.load(valStruct);
			validation.addParameter(name="Param1",value="3*3");
			parameters = validation.getParameters();
			assertEquals(2,structCount(parameters));
			assertEquals("3*3",parameters.Param1);
		</cfscript>  
	</cffunction>

	<cffunction name="addParameterReplacesAnExistingExpressionParameter" access="public" returntype="void">
		<cfscript>
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.Parameters = {Param1={type="value",value=1},Param2={type="expression",value="2*10"}};
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,ValidateThis.createWrapper(""));
			Validation.load(valStruct);
			validation.addParameter(name="Param2",value="3*3",type="Expression");
			parameters = validation.getParameters();
			assertEquals(2,structCount(parameters));
			assertEquals(9,parameters.Param2);
		</cfscript>  
	</cffunction>

	<cffunction name="getObjectTypeReturnsLoadedObjectType" access="public" returntype="void">
		<cfscript>
			objectChecker = mock();
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			valStruct.objectType = "user";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.load(valStruct);
			assertEquals("user",validation.getObjectType());
		</cfscript>  
	</cffunction>

	<cffunction name="propertyHasValueShouldReturnTrueIfPropertyPopulated" access="public" returntype="void">
		<cfscript>
			var obj = mock();
			var objectChecker = mock();
			obj.getFirstName().returns("something");
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(true,Validation.propertyHasValue());
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyHasValueShouldReturnFalseIfPropertyNotPopulated" access="public" returntype="void">
		<cfscript>
			var obj = mock();
			var objectChecker = mock();
			obj.getFirstName().returns("");
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(false,Validation.propertyHasValue());
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyExistsShouldReturnTrueIfPropertyExists" access="public" returntype="void">
		<cfscript>
			var obj = mock();
			var objectChecker = mock();
			obj.getFirstName().returns("something");
			objectChecker.findGetter("{*}").returns("getFirstName()");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(true,Validation.propertyExists());
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyExistsShouldReturnFalseIfPropertyDoesNotExist" access="public" returntype="void">
		<cfscript>
			var obj = mock();
			var objectChecker = mock();
			obj.getFirstName().returns("");
			objectChecker.findGetter("{*}").returns("");
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.PropertyName = "FirstName";
			Validation = CreateObject("component","ValidateThis.core.validation").init(objectChecker,parameter);
			Validation.setup(ValidateThis,obj);
			Validation.load(valStruct);
			assertEquals(false,Validation.propertyExists());
		</cfscript>  
	</cffunction>
	
	<cffunction name="evaluateExpression" access="Public" returntype="any" output="false" hint="I dynamically evaluate an expression and return the result.">
		<cfargument name="expression" type="any" required="false" default="1" />
		
		<cfreturn Evaluate(arguments.expression)>

	</cffunction>

</cfcomponent>

