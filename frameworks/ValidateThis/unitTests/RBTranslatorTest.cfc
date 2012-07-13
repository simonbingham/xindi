
<!---
	
filename:		\validatethis\samples\UnitTests\RBTranslatorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I RBTranslatorTest.cfc
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	2008-10-22	New																		BS

--->
<cfcomponent displayname="validatethis.unitTests.RBTranslatorTest" extends="validatethis.unitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			locales = {en_US=StructNew(),fr_FR=StructNew()};
			locales.en_US.NotEmail = "Hey, buddy, you call that an Email Address?";
			locales.en_US.ReplaceChars = "Hey, {1}, you call that a {2}, {3,number,currency}?";
			locales.fr_FR.NotEmail = "H�, mon pote, que vous appelez une adresse de courriel?";
			locales.fr_FR.The_Email_Address_is_required = "L'adresse e-mail est requis.";
			MockRBLoader = mock();
			MockRBLoader.loadLocales("{struct}").returns(locales);
			variables.RBTranslator = CreateObject("component","ValidateThis.core.RBTranslator").init(MockRBLoader,StructNew(),"en_US");
		</cfscript>
	</cffunction>

	<cffunction name="RBTranslatorReturnsRBTranslator" access="public" returntype="void">
		<cfscript>
			assertTrue(GetMetadata(variables.RBTranslator).name CONTAINS "RBTranslator");
		</cfscript>  
	</cffunction>

	<cffunction name="safeKeyReturnsProperKey" access="public" returntype="void">
		<cfscript>
			expected = "SafeKey";
			assertEquals(expected,variables.RBTranslator.safeKey("SafeKey"));
			assertEquals(expected,variables.RBTranslator.safeKey("Safe!Key"));
			assertEquals(expected,variables.RBTranslator.safeKey("Safe.Key$"));
			expected = "Safe_Key";
			assertEquals(expected,variables.RBTranslator.safeKey("Safe!_Key"));
			assertEquals(expected,variables.RBTranslator.safeKey("Safe Key"));
		</cfscript>  
	</cffunction>

	<cffunction name="GetLocalesReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			assertEquals(StructCount(variables.RBTranslator.getLocales()),2);
		</cfscript>  
	</cffunction>

	<cffunction name="defaultLocaleDefinedKeyReturnsTranslatedText" access="public" returntype="void">
		<cfscript>
			theKey = "NotEmail";
			locale = "en_US";
			expectedText = "Hey, buddy, you call that an Email Address?";
			assertEquals(expectedText,variables.RBTranslator.translate(theKey,locale));
		</cfscript>  
	</cffunction>
	
	<cffunction name="defaultLocaleUnDefinedNonKeyReturnsUnTranslatedText" access="public" returntype="void">
		<cfscript>
			theKey = "Some Undefined Key";
			locale = "en_US";
			expectedText = theKey;
			assertEquals(expectedText,variables.RBTranslator.translate(theKey,locale));
		</cfscript>  
	</cffunction>
	
	<cffunction name="defaultLocaleUnDefinedProperKeyReturnsUntranslatedText" access="public" returntype="void">
		<cfscript>
			theKey = "Undefined_Proper_Key";
			locale = "en_US";
			expectedText = theKey;
			assertEquals(expectedText,variables.RBTranslator.translate(theKey,locale));
		</cfscript>  
	</cffunction>
	
	<cffunction name="notDefaultLocaleDefinedKeyReturnsTranslatedText" access="public" returntype="void">
		<cfscript>
			theKey = "NotEmail";
			locale = "fr_FR";
			expectedText = "H�, mon pote, que vous appelez une adresse de courriel?";
			assertEquals(expectedText,variables.RBTranslator.translate(theKey,locale));
		</cfscript>  
	</cffunction>
	
	<cffunction name="notDefaultLocaleUnDefinedKeyReturnsUntranslatedText" access="public" returntype="void" >
		<cfscript>
			theKey = "Some Undefined Key";
			locale = "fr_FR";
			variables.RBTranslator.translate(theKey,locale);
		</cfscript>
	</cffunction>
	
	<cffunction name="MissingLocaleThrowsExpectedException" access="public" returntype="void" mxunit:expectedException="validatethis.core.RBTranslator.LocaleNotDefined">
		<cfscript>
			theKey = "SomeText";
			locale = "bob";
			expectedText = "bob";
			assertEquals(variables.RBTranslator.translate(theKey,locale),expectedText);
		</cfscript>  
	</cffunction>

</cfcomponent>

