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
			createValStruct();			
			
			// Script Results
			DefaultScript = "";
			ScriptWithFailureMessage = "";
			ScriptWithParams = "";
			ScriptWithProblematicFormName = "";
			ScriptWithProblematicFieldName = "";
			ScriptWithOverriddenPrefix = "";
			
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	
	</cffunction>

	<cffunction name="createValStruct" access="private" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = replace(getMetadata(this).name,"Test","","all");
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			valStruct.formName = "frmMain"; 
		</cfscript>  
	</cffunction>
	
	<cffunction name="GeneratesCorrectDefaultScript" access="public" returntype="void">
		<cfscript>
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { }",script);
			valStruct.Parameters.remoteURL = {value="aURL",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"",{""remote"":""aURL"",messages:{""remote"":""the first name custom validation failed.""}});}",script);
		</cfscript>  
	</cffunction>
	
	<cffunction name="GeneratesCorrectScriptWithFailureMessage" access="public" returntype="void">
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
	
	<cffunction name="GeneratesCorrectScriptWithParams" access="public" returntype="void">
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
	
	<cffunction name="GeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
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
	
	<cffunction name="GeneratesCorrectScriptWithProblematicFieldName" access="public" returntype="void">
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

	<cffunction name="GeneratesCorrectScriptWithOverriddenPrefix" access="public" returntype="void">
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

</cfcomponent>