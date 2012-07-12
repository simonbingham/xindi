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
	
	<cffunction name="getBeanWithValidationFactoryShouldReturnThis" returntype="void" access="public">
		<cfscript>
			VF = validationFactory.getBean("validationFactory");
			assertEquals("validationfactory",listLast(getMetadata(VF).name,"."));
		</cfscript>
	</cffunction>


	<cffunction name="getBOVs" access="public" output="false" returntype="any" hint="Used to retrieve the BOVs for testing.">
		<cfparam name="variables.Validators" default="#structNew()#" />
		<cfreturn variables.Validators />
	</cffunction>

	<cffunction name="newResultShouldReturnBuiltInResultObjectWithDefaultConfig" access="public" returntype="void">
		<cfscript>
			result = validationFactory.newResult();
			assertEquals("validatethis.util.Result",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="newResultShouldReturnCustomResultObjectWhenspecifiedViaConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.ResultPath="validatethis.unitTests.Fixture.CustomResult";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			result = validationFactory.newResult();
			assertEquals("validatethis.unitTests.Fixture.CustomResult",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path));
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlCfmRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture_cfm");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path));
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlFileIsInAConfiguredFolder" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			theObject = createObject("component","Fixture.ObjectWithSeparateRulesFile");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path));
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWithoutAnnotationsWhenXmlRulesFileIsAlongsideCFCAndActualObjectIsPassedIn" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path),theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlFileIsInAConfiguredFolderAndCFCHasDottedPath" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			theObject = createObject("component","Fixture.level1.level2.ObjectWithDottedPath");
			BOValidator = validationFactory.getValidator(objectType="ObjectWithDottedPath",definitionPath=ValidateThisConfig.definitionPath,theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<!--- TODO: This test is for a feature that hasn't been written yet 
	<cffunction name="createBOVsFromCFCsShouldCreateBOVsFromAnnotatedCFCs" returntype="void" access="public">
		<cfscript>
			assertTrue(false,"This should fail as this hasn't been fully implemented yet!");
			ValidateThisConfig.BOComponentPaths="validatethis.unitTests.Fixture.AnnotatedBOs";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			injectMethod(validationFactory, this, "getBOVs", "getBOVs");
			validationFactory.createBOVsFromCFCs();
			BOVs = validationFactory.getBOVs();
		</cfscript>
	</cffunction>
	--->

</cfcomponent>

