<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->

<cfcomponent displayname="userGroup" output="false">
	
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="userGroupId" required="false" type="any" default="0" />
		
		<cfset var i = "">
		
		<cfif arguments.userGroupId neq 1>
			<cfloop collection="#this#" item="i">
				<cfif left(i,3) eq "set">
					<cfset variables[right(i,len(i)-3)] = "" />
				</cfif>
			</cfloop>
		<cfelse>
			<cfscript>
				// set values for a "real" record here
				variables.userGroupId = 1;
			</cfscript>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="populate" access="public" output="false" returntype="any" hint="Populates the object with values from the argumemnts">
		<cfargument name="data" type="any" required="yes" />

        <cfset var i = 0 />
		
		<cfloop collection="#arguments.data#" item="i">
			<cfif structKeyExists(this,"set" & i)>
				<cfset variables[i] = arguments.data[i] />
			</cfif>
		</cfloop>
		
    </cffunction>

	<cffunction name="getMemento" access="public" output="false" returntype="any">
		<cfreturn variables />
    </cffunction>

	<!--- property getters and setters --->	
	<cffunction name="setUserGroupId" access="public" returntype="any">
		<cfargument name="userGroupId" />
		<cfset variables.userGroupId = arguments.userGroupId />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserGroupId" access="public" returntype="any">
		<cfreturn variables.userGroupId />
	</cffunction>
	<cffunction name="setUserGroupName" access="public" returntype="any">
		<cfargument name="userGroupName" />
		<cfset variables.userGroupName = arguments.userGroupName />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserGroupName" access="public" returntype="any">
		<cfreturn variables.userGroupName />
	</cffunction>
	
</cfcomponent>

