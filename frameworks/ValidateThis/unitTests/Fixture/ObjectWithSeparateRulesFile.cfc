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
<cfcomponent output="false">
	
	
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="FirstName" required="false" default="Bob" />
		<cfargument name="LastName" required="false" default="Silverberg" />
		<cfset variables.FirstName = arguments.FirstName />
		<cfset variables.LastName = arguments.LastName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setFirstName" access="public" returntype="any">
		<cfargument name="FirstName" required="false" default="Bob" />
		<cfset variables.FirstName = arguments.FirstName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFirstName" access="public" returntype="any">
		<cfreturn variables.FirstName />
	</cffunction>
	
	<cffunction name="setLastName" access="public" returntype="any">
		<cfargument name="LastName" required="false" default="Silverberg" />
		<cfset variables.LastName = arguments.LastName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getLastName" access="public" returntype="any">
		<cfreturn variables.LastName />
	</cffunction>
	
</cfcomponent>


