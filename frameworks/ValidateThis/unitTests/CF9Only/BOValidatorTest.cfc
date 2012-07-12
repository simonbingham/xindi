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
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="getValidatorFromAnnotatedCFCReturnsCorrectValidator" access="public" returntype="void">
		<cfscript>
			BOValidator = createBOVFromCFC();
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="createBOVFromCFC" access="private" returntype="any">
		<cfscript>
			theObject = createObject("component","validatethis.unitTests.Fixture.AnnotatedBOs.User");
			return validationFactory.getValidator(objectType="User",theObject=theObject,definitionPath=getDirectoryFromPath(getMetadata(theObject).path));
		</cfscript>  
	</cffunction>

	<cffunction name="isBOVCorrect" access="private" returntype="void">
		<cfargument name="BOValidator">
		<cfscript>
			AllContexts = arguments.BOValidator.getAllContexts();
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

</cfcomponent>

