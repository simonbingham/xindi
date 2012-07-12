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
			sw = CreateObject("component","ValidateThis.core.StructWrapper").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="setupStruct" access="private" returntype="void">
		<cfscript>
			struct = {a=1,b=2};
			sw.setup(struct);
		</cfscript>
	</cffunction>
	
	<cffunction name="setupShouldLoadAStructIntoTheWrapper" access="public" returntype="void">
		<cfscript>
			setupStruct();
			assertEquals(sw.getA(),1);
		</cfscript>  
	</cffunction>

	<cffunction name="setupShouldLoadAJSONStringIntoTheWrapper" access="public" returntype="void">
		<cfscript>
			sw.setup('{"a":1,"b":2}');
			assertEquals(sw.getA(),1);
		</cfscript>  
	</cffunction>

	<cffunction name="getValueShouldReturnALoadedValue" access="public" returntype="void">
		<cfscript>
			setupStruct();
			assertEquals(sw.getValue("A"),1);
		</cfscript>  
	</cffunction>

	<cffunction name="getValueShouldReturnEmptyStringForMissingProperty" access="public" returntype="void">
		<cfscript>
			setupStruct();
			assertEquals(sw.getValue("C"),"");
		</cfscript>  
	</cffunction>

	<cffunction name="missingGetterShouldReturnALoadedValue" access="public" returntype="void">
		<cfscript>
			setupStruct();
			assertEquals(sw.getA(),1);
		</cfscript>  
	</cffunction>

</cfcomponent>

