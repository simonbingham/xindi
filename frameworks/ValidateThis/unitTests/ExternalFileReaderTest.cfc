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
	
	<cfset externalFileReader = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			className = "user";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<!--- need to address extra and override file readers
	<cffunction name="ExtraFileReadersShouldLoadOnInit" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraFileReaderComponentPaths="validatethis.unitTests.Fixture.FileReaders";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
			makePublic(externalFileReader,"getFileReaders");
			FRs = externalFileReader.getFileReaders();
			assertEquals(true,structKeyExists(FRs,"XML"));
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "FileReader_XML");
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "ValidateThis");
			assertEquals(true,structKeyExists(FRs,"Extra"));
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "FileReader_Extra");
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "Fixture");
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideFileReadersShouldLoadOnInit" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraFileReaderComponentPaths="validatethis.unitTests.Fixture.OverrideFileReaders";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
			makePublic(externalFileReader,"getFileReaders");
			FRs = externalFileReader.getFileReaders();
			assertEquals(true,structKeyExists(FRs,"XML"));
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "FileReader_XML");
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "Fixture");
			assertEquals(true,structKeyExists(FRs,"Extra"));
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "FileReader_Extra");
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "Fixture");
		</cfscript>  
	</cffunction>
	--->

	<cffunction name="loadRulesFromExternalFileReturnsCorrectPropertyDescsForJSON" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/json";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,defPath).PropertyDescs;
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsRulesInCorrectOrderInContextsWhenUsingDefaultContexts" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/json";
			validations = externalFileReader.loadRulesFromExternalFile(className,defPath).validations;
			val = validations.contexts.Profile[1];
			assertEquals("UserName",val.propertyName);
			assertEquals("required",val.valType);
			val = validations.contexts.Profile[2];
			assertEquals("UserName",val.propertyName);
			assertEquals("email",val.valType);
			val = validations.contexts.Profile[3];
			assertEquals("Nickname",val.propertyName);
			assertEquals("custom",val.valType);
			val = validations.contexts.Profile[9];
			assertEquals("Salutation",val.propertyName);
			assertEquals("required",val.valType);
			val = validations.contexts.Register[1];
			assertEquals("UserName",val.propertyName);
			assertEquals("required",val.valType);
			val = validations.contexts.Register[2];
			assertEquals("UserName",val.propertyName);
			assertEquals("email",val.valType);
			val = validations.contexts.Register[3];
			assertEquals("Nickname",val.propertyName);
			assertEquals("custom",val.valType);
			val = validations.contexts.Register[9];
			assertEquals("Salutation",val.propertyName);
			assertEquals("regex",val.valType);
			val = validations.contexts.___Default[1];
			assertEquals("UserName",val.propertyName);
			assertEquals("required",val.valType);
			val = validations.contexts.___Default[2];
			assertEquals("UserName",val.propertyName);
			assertEquals("email",val.valType);
			val = validations.contexts.___Default[3];
			assertEquals("Nickname",val.propertyName);
			assertEquals("custom",val.valType);
			val = validations.contexts.___Default[9];
			assertEquals("Salutation",val.propertyName);
			assertEquals("regex",val.valType);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectValidationsForJSON" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/json";
			Validations = externalFileReader.loadRulesFromExternalFile(className,defPath).Validations;
			validationsAreCorrect(true);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileThrowsWithInvalidJSONInFile" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.fileReaders.Filereader_JSON.invalidJSON">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/json";
			externalFileReader.loadRulesFromExternalFile("invalid",defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructWithMappedPathLookingForXMLExtension" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructWithPhysicalPathLookingForXMLExtension" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructWithMappedPathLookingForXMLCFMExtension" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile("user_cfm",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructWithPhysicalPathLookingForXMLCFMExtension" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile("user_cfm",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructLookingForXMLExtensionInFolder" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile("user.user_folder",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructLookingForXMLCFMExtensionInFolder" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile("user_cfm.user_cfm_folder",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructLookingForFileInSecondFolderInList" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture,/validatethis/unitTests/Fixture/aSecondFolderToTest";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile("user.user_secondfolder",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileThrowsWithBadMappedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture/Model_Doesnt_Exist/";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileThrowsWithBadPhysicalPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture" & "Doesnt_Exist/";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructWithMappedPathWithoutTrailingSlash" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectStructWithMappedPathWithTrailingSlash" access="public" returntype="void">
		<cfscript>
			defPath = "/validatethis/unitTests/Fixture/";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectPropertyDescs" access="public" returntype="void">
		<cfscript>
			className = "user";
			definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			PropertyDescs = externalFileReader.loadRulesFromExternalFile(className,definitionPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileReturnsCorrectValidations" access="public" returntype="void">
		<cfscript>
			className = "user";
			definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			Validations = externalFileReader.loadRulesFromExternalFile(className,definitionPath).Validations;
			validationsAreCorrect();
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileDoesNotThrowAnErrorOnInvalidXMLinDebugNoneMode" access="public" returntype="void">
		<cfscript>
			className = "user_invalidxml";
			definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			validations = externalFileReader.loadRulesFromExternalFile(className,definitionPath).Validations;
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalFileDoesNotThrowAnErrorOnInvalidXMLinDebugInfo" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			ValidateThisConfig.debuggingMode = "info";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
			className = "user_invalidxml";
			definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			validations = externalFileReader.loadRulesFromExternalFile(className,definitionPath).Validations;
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesFromExternalThrowsAnExceptionOnInvalidXMLinDebugStrict" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.fileReaders.Filereader_XML.invalidXML">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			ValidateThisConfig.debuggingMode = "strict";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
			className = "user_invalidxml";
			definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			validations = externalFileReader.loadRulesFromExternalFile(className,definitionPath).Validations;
		</cfscript>  
	</cffunction>

	<cffunction name="isPropertiesStructCorrect" access="private" returntype="void">
		<cfargument type="Any" name="PropertyDescs" required="true" />
		<cfscript>
			assertEquals(StructCount(arguments.PropertyDescs),10);
			assertEquals(arguments.PropertyDescs.AllowCommunication,"Allow Communication");
			assertEquals(arguments.PropertyDescs.CommunicationMethod,"Communication Method");
			assertEquals(arguments.PropertyDescs.FirstName,"First Name");
			assertEquals(arguments.PropertyDescs.HowMuch,"How much money would you like?");
			assertEquals(arguments.PropertyDescs.LastName,"Last Name");
			assertEquals(arguments.PropertyDescs.LikeOther,"What do you like?");
			assertEquals(arguments.PropertyDescs.UserGroup,"User Group");
			assertEquals(arguments.PropertyDescs.UserName,"Email Address");
			assertEquals(arguments.PropertyDescs.UserPass,"Password");
			assertEquals(arguments.PropertyDescs.VerifyPassword,"Verify Password");
		</cfscript>  
	</cffunction>

	<cffunction name="validationsAreCorrect" access="private" returntype="void">
		<cfargument name="json" required="false" default="false">
		<cfscript>
			assertEquals(StructCount(Validations),1);
			assertEquals(StructCount(Validations.Contexts),3);
			Rules = Validations.Contexts.Register;
			assertEquals(ArrayLen(Rules),13);
			Validation = Rules[1];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			Validation = Rules[2];
			assertEquals(Validation.ValType,"email");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			assertEquals(Validation.FailureMessage,"Hey, buddy, you call that an Email Address?");
			Validation = Rules[3];
			assertEquals(Validation.ValType,"custom");
			assertEquals(Validation.PropertyName,"Nickname");
			assertEquals(Validation.PropertyDesc,"Nickname");
			assertEquals(Validation.Parameters.MethodName.value,"CheckDupNickname");
			Validation = Rules[4];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			Validation = Rules[5];
			assertEquals(Validation.ValType,"rangelength");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			assertEquals(Validation.Parameters.MinLength.value,5);
			assertEquals(Validation.Parameters.MaxLength.value,10);
			Validation = Rules[6];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			Validation = Rules[7];
			assertEquals(Validation.ValType,"equalTo");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			assertEquals(Validation.Parameters.ComparePropertyName.value,"UserPass");
			assertEquals(Validation.Parameters.ComparePropertyDesc.value,"Password");
			Validation = Rules[8];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserGroup");
			assertEquals(Validation.PropertyDesc,"User Group");
			Validation = Rules[9];
			assertEquals(Validation.ValType,"regex");
			assertEquals(Validation.PropertyName,"Salutation");
			assertEquals(Validation.PropertyDesc,"Salutation");
			assertEquals(Validation.Parameters.Regex.value,"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$");
			assertEquals(Validation.FailureMessage,"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.");
			Validation = Rules[10];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LastName");
			assertEquals(Validation.PropertyDesc,"Last Name");
			assertEquals(Validation.Parameters.DependentPropertyName.value,"FirstName");
			assertEquals(Validation.Parameters.DependentPropertyDesc.value,"First Name");
			Validation = Rules[11];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LikeOther");
			assertEquals(Validation.PropertyDesc,"What do you like?");
			assertEquals(Validation.FailureMessage,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			if (arguments.json) {
				assertEquals(Validation.Condition.ClientTest,"$(&quot;[name='likecheese']&quot;).getvalue() == 0 &amp;&amp; $(&quot;[name='likechocolate']&quot;).getvalue() == 0;");
			} else {
				assertEquals(Validation.Condition.ClientTest,"$(""[name='LikeCheese']"").getValue() == 0 && $(""[name='LikeChocolate']"").getValue() == 0;");
			}
			assertEquals(Validation.Condition.ServerTest,"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0");
			Validation = Rules[12];
			assertEquals(Validation.ValType,"numeric");
			assertEquals(Validation.PropertyName,"HowMuch");
			assertEquals(Validation.PropertyDesc,"How much money would you like?");
			Validation = Rules[13];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"CommunicationMethod");
			assertEquals(Validation.PropertyDesc,"Communication Method");
			assertEquals(Validation.Parameters.DependentPropertyDesc.value,"Allow Communication");
			assertEquals(Validation.Parameters.DependentPropertyName.value,"AllowCommunication");
			assertEquals(Validation.Parameters.DependentPropertyValue.value,1);
			Rules = Validations.Contexts.Profile;
			assertEquals(ArrayLen(Rules),15);
			Validation = Rules[1];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			Validation = Rules[2];
			assertEquals(Validation.ValType,"email");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			assertEquals(Validation.FailureMessage,"Hey, buddy, you call that an Email Address?");
			Validation = Rules[3];
			assertEquals(Validation.ValType,"custom");
			assertEquals(Validation.PropertyName,"Nickname");
			assertEquals(Validation.PropertyDesc,"Nickname");
			assertEquals(Validation.Parameters.MethodName.value,"CheckDupNickname");
			Validation = Rules[4];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			Validation = Rules[5];
			assertEquals(Validation.ValType,"rangelength");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			assertEquals(Validation.Parameters.MinLength.value,5);
			assertEquals(Validation.Parameters.MaxLength.value,10);
			Validation = Rules[6];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			Validation = Rules[7];
			assertEquals(Validation.ValType,"equalTo");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			assertEquals(Validation.Parameters.ComparePropertyName.value,"UserPass");
			assertEquals(Validation.Parameters.ComparePropertyDesc.value,"Password");
			Validation = Rules[8];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserGroup");
			assertEquals(Validation.PropertyDesc,"User Group");
			Validation = Rules[9];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"Salutation");
			assertEquals(Validation.PropertyDesc,"Salutation");
			Validation = Rules[10];
			assertEquals(Validation.ValType,"regex");
			assertEquals(Validation.PropertyName,"Salutation");
			assertEquals(Validation.PropertyDesc,"Salutation");
			assertEquals(Validation.Parameters.Regex.value,"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$");
			assertEquals(Validation.FailureMessage,"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.");
			Validation = Rules[11];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"FirstName");
			assertEquals(Validation.PropertyDesc,"First Name");
			Validation = Rules[12];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LastName");
			assertEquals(Validation.PropertyDesc,"Last Name");
			Validation = Rules[13];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LikeOther");
			assertEquals(Validation.PropertyDesc,"What do you like?");
			assertEquals(Validation.FailureMessage,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			if (arguments.json) {
				assertEquals(Validation.Condition.ClientTest,"$(&quot;[name='likecheese']&quot;).getvalue() == 0 &amp;&amp; $(&quot;[name='likechocolate']&quot;).getvalue() == 0;");
			} else {
				assertEquals(Validation.Condition.ClientTest,"$(""[name='LikeCheese']"").getValue() == 0 && $(""[name='LikeChocolate']"").getValue() == 0;");
			}
			assertEquals(Validation.Condition.ServerTest,"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0");
			Validation = Rules[14];
			assertEquals(Validation.ValType,"numeric");
			assertEquals(Validation.PropertyName,"HowMuch");
			assertEquals(Validation.PropertyDesc,"How much money would you like?");
			Validation = Rules[15];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"CommunicationMethod");
			assertEquals(Validation.PropertyDesc,"Communication Method");
			assertEquals(Validation.Parameters.DependentPropertyDesc.value,"Allow Communication");
			assertEquals(Validation.Parameters.DependentPropertyName.value,"AllowCommunication");
			assertEquals(Validation.Parameters.DependentPropertyValue.value,1);
		</cfscript>  
	</cffunction>


</cfcomponent>

