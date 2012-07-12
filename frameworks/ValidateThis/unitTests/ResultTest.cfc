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
	
	<cfset Result = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			MockTranslator = mock();
			MockTranslator.translate("{string}","{string}").returns("Translated Text");
			validatethisconfig = {
				TranslatorPath = "ValidateThis.core.BaseTranslator",
				LocaleLoaderPath = "ValidateThis.core.BaseLocaleLoader",
				BOValidatorPath = "ValidateThis.core.BOValidator",
				ResultPath = "ValidateThis.util.Result",
				DefaultJSLib = "jQuery",
				JSRoot = "js/",
				defaultFormName = "frmMain",
				definitionPath = "/model/",
				localeMap = "#StructNew()#",
				defaultLocale = "",
				abstractGetterMethod = "getValue",
				ExtraRuleValidatorComponentPaths = "",
				ExtraClientScriptWriterComponentPaths = "",
				extraFileReaderComponentPaths = "",
				externalFileTypes = "xml,json",
				injectResultIntoBO = "false",
				JSIncludes = "true",
				defaultFailureMessagePrefix = "The ",
				BOComponentPaths = "",
				extraAnnotationTypeReaderComponentPaths = ""
			};
			result = CreateObject("component","ValidateThis.util.Result").init(MockTranslator, validatethisconfig);
			//result.setTranslator(MockTranslator);
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="newResultShouldContainDefaultPropertyValues" access="public" returntype="void">
		<cfscript>
			assertEquals(result.getIsSuccess(),true);
			assertEquals(ArrayLen(result.getFailures()),0);
			assertEquals(result.getDummyValue(),"");
		</cfscript>  
	</cffunction>

	<cffunction name="missingPropertyHandlersShouldBeAbleToSetAndGetArbitraryProperties" access="public" returntype="void">
		<cfscript>
			DummyValue = "Dummy Value";
			result.setDummyValue(DummyValue);
			assertEquals(result.getDummyValue(),DummyValue);
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureWithValidStructShouldAddAFailure" access="public" returntype="void">
		<cfscript>
			failure = StructNew();
			failure.Code = 999;
			failure.Message = "abc";
			result.addFailure(failure);
			result.setIsSuccess(false);
			assertEquals(result.getIsSuccess(),false);
			failures = result.getFailures();
			assertEquals(ArrayLen(failures),1);
			assertEquals(failures[1].Code,999);
			assertEquals(failures[1].Message,"abc");
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureShouldSetSuccessToFalse" access="public" returntype="void">
		<cfscript>
			failure = StructNew();
			failure.Code = 999;
			failure.Message = "abc";
			result.addFailure(failure);
			assertEquals(result.getIsSuccess(),false);
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureShouldAcceptNewSpecificArgumentsAndAddAFailure" access="public" returntype="void">
		<cfscript>
			failure = StructNew();
			failure.propertyName = "propertyName";
			failure.clientFieldName = "clientFieldName";
			failure.type = "type";
			failure.message = "message";
			failure.theObject = "theObject";
			failure.objectType = "objectType";
			result.addFailure(argumentCollection=failure);
			failures = result.getFailures();
			assertEquals(ArrayLen(failures),1);
			assertEquals(failures[1].propertyName, failure.propertyName);
			assertEquals(failures[1].clientFieldName, failure.clientFieldName);
			assertEquals(failures[1].type, failure.type);
			assertEquals(failures[1].message, failure.message);
			assertEquals(failures[1].theObject, failure.theObject);
			assertEquals(failures[1].objectType, failure.objectType);
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureShouldAcceptAFailureStructAndNewSpecificArgumentsAndAddAFailure" access="public" returntype="void">
		<cfscript>
			failure1 = StructNew();
			failure1.propertyName = "propertyName";
			failure1.clientFieldName = "clientFieldName";
			failure1.type = "type";
			failure1.theObject = "theObject";
			failure1.objectType = "objectType";
			failure1.failure = structNew();
			failure1.failure.propertyName = "propertyName2";
			failure1.failure.message = "messageFromFailureStruct";
			result.addFailure(argumentCollection=failure1);
			failures = result.getFailures();
			assertEquals(ArrayLen(failures),1);
			assertEquals(failures[1].propertyName, failure1.failure.propertyName);
			assertEquals(failures[1].clientFieldName, failure1.clientFieldName);
			assertEquals(failures[1].type, failure1.type);
			assertEquals(failures[1].theObject, failure1.theObject);
			assertEquals(failures[1].objectType, failure1.objectType);
			assertEquals(failures[1].message, failure1.failure.message);
		</cfscript>  
	</cffunction>

	<cffunction name="addFailureShouldDefaultClientFieldnameToPropertyName" access="public" returntype="void">
		<cfscript>
			failure = StructNew();
			failure.propertyName = "propertyName";
			result.addFailure(propertyName=failure.propertyName);
			failures = result.getFailures();
			assertEquals(ArrayLen(failures),1);
			assertEquals(failures[1].propertyName, failure.propertyName);
			assertEquals(failures[1].clientFieldName, failure.propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresShouldReturnArrayWithFailures" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailures();
			assertEquals(3,arrayLen(failures));
			assertEquals("First Message",failures[1].Message);
			assertEquals("Second Message",failures[2].Message);
			assertEquals("Third Message",failures[3].Message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresForLocaleShouldReturnArrayWithTranslatedMessages" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailures("any Locale");
			assertEquals(3,arrayLen(failures));
			assertEquals("Translated Text",failures[1].Message);
			assertEquals("Translated Text",failures[2].Message);
			assertEquals("Translated Text",failures[3].Message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesShouldReturnArrayOfMessages" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessages();
			assertEquals(3,arrayLen(failures));
			assertEquals("First Message",failures[1]);
			assertEquals("Second Message",failures[2]);
			assertEquals("Third Message",failures[3]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresAsStringShouldReturnListOfMessagesWithABRDelimiter" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresAsString();
			assertEquals("First Message<br />Second Message<br />Third Message",failures);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresAsStringShouldReturnListOfMessagesWithCustomDelimiter" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresAsString("|");
			assertEquals("First Message|Second Message|Third Message",failures);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByFieldShouldReturnArraysOfFailuresPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresByField();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.fieldA[1].message);
			assertEquals("Second Message",failures.fieldA[2].message);
			assertEquals("Third Message",failures.fieldB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByFieldShouldWorkWithPassedLocale" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			expected = "translated text";
			failures = result.getFailuresByField(locale="en_US");
			assertEquals(2,structCount(failures));
			assertEquals(expected,failures.fieldA[1].message);
			assertEquals(expected,failures.fieldA[2].message);
			assertEquals(expected,failures.fieldB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByPropertyShouldReturnArraysOfFailuresPerPropertyName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresByProperty();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.propertyA[1].message);
			assertEquals("Second Message",failures.propertyA[2].message);
			assertEquals("Third Message",failures.propertyB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByPropertyShouldWorkWithPassedLocale" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			expected = "translated text";
			failures = result.getFailuresByProperty(locale="en_US");
			assertEquals(2,structCount(failures));
			assertEquals(expected,failures.propertyA[1].message);
			assertEquals(expected,failures.propertyA[2].message);
			assertEquals(expected,failures.propertyB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldShouldReturnArraysOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByField();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.fieldA[1]);
			assertEquals("Second Message",failures.fieldA[2]);
			assertEquals("Third Message",failures.fieldB[1]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByPropertyShouldReturnArraysOfMessagesPerPropertyName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByProperty();
			assertEquals(2,structCount(failures));
			assertEquals("First Message",failures.propertyA[1]);
			assertEquals("Second Message",failures.propertyA[2]);
			assertEquals("Third Message",failures.propertyB[1]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldWithDelimeterShouldReturnStringsOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByField(delimiter="<br />");
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.fieldA);
			assertEquals("Third Message",failures.fieldB);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByPropertyWithDelimeterShouldReturnStringsOfMessagesPerPropertyName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailureMessagesByProperty(delimiter="<br />");
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.propertyA);
			assertEquals("Third Message",failures.propertyB);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByFieldWithLimitOf1ShouldReturnLimitedArraysOfFailuresPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailuresByField(limit=1);
			assertEquals(2,structCount(failures));
			assertEquals(1,arrayLen(failures.fieldA));
			assertEquals(1,arrayLen(failures.fieldB));
			assertEquals("First Message",failures.fieldA[1].message);
			assertEquals("Third Message",failures.fieldB[1].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresByFieldWithLimitOf2ShouldReturnLimitedArraysOfFailuresPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailuresByField(limit=2);
			assertEquals(2,structCount(failures));
			assertEquals(2,arrayLen(failures.fieldA));
			assertEquals(2,arrayLen(failures.fieldB));
			assertEquals("First Message",failures.fieldA[1].message);
			assertEquals("Second Message",failures.fieldA[2].message);
			assertEquals("Third Message",failures.fieldB[1].message);
			assertEquals("Third Message",failures.fieldB[2].message);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldWithLimitOf2ShouldReturnLimitedArraysOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailureMessagesByField(limit=2);
			assertEquals(2,structCount(failures));
			assertEquals(2,arrayLen(failures.fieldA));
			assertEquals(2,arrayLen(failures.fieldB));
			assertEquals("First Message",failures.fieldA[1]);
			assertEquals("Second Message",failures.fieldA[2]);
			assertEquals("Third Message",failures.fieldB[1]);
			assertEquals("Third Message",failures.fieldB[2]);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailureMessagesByFieldWithLimitOf2AndDelimiterShouldReturnLimitedStringsOfMessagesPerClientFieldName" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			addMultipleFailures();
			failures = result.getFailureMessagesByField(limit=2,delimiter="<br />");
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.fieldA);
			assertEquals("Third Message<br />Third Message",failures.fieldB);
		</cfscript>  
	</cffunction>

	<cffunction name="getFailuresAsStructShouldReturnStructWithKeysPerFieldAndBRDelimiters" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresAsStruct();
			assertEquals(2,structCount(failures));
			assertEquals("First Message<br />Second Message",failures.fieldA);
			assertEquals("Third Message",failures.fieldB);
		</cfscript>  
	</cffunction>
	
	<cffunction name="addResultShouldAppendFailuresFromAPassedInResultObject" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			assertEquals(3,arrayLen(result.getFailures()));
			result2 = CreateObject("component","ValidateThis.util.Result").init(MockTranslator,validatethisconfig);
			addMultipleFailures(result2);
			result.addResult(result2);
			assertEquals(6,arrayLen(result.getFailures()));
		</cfscript>  
	</cffunction>
		
	<cffunction name="getRawFailuresShouldReturnArrayOfFailureStructs" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			rawfailures = result.getRawFailures();
			assertIsArray(rawfailures);
			assertEquals(3, ArrayLen(rawfailures));
			assertEquals("fieldA", rawfailures[1].clientfieldname);
			assertEquals("First Message", rawfailures[1].message);
			assertEquals("", rawfailures[1].objecttype);
			assertEquals("propertyA", rawfailures[1].propertyname);
			assertEquals("", rawfailures[1].theobject);
			assertEquals("", rawfailures[1].type);
		</cfscript>  
	</cffunction>
	
	<!--- test for reported bug http://groups.google.com/group/validatethis/browse_thread/thread/91ef8d6dc44847ff?hl=en --->
	<cffunction name="testbugFixForFailureStructAppendedToFailureStruct" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			rawfailures = result.getRawFailures();
			assertIsArray(rawfailures);
			assertEquals(3, ArrayLen(rawfailures));
			failure = rawfailures[1];
			assertFalse(StructKeyExists(failure, "failure"));
		</cfscript>  
	</cffunction>

	<!--- test for reported bug https://github.com/ValidateThis/ValidateThis/issues/24 --->
	<cffunction name="getFailuresAsValidationErrorCollectionShouldReturnAStructOfFailuresInTheExpectedFormat" access="public" returntype="void">
		<cfscript>
			addMultipleFailures();
			failures = result.getFailuresAsValidationErrorCollection();
			assertEquals(2, structCount(failures));
			assertEquals("First Message", failures.fieldA[1]);
			assertEquals("Second Message", failures.fieldA[2]);
			assertEquals("Third Message", failures.fieldB[1]);
		</cfscript>  
	</cffunction>

	<cffunction name="addResultShouldMakeReceivingResultAFailureIfTheOriginalResultWasAFailure" access="public" returntype="void">
		<cfscript>
			assertEquals(true,result.getIsSuccess());
			result2 = CreateObject("component","ValidateThis.util.Result").init(MockTranslator,validatethisconfig);
			addMultipleFailures(result2);
			assertEquals(false,result2.getIsSuccess());
			result.addResult(result2);
			assertEquals(false,result.getIsSuccess());
		</cfscript>  
	</cffunction>
		
	<cffunction name="addMultipleFailures" access="private" returntype="void">
		<cfargument name="toResult" required="false" default="#result#" >
		<cfscript>
			failure = StructNew();
			failure.Message = "First Message";
			failure.PropertyName = "propertyA";
			failure.ClientFieldName = "fieldA";
			arguments.toResult.addFailure(failure);
			failure = StructNew();
			failure.Message = "Second Message";
			failure.PropertyName = "propertyA";
			failure.ClientFieldName = "fieldA";
			arguments.toResult.addFailure(failure);
			failure = StructNew();
			failure.Message = "Third Message";
			failure.PropertyName = "propertyB";
			failure.ClientFieldName = "fieldB";
			arguments.toResult.addFailure(failure);
		</cfscript>
	</cffunction>


</cfcomponent>

