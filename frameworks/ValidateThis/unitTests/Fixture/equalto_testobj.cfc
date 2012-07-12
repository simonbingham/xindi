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
		<cfargument name="id" />
		<cfargument name="firstName" />
		<cfargument name="lastName" />
		<cfset variables.id = arguments.id />
		<cfset variables.firstName = arguments.firstName />
		<cfset variables.lastName = arguments.lastName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setId" access="public" returntype="any">
		<cfargument name="id" />
		<cfset variables.id = arguments.id />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getId" access="public" returntype="any">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="setFirstName" access="public" returntype="any">
		<cfargument name="firstName" />
		<cfset variables.firstName = arguments.firstName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFirstName" access="public" returntype="any">
		<cfreturn variables.firstName />
	</cffunction>
	
	<cffunction name="setLastName" access="public" returntype="any">
		<cfargument name="lastName" />
		<cfset variables.lastName = arguments.lastName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getLastName" access="public" returntype="any">
		<cfreturn variables.lastName />
	</cffunction>
	
</cfcomponent>


