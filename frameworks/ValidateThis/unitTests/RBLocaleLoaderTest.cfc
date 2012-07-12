<!---
	
filename:		\validatethis\samples\UnitTests\RBLocaleLoaderTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I RBLocaleLoaderTest.cfc
				
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
<cfcomponent displayname="validatethis.unitTests.RBLocaleLoaderTest" extends="validatethis.unitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			variables.LoaderHelper = mock();
			variables.locales = {valA="A",valB="B"};
			variables.LoaderHelper.getResourceBundle("A").returns("A");
			variables.LoaderHelper.getResourceBundle("B").returns("B");
			variables.RBLocaleLoader = CreateObject("component","ValidateThis.core.RBLocaleLoader").init(variables.LoaderHelper);
			injectMethod(variables.RBLocaleLoader, this, "findLocaleFileOverride", "findLocaleFile");
		</cfscript>
	</cffunction>

	<cffunction name="loadLocalesReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			expected = variables.locales;
			localeMap = variables.locales;
			actual = variables.RBLocaleLoader.loadLocales(localeMap);
			assertEquals(expected,actual);
		</cfscript>  
	</cffunction>

	<cffunction name="findLocaleFileOverride" returnType="any" access="private" output="false" hint="I return the complete path to a locale file">
		<cfargument name="localeFile" type="Any" required="true" />
		<cfreturn arguments.localeFile />
	</cffunction>

</cfcomponent>

