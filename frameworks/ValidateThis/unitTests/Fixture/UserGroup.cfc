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
		<cfargument name="userGroupId" />
		<cfargument name="userGroupDesc" />
		<cfset variables.userId = arguments.userGroupId />
		<cfset variables.userName = arguments.userGroupDesc />
		<cfreturn this />
	</cffunction>

	<cffunction name="setUserGroupId" access="public" returntype="any">
		<cfargument name="userGroupId" />
		<cfset variables.userGroupId = arguments.userGroupId />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserGroupId" access="public" returntype="any">
		<cfreturn variables.userGroupId />
	</cffunction>

	<cffunction name="setUserGroupDesc" access="public" returntype="any">
		<cfargument name="userGroupDesc" />
		<cfset variables.userGroupDesc = arguments.userGroupDesc />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserGroupDesc" access="public" returntype="any">
		<cfreturn variables.userGroupDesc />
	</cffunction>

</cfcomponent>


