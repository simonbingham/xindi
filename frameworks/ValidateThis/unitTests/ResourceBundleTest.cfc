
<!---
	
filename:		\validatethis\samples\UnitTests\ResourceBundleTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ResourceBundleTest.cfc
				
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
<cfcomponent displayname="validatethis.unitTests.ResourceBundleTest" extends="validatethis.unitTests.BaseTestCase" output="false">
	
	<cfset ResourceBundle = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfset ResourceBundle = createObject("component","ValidateThis.util.ResourceBundle").init() />
	</cffunction>

	<cffunction name="FileNotFoundThrowsExpectedException" access="public" returntype="void" mxunit:expectedException="validatethis.util.ResourceBundle.FileNotFound">
		<cfscript>
			injectMethod(ResourceBundle, this, "RBFileExistsOverrideFalse", "RBFileExists");
			ResourceBundle.getResourceBundle("AFileThatDontExist");
		</cfscript>  
	</cffunction>

	<cffunction name="getResourceBundleReturnsExpectedKeys" access="public" returntype="void">
		<cfset RBFile = getDirectoryFromPath(getCurrentTemplatePath()) & CreateUUID() />
		<cfoutput>
		<cfsavecontent variable="RBContents">
		key1=value1
		key2=value2
		key3
		key4=a long string
		</cfsavecontent>
		</cfoutput>
		<cffile output="#RBContents#" action="write" file="#RBFile#">
		<cfscript>
			RB = ResourceBundle.getResourceBundle(RBFile);
			assertEquals(StructCount(RB),4);
			assertEquals(RB.key1,"value1");
			assertEquals(RB.key2,"value2");
			assertEquals(RB.key3,"");
			assertEquals(RB.key4,"a long string");
		</cfscript>
		<cffile action="delete" file="#RBFile#">
	</cffunction>

	<cffunction name="RBFileExistsOverrideFalse" access="private" returntype="any">
		<cfreturn false />
	</cffunction>

</cfcomponent>

