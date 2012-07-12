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
			annotationTypeReader = CreateObject("component","ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_JSON").init("frmMain");
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="isThisFormatReturnsTrueForJSON" access="public" returntype="void">
		<cfscript>
			assertTrue(annotationTypeReader.isThisFormat('[{"key1":"value1"}]'));
		</cfscript>  
	</cffunction>

	<cffunction name="isThisFormatReturnsFalseForNonJSONString" access="public" returntype="void">
		<cfscript>
			assertFalse(annotationTypeReader.isThisFormat('abc'));
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesReturnsCorrectPropertyDescs" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.unitTests.Fixture.AnnotatedBOs.User");
			PropertyDescs = annotationTypeReader.getValidations("user",md).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="loadRulesReturnsCorrectValidations" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.unitTests.Fixture.AnnotatedBOs.User");
			Validations = annotationTypeReader.getValidations("user",md).Validations;
			assertEquals(StructCount(Validations),1);
			assertEquals(StructCount(Validations.Contexts),3);
			Rules = Validations.Contexts.Register;
			assertEquals(ArrayLen(Rules),13);
			for (i = 1; i LTE ArrayLen(Rules); i = i + 1) {
				Validation = Rules[i];
				if (Validation.ValType eq "required" and Validation.PropertyName eq "LastName") {
					assertEquals(Validation.PropertyDesc,"Last Name");
					assertEquals(Validation.Parameters.DependentPropertyName.value,"FirstName");
					assertEquals(Validation.Parameters.DependentPropertyDesc.value,"First Name");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "UserName") {
					assertEquals(Validation.PropertyDesc,"Email Address");
				}
				if (Validation.ValType eq "email" and Validation.PropertyName eq "UserName") {
					assertEquals(Validation.PropertyDesc,"Email Address");
					assertEquals(Validation.FailureMessage,"Hey, buddy, you call that an Email Address?");
				}
				if (Validation.ValType eq "custom" and Validation.PropertyName eq "Nickname") {
					assertEquals(Validation.PropertyDesc,"Nickname");
					assertEquals(Validation.Parameters.MethodName.value,"CheckDupNickname");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "UserPass") {
					assertEquals(Validation.PropertyDesc,"Password");
				}
				if (Validation.ValType eq "rangelength" and Validation.PropertyName eq "UserPass") {
					assertEquals(Validation.PropertyDesc,"Password");
					assertEquals(Validation.Parameters.MinLength.value,5);
					assertEquals(Validation.Parameters.MaxLength.value,10);
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "VerifyPassword") {
					assertEquals(Validation.PropertyDesc,"Verify Password");
				}
				if (Validation.ValType eq "equalTo" and Validation.PropertyName eq "VerifyPassword") {
					assertEquals(Validation.PropertyDesc,"Verify Password");
					assertEquals(Validation.Parameters.ComparePropertyName.value,"UserPass");
					assertEquals(Validation.Parameters.ComparePropertyDesc.value,"Password");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "UserGroup") {
					assertEquals(Validation.PropertyDesc,"User Group");
				}
				if (Validation.ValType eq "regex" and Validation.PropertyName eq "Salutation") {
					assertEquals(Validation.PropertyDesc,"Salutation");
					assertEquals(Validation.Parameters.Regex.value,"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$");
					assertEquals(Validation.FailureMessage,"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "LikeOther") {
					assertEquals(Validation.PropertyDesc,"What do you like?");
					assertEquals(Validation.FailureMessage,"If you don't like Cheese and you don't like Chocolate, you must like something!");
					assertEquals(Validation.Condition.ClientTest,"$(""[name='likecheese']"").getvalue() == 0 && $(""[name='likechocolate']"").getvalue() == 0;");
					assertEquals(Validation.Condition.ServerTest,"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0");
				}
				if (Validation.ValType eq "numeric" and Validation.PropertyName eq "HowMuch") {
					assertEquals(Validation.PropertyDesc,"How much money would you like?");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "CommunicationMethod") {
					assertEquals(Validation.PropertyDesc,"Communication Method");
					assertEquals(Validation.Parameters.DependentPropertyDesc.value,"Allow Communication");
					assertEquals(Validation.Parameters.DependentPropertyName.value,"AllowCommunication");
					assertEquals(Validation.Parameters.DependentPropertyValue.value,1);
				}
			}
			Rules = Validations.Contexts.Profile;
			assertEquals(ArrayLen(Rules),15);
			for (i = 1; i LTE ArrayLen(Rules); i = i + 1) {
				Validation = Rules[i];
				if (Validation.ValType eq "required" and Validation.PropertyName eq "Salutation") {
					assertEquals(Validation.PropertyDesc,"Salutation");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "FirstName") {
					assertEquals(Validation.PropertyDesc,"First Name");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "LastName") {
					assertEquals(Validation.PropertyDesc,"Last Name");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "UserName") {
					assertEquals(Validation.PropertyDesc,"Email Address");
				}
				if (Validation.ValType eq "email" and Validation.PropertyName eq "UserName") {
					assertEquals(Validation.PropertyDesc,"Email Address");
					assertEquals(Validation.FailureMessage,"Hey, buddy, you call that an Email Address?");
				}
				if (Validation.ValType eq "custom" and Validation.PropertyName eq "Nickname") {
					assertEquals(Validation.PropertyDesc,"Nickname");
					assertEquals(Validation.Parameters.MethodName.value,"CheckDupNickname");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "UserPass") {
					assertEquals(Validation.PropertyDesc,"Password");
				}
				if (Validation.ValType eq "rangelength" and Validation.PropertyName eq "UserPass") {
					assertEquals(Validation.PropertyDesc,"Password");
					assertEquals(Validation.Parameters.MinLength.value,5);
					assertEquals(Validation.Parameters.MaxLength.value,10);
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "VerifyPassword") {
					assertEquals(Validation.PropertyDesc,"Verify Password");
				}
				if (Validation.ValType eq "equalTo" and Validation.PropertyName eq "VerifyPassword") {
					assertEquals(Validation.PropertyDesc,"Verify Password");
					assertEquals(Validation.Parameters.ComparePropertyName.value,"UserPass");
					assertEquals(Validation.Parameters.ComparePropertyDesc.value,"Password");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "UserGroup") {
					assertEquals(Validation.PropertyDesc,"User Group");
				}
				if (Validation.ValType eq "regex" and Validation.PropertyName eq "Salutation") {
					assertEquals(Validation.PropertyDesc,"Salutation");
					assertEquals(Validation.Parameters.Regex.value,"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$");
					assertEquals(Validation.FailureMessage,"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "LikeOther") {
					assertEquals(Validation.PropertyDesc,"What do you like?");
					assertEquals(Validation.FailureMessage,"If you don't like Cheese and you don't like Chocolate, you must like something!");
					assertEquals(Validation.Condition.ClientTest,"$(""[name='likecheese']"").getvalue() == 0 && $(""[name='likechocolate']"").getvalue() == 0;");
					assertEquals(Validation.Condition.ServerTest,"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0");
				}
				if (Validation.ValType eq "numeric" and Validation.PropertyName eq "HowMuch") {
					assertEquals(Validation.PropertyDesc,"How much money would you like?");
				}
				if (Validation.ValType eq "required" and Validation.PropertyName eq "CommunicationMethod") {
					assertEquals(Validation.PropertyDesc,"Communication Method");
					assertEquals(Validation.Parameters.DependentPropertyDesc.value,"Allow Communication");
					assertEquals(Validation.Parameters.DependentPropertyName.value,"AllowCommunication");
					assertEquals(Validation.Parameters.DependentPropertyValue.value,1);
				}
			}
		</cfscript>  
	</cffunction>

	<cffunction name="isPropertiesStructCorrect" access="private" returntype="void">
		<cfargument type="Any" name="PropertyDescs" required="true" />
		<cfscript>
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

</cfcomponent>

