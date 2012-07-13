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
<cfcomponent extends="Wheels" output="false">
	
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="WheelsName" required="false" default="Bob" />
		<cfset this.WheelsName = arguments.WheelsName />
		<cfreturn this />
	</cffunction>

	<cffunction name="properties" access="public" returntype="any">
		<cfset var props = {WheelsName=this.WheelsName} />
		<cfreturn props />
	</cffunction>

	<cffunction name="$propertyvalue" access="public" returntype="any">
		<cfreturn "Bob" />
	</cffunction>

</cfcomponent>
