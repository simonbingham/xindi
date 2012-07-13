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
<cfcomponent output="false" hint="This exists to allow for fake Groovy objects, which must include an object that is or extends 'groovy.lang.MetaClassImpl' to be created">
	
	<cffunction name="hasProperty" returntype="Any" access="public">
		<cfargument name="theObject" />
		<cfargument name="propertyName" />
		<cfif arguments.propertyName eq "GroovyName">
			<cfreturn createObject("component","MetaBeanProperty") />
		</cfif>
	
	</cffunction>
</cfcomponent>
