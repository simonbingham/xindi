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

	<!--- ***** NOTE *****
		These tests, the ones for Wheels objects and Groovy objects anyway, aren't really testing those objects, as we're using fakes.
		We're just testing the logic that we believe is necessary.
		It might be nice to set up a test to actually test those objects.
	--->
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			objectChecker = CreateObject("component","ValidateThis.util.ObjectChecker").init("getValue");
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="isCFCReturnsTrueforCFC" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals(true,objectChecker.isCFC(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isCFCReturnsFalseforNonObject" access="public" returntype="void">
		<cfscript>
			var obj = "x";
			assertEquals(false,objectChecker.isCFC(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isCFCReturnsFalseForJavaObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("java","java.lang.Integer");
			assertEquals(false,objectChecker.isCFC(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isWheelsReturnsTrueforWheelsObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","models.FakeWheelsObject_Fixture").init();
			assertEquals(true,objectChecker.isWheels(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isWheelsReturnsFalseforNonWheelsObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals(false,objectChecker.isWheels(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isGroovyReturnsTrueforGroovyObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","groovy.lang.FakeGroovyObject_Fixture").init();
			assertEquals(true,objectChecker.isGroovy(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isGroovyReturnsFalseforCFC" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals(false,objectChecker.isGroovy(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isGroovyReturnsFalseforPOJO" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("java","java.lang.Integer");
			assertEquals(false,objectChecker.isGroovy(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="findGetterReturnsGetterForExistingMethodInCFC" access="public" returntype="void">
		<cfscript>
			var cfc = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals("getFirstName()",objectChecker.findGetter(cfc,"FirstName"));
		</cfscript>  
	</cffunction>

	<cffunction name="findGetterReturnsBlankForNonExistentMethodInCFC" access="public" returntype="void">

		<cfscript>
			var cfc = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals("",objectChecker.findGetter(cfc,"Blah"));
		</cfscript>  
	</cffunction>

	<cffunction name="findGetterReturnsGetterForAbstractGetterInCFC" access="public" returntype="void">
		<cfscript>
			var cfc = CreateObject("component","fixture.CFCWithAbstractGetter_Fixture").init();
			objectChecker = CreateObject("component","ValidateThis.util.ObjectChecker").init("getProperty");
			assertEquals("getProperty('FirstName')",objectChecker.findGetter(cfc,"FirstName"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="findGetterReturnsGetterForOnMissingMethodInCFC" access="public" returntype="void">
		<cfscript>
			var cfc = CreateObject("component","fixture.CFCWithOnMM_Fixture").init();
			objectChecker = CreateObject("component","ValidateThis.util.ObjectChecker").init("");
			assertEquals("getFirstName()",objectChecker.findGetter(cfc,"FirstName"));
		</cfscript>  
	</cffunction>

	<cffunction name="findGetterReturnsGetValueForStructWrapper" access="public" returntype="void">
		<cfscript>
			var wrapper = CreateObject("component","validatethis.core.StructWrapper").init();
			objectChecker = CreateObject("component","ValidateThis.util.ObjectChecker").init("getProperty");
			assertEquals("getValue('FirstName')",objectChecker.findGetter(wrapper,"FirstName"));
		</cfscript>
	</cffunction>

	<cffunction name="findGetterReturnsGetterForExistingMethodInWheelsObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","models.FakeWheelsObject_Fixture").init();
			assertEquals("$propertyvalue('WheelsName')",objectChecker.findGetter(obj,"WheelsName"));
		</cfscript>  
	</cffunction>

	<cffunction name="findGetterReturnsBlankForNonExistentMethodInWheelsObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","models.FakeWheelsObject_Fixture").init();
			assertEquals("",objectChecker.findGetter(obj,"Blah"));
		</cfscript>  
	</cffunction>

	<cffunction name="findGetterReturnsGetterForExistingMethodInGroovyObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","groovy.lang.FakeGroovyObject_Fixture").init();
			injectMethod(ObjectChecker, this, "isCFCFalse", "isCFC");
			assertEquals("getGroovyName()",objectChecker.findGetter(obj,"GroovyName"));
		</cfscript>  
	</cffunction>

	<cffunction name="findGetterReturnsBlankForNonExistentMethodInGroovyObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","groovy.lang.FakeGroovyObject_Fixture").init();
			injectMethod(ObjectChecker, this, "isCFCFalse", "isCFC");
			assertEquals("",objectChecker.findGetter(obj,"Blah"));
		</cfscript>  
	</cffunction>

	<cffunction name="isCFCFalse" access="private" output="false" returntype="any" hint="Used to fake out the object checker as we cannot create a true fake Groovy object.">
		<cfargument name="theObject" type="any" required="true" />
		
		<cfreturn false />
	
	</cffunction>

</cfcomponent>

