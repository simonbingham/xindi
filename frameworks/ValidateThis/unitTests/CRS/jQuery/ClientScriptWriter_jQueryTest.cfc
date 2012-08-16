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
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			validation = validationFactory.getBean("Validation");
			locale = "en_US";
			createValStruct();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="createValStruct" access="private" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			valStruct.formName = "frmMain"; 
		</cfscript>  
	</cffunction>
	
	<cffunction name="generateScriptHeaderShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptHeader("formName");
			assertTrue(Trim(Script) CONTAINS "jQuery(function($){");
			assertTrue(Trim(Script) CONTAINS "$form_formName = $(""##formName"");");
			assertTrue(Trim(Script) CONTAINS "$form_formName.validate({ignore:'.ignore'})");
		</cfscript>  
	</cffunction>

	<cffunction name="generateScriptHeaderShouldReturnSafeJSForUnsafeFormName" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptHeader("form-Name2");
			assertTrue(Trim(Script) CONTAINS "jQuery(function($){");
			assertTrue(Trim(Script) CONTAINS "$form_formName2 = $(""##form-Name2"");");
			assertTrue(Trim(Script) CONTAINS "$form_formName2.validate({ignore:'.ignore'})");
		</cfscript>  
	</cffunction>

	<cffunction name="generateScriptFooterShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptFooter();
			assertEquals(Trim(Script),"});/*]]>*/</script>");
		</cfscript>  
	</cffunction>

	<!--- Removing all of these CRS-specific tests as they are way too fragile.
			The CRS's are being tested via the Selenium tests
			
	<cffunction name="BooleanValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "boolean";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{boolean: true,messages:{boolean:'the first name must be a valid boolean value.'}});}",Script);
		</cfscript>  
	</cffunction>

	<cffunction name="CustomValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "custom";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { }",script);
			valStruct.Parameters.remoteURL = {value="aURL",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"",{""remote"":""aURL"",messages:{""remote"":""the first name custom validation failed.""}});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="CustomValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "custom";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { }",script);
			valStruct.Parameters.remoteURL = {value="aURL",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { $form_frmMain2.find("":input[name='firstname']"").rules(""add"",{""remote"":""aURL"",messages:{""remote"":""the first name custom validation failed.""}});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "date";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{date: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "date";
			validation.load(valStruct);

			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { $form_frmMain2.find("":input[name='firstname']"").rules('add',{date: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateRangeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "daterange";
			valStruct.Parameters.from = {value="2010-01-01",type="value"}; 
			valStruct.Parameters.until = {value="2010-12-31",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", {");
			assertEquals(true,script contains "daterange : {""from"":""2010-01-01"",""until"":""2010-12-31""},");
			assertEquals(true,script contains "messages: {""daterange"": ""the first name must contain a date between 2010-01-01 and 2010-12-31.""}");
		</cfscript>  
	</cffunction>

	<cffunction name="DoesNotContainOtherPropertiesValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "DoesNotContainOtherProperties";
			valStruct.Parameters.propertyNames = {value="a,b",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", {");
			assertEquals(true,script contains "doesnotcontainotherproperties : [""a"",""b""],");
			assertEquals(true,script contains "messages: {""doesnotcontainotherproperties"": ""The First Name must not contain the values of properties named: a,b.""}");
		</cfscript>  
	</cffunction>

	<cffunction name="EmailValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "email";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{email: true});}",Script);
		</cfscript>  
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = {value=ComparePropertyName,type="value"};
			valStruct.Parameters.ComparePropertyDesc = {value=ComparePropertyDesc,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertTrue(Script contains "$form_frmMain.find("":input[name='FirstName']"").rules(""add"",{equalto:"":input[name='LastName']"",messages:{equalto:'The First Name must be the same as the Last Name.'}});");
		</cfscript>
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = {value=ComparePropertyName,type="value"};
			valStruct.Parameters.ComparePropertyDesc = {value=ComparePropertyDesc,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertTrue(Script contains "$form_frmMain2.find("":input[name='FirstName']"").rules(""add"",{equalto:"":input[name='LastName']"",messages:{equalto:'The First Name must be the same as the Last Name.'}});", Script);
		</cfscript>
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScriptWithOverriddenPrefix" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = {value=ComparePropertyName,type="value"};
			valStruct.Parameters.ComparePropertyDesc = {value=ComparePropertyDesc,type="value"};
			ValidateThisConfig.defaultFailureMessagePrefix = "";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertTrue(Script contains "$form_frmMain2.find("":input[name='FirstName']"").rules(""add"",{equalto:"":input[name='LastName']"",messages:{equalto:'First Name must be the same as Last Name.'}});", script );
		</cfscript>
	</cffunction>

	<cffunction name="FalseValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "false";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{false: true});}",Script);
		</cfscript>  
	</cffunction>

	<cffunction name="FutureDateWithAfterValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "futuredate";
			valStruct.Parameters.after = {value="2010-01-01",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { futuredate : {""after"":""2010-01-01""}, messages: {""futuredate"": ""the first name must be a date in the future. the date entered must come after 2010-01-01.""} }); ");
		</cfscript>  
	</cffunction>

	<cffunction name="FutureDateWithoutAfterValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "futuredate";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { futuredate : true, messages: {""futuredate"": ""the first name must be a date in the future.""} }); ");
		</cfscript>  
	</cffunction>

	<cffunction name="InListValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "inlist";
			valStruct.Parameters.list = {value="a,b",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", {");
			assertEquals(true,script contains "inlist : {""list"":""a,b""},");
			assertEquals(true,script contains "messages: {""inlist"": ""the first name was not found in list: a,b""}");
		</cfscript>  
	</cffunction>

	<cffunction name="IntegerValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "integer";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{digits: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MaxValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct.ValType = "max";
			valStruct.Parameters.max = {value=theVal,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{max: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MaxLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct.ValType = "maxlength";
			valStruct.Parameters.maxlength = {value=theLength,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{maxlength: 5});}",script);
			
		</cfscript>  
	</cffunction>

	<cffunction name="MinValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct.ValType = "min";
			valStruct.Parameters.min = {value=theVal,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{min: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MinLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct.ValType = "minlength";
			valStruct.Parameters.minlength = {value=theLength,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{minlength: 5});}",script);
			
		</cfscript>  
	</cffunction>

	<cffunction name="NoHTMLValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "noHTML";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "nohtml : true,");
			assertEquals(true,script contains "nohtml: ""the first name cannot contain html tags.""");
		</cfscript>  
	</cffunction>

	<cffunction name="NotInListValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "notinlist";
			valStruct.Parameters.list = {value="a,b",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", {");
			assertEquals(true,script contains "inlist : {""list"":""a,b""},");
			assertEquals(true,script contains "messages: {""notinlist"": ""the first name was found in list: a,b""}");
		</cfscript>  
	</cffunction>

	<cffunction name="NumericValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "numeric";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{number: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="PastDateWithBeforeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "pastdate";
			valStruct.Parameters.before = {value="2010-01-01",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { pastdate : {""before"":""2010-01-01""},messages:{pastdate:'the first name must be a date in the past. the date entered must come before 2010-01-01.'} }); ");
		</cfscript>  
	</cffunction>

	<cffunction name="PastDateWithoutBeforeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "pastdate";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { pastdate : true,messages:{pastdate:'the first name must be a date in the past.'} }); ");
		</cfscript>  
	</cffunction>

	<cffunction name="PatternsValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "patterns";
			valStruct.Parameters.a = {value="1",type="value"}; 
			valStruct.Parameters.b = {value="2",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals(true,script contains "if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", {");
			assertEquals(true,script contains "patterns : {""a"":1,""b"":2},");
			assertEquals(true,script contains "messages: {""patterns"": ""did not match the patterns for the first name""}");
		</cfscript>  
	</cffunction>

	<cffunction name="RangeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			min = 5;
			max = 10;
			valStruct.ValType = "range";
			valStruct.Parameters.min = {value=min,type="value"};
			valStruct.Parameters.max = {value=max,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{range: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RangeLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			minLength = 5;
			maxLength = 10;
			valStruct.ValType = "rangelength";
			valStruct.Parameters.minLength = {value=minLength,type="value"};
			valStruct.Parameters.maxlength = {value=maxlength,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{rangelength: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="CollectionSizeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			min = 5;
			max = 10;
			valStruct.ValType = "CollectionSize";
			valStruct.Parameters.min = {value=min,type="value"};
			valStruct.Parameters.max= {value=max,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{CollectionSize: [5,10]});}",script);
		</cfscript>  
	</cffunction>
	
	<cffunction name="RegexValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "regex";
			valStruct.Parameters.Regex = {value="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertTrue(Script eq "if ($form_frmMain.find("":input[name='FirstName']"").length) { $form_frmMain.find("":input[name='FirstName']"").rules(""add"",{regex:/^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$/,messages:{regex:""The First Name does not match the specified pattern.""}});}");
		</cfscript>  
	</cffunction>
	
	<cffunction name="RegexValidationWithOverriddenPrefixGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "regex";
			valStruct.Parameters.Regex = {value="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$",type="value"};
			ValidateThisConfig.defaultFailureMessagePrefix = "";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
            assertTrue(Script eq "if ($form_frmMain.find("":input[name='FirstName']"").length) { $form_frmMain.find("":input[name='FirstName']"").rules(""add"",{regex:/^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$/,messages:{regex:""First Name does not match the specified pattern.""}});}");		</cfscript>  
	</cffunction>
	
	--->
	
	<cffunction name="SimpleRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain",locale);
			
			assertTrue(script contains "fm['firstname'].rules(""add"",{required:true,messages:{required:""the first name is required.""}});");
			
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain",locale);
			
			assertTrue(script contains "fm['firstname'].rules(""add"",{required:function(el){return $("":input[name='lastname']"").getvalue().length > 0;},messages:{required:""the first name is required if you specify a value for the lastname.""}});");

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentPropertyRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2",locale);
			
			assertTrue(script contains "fm['firstname'].rules(""add"",{required:function(el){return $("":input[name='lastname']"").getvalue().length > 0;},messages:{required:""the first name is required if you specify a value for the lastname.""}});");

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentValueRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentPropertyValue = {value="Silverberg",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain",locale);
			
			assertTrue(script contains "fm['firstname'].rules(""add"",{required:function(el){return $("":input[name='lastname']"").getvalue() == 'silverberg';},messages:{required:""the first name is required based on what you entered for the lastname.""}});");

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentValueRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentPropertyValue = {value="Silverberg",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2",locale);

			assertTrue(script contains "fm['firstname'].rules(""add"",{required:function(el){return $("":input[name='lastname']"").getvalue() == 'silverberg';},messages:{required:""the first name is required based on what you entered for the lastname.""}});");

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentFieldRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentFieldName = {value="User[LastName]",type="value"};
			valStruct.Parameters.DependentPropertyDesc = {value="lastname",type="value"};
			
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain",locale);
			assertTrue(script contains "fm['FirstName'].rules(""add"",{required:function(el){return $("":input[name='User[LastName]']"").getvalue().length > 0;},messages:{required:""the First Name is required if you specify a value for the lastname.""}});");
			
		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentFieldRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentFieldName = {value="User[LastName]",type="value"};
			valStruct.Parameters.DependentPropertyDesc = {value="lastname",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2",locale);
			
			assertTrue(script contains "fm['FirstName'].rules(""add"",{required:function(el){return $("":input[name='User[LastName]']"").getvalue().length > 0;},messages:{required:""the First Name is required if you specify a value for the lastname.""}});");
			
		</cfscript>  
	</cffunction>
	
</cfcomponent>