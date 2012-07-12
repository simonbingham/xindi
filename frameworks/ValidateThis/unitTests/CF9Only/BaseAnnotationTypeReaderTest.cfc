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

	<cffunction name="annotationsAreThisFormatReturnsTrueIfMatchIsFound" access="public" returntype="void">
		<cfscript>
			props = [{vtrules="x"}];
			injectMethod(annotationTypeReader,this,"returnTrue","isThisFormat");
			assertTrue(annotationTypeReader.annotationsAreThisFormat(props));
		</cfscript>  
	</cffunction>

	<cffunction name="annotationsAreThisFormatReturnsFalseIfMatchNotFound" access="public" returntype="void">
		<cfscript>
			props = [{vtrules="x"}];
			injectMethod(annotationTypeReader,this,"returnFalse","isThisFormat");
			assertFalse(annotationTypeReader.annotationsAreThisFormat(props));
		</cfscript>  
	</cffunction>

	<cffunction name="returnTrue" access="private" returntype="boolean" hint="Used for inject method for mocking.">
		<cfreturn true />
	</cffunction>

	<cffunction name="returnFalse" access="private" returntype="boolean" hint="Used for inject method for mocking.">
		<cfreturn false />
	</cffunction>


	<cffunction name="processContextsReturnsCorrectArrayForJSONContexts" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.unitTests.Fixture.AnnotatedBOs.User");
			makePublic(annotationTypeReader,"processContexts");
			annotationTypeReader.processContexts(md.vtContexts);
			injectMethod(annotationTypeReader, this, "getContexts", "getContexts");
			contexts = annotationTypeReader.getContexts();
		</cfscript>  
	</cffunction>

	<cffunction name="processContextsReturnsCorrectArrayForListContexts" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.unitTests.Fixture.AnnotatedBOs.User_WithLists");
			makePublic(annotationTypeReader,"processContexts");
			annotationTypeReader.processContexts(md.vtContexts);
			injectMethod(annotationTypeReader, this, "getContexts", "getContexts");
			contexts = annotationTypeReader.getContexts();
		</cfscript>  
	</cffunction>

	<cffunction name="getContexts" access="public" output="false" returntype="any" hint="Used to retrieve the Contexts for testing.">
		<cfparam name="variables.Contexts" default="#structNew()#" />
		<cfreturn variables.Contexts />
	</cffunction>

	<cffunction name="processConditionsReturnsCorrectArrayForJSONConditions" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.unitTests.Fixture.AnnotatedBOs.User");
			makePublic(annotationTypeReader,"processConditions");
			annotationTypeReader.processConditions(md.vtConditions);
			injectMethod(annotationTypeReader, this, "getConditions", "getConditions");
			Conditions = annotationTypeReader.getConditions();
		</cfscript>  
	</cffunction>

	<cffunction name="processConditionsReturnsCorrectArrayForListConditions" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.unitTests.Fixture.AnnotatedBOs.User_WithLists");
			makePublic(annotationTypeReader,"processConditions");
			annotationTypeReader.processConditions(md.vtConditions);
			injectMethod(annotationTypeReader, this, "getConditions", "getConditions");
			Conditions = annotationTypeReader.getConditions();
		</cfscript>  
	</cffunction>

	<cffunction name="getConditions" access="public" output="false" returntype="any" hint="Used to retrieve the Conditions for testing.">
		<cfparam name="variables.Conditions" default="#structNew()#" />
		<cfreturn variables.Conditions />
	</cffunction>

	<cffunction name="processPropertyDescsReturnsCorrectArrayForJSON" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.unitTests.Fixture.AnnotatedBOs.User");
			makePublic(annotationTypeReader,"processPropertyDescs");
			makePublic(annotationTypeReader,"reformatProperties");
			annotationTypeReader.processPropertyDescs(annotationTypeReader.reformatProperties(md.properties));
			injectMethod(annotationTypeReader, this, "getPropertyDescs", "getPropertyDescs");
			PropertyDescs = annotationTypeReader.getPropertyDescs();
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="getPropertyDescs" access="public" output="false" returntype="any" hint="Used to retrieve the PropertyDescs for testing.">
		<cfparam name="variables.PropertyDescs" default="#structNew()#" />
		<cfreturn variables.PropertyDescs />
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

