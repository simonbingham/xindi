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
			equalsHelper = CreateObject("component","ValidateThis.util.EqualsHelper").init();
			obj1 = CreateObject("component","fixture.APlainCFC_Fixture").init();
			obj2 = CreateObject("component","fixture.APlainCFC_Fixture").init();
			obj3 = CreateObject("component","fixture.APlainCFC_Fixture").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="equalsShouldReturnTrueForTwoObjectsWithSameValues" access="public" returntype="void">
		<cfscript>
			assertEquals(true,equalsHelper.isEqual(obj1,obj2));
		</cfscript>  
	</cffunction>

	<cffunction name="equalsShouldReturnFalseForTwoObjectsWithDifferentValues" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			assertEquals(false,equalsHelper.isEqual(obj1,obj2));
		</cfscript>  
	</cffunction>

	<cffunction name="isInArrayShouldReturnTrueWhenIdenticalObjectIsInArray" access="public" returntype="void">
		<cfscript>
			thingArray = [obj2];
			assertEquals(true,equalsHelper.isInArray(obj1,thingArray));
		</cfscript>  
	</cffunction>

	<cffunction name="isInArrayShouldReturnTrueWhenIdenticalObjectIsInMultiItemArray" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			thingArray = [obj2,obj3];
			assertEquals(true,equalsHelper.isInArray(obj1,thingArray));
		</cfscript>  
	</cffunction>

	<cffunction name="isInArrayShouldReturnFalseWhenIdenticalObjectIsNotInArray" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			thingArray = [obj2];
			assertEquals(false,equalsHelper.isInArray(obj1,thingArray));
		</cfscript>  
	</cffunction>

	<cffunction name="isInArrayShouldReturnFalseWhenIdenticalObjectIsNotInMultiItemArray" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			obj3.setFirstName(now());
			thingArray = [obj2,obj3];
			assertEquals(false,equalsHelper.isInArray(obj1,thingArray));
		</cfscript>  
	</cffunction>

	<cffunction name="isInStructShouldReturnTrueWhenIdenticalObjectIsInStruct" access="public" returntype="void">
		<cfscript>
			thingStruct = {a=obj2};
			assertEquals(true,equalsHelper.isInStruct(obj1,thingStruct));
		</cfscript>  
	</cffunction>

	<cffunction name="isInStructShouldReturnTrueWhenIdenticalObjectIsInMultiItemStruct" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			thingStruct = {a=obj2,b=obj3};
			assertEquals(true,equalsHelper.isInStruct(obj1,thingStruct));
		</cfscript>  
	</cffunction>

	<cffunction name="isInStructShouldReturnFalseWhenIdenticalObjectIsNotInStruct" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			thingStruct = {a=obj2};
			assertEquals(false,equalsHelper.isInStruct(obj1,thingStruct));
		</cfscript>  
	</cffunction>

	<cffunction name="isInStructShouldReturnFalseWhenIdenticalObjectIsNotInMultiItemStruct" access="public" returntype="void">
		<cfscript>
			obj2.setFirstName(now());
			obj3.setFirstName(now());
			thingStruct = {a=obj2,b=obj3};
			assertEquals(false,equalsHelper.isInStruct(obj1,thingStruct));
		</cfscript>  
	</cffunction>

</cfcomponent>
