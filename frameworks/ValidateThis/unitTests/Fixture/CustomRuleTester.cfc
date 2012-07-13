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
<cfcomponent output="false">
	
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="a" default="" />
		<cfset variables.a = arguments.a />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="customMethod" access="public" output="false" returntype="any" hint="A method to support the custom rule type.">

		<cfset var ReturnStruct = {IsSuccess=false,FailureMessage="The message returned from the method."} />
		<cfreturn ReturnStruct />		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

	<cffunction name="setA" access="public" returntype="any">
		<cfargument name="a" />
		<cfset variables.a = arguments.a />
		<cfreturn this />
	</cffunction>
	<cffunction name="getA" access="public" returntype="any">
		<cfreturn variables.a />
	</cffunction>

</cfcomponent>


