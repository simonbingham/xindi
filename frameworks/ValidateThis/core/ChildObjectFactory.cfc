<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" hint="I load child objects for various other objects.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ChildObjectFactory">
		<cfargument name="fileSystem" type="any" required="true" />
		<cfset variables.fileSystem = arguments.fileSystem />
		<cfreturn this />
	</cffunction>

	<cffunction name="loadChildObjects" returntype="struct" access="public" output="false" hint="I am a utility function used to create groups of child objects, such as SRVs, CRSs and fileReaders.">
		<cfargument name="childPaths" type="string" required="true" hint="A comma delimited list of component paths" />
		<cfargument name="fileNamePrefix" type="string" required="true" hint="The expected prefix for the object type (e.g., ServerRuleValidator_)" />
		<cfargument name="childCollection" type="struct" required="false" default="#StructNew()#" hint="The structure into which to load the objects" />
		<cfargument name="initArguments" type="struct" required="false" default="#StructNew()#" hint="The arguments to be passed to the init method of each object" />
		<cfset var objNames = "" />
		<cfset var obj = 0 />
		<cfset var childPath = ""/>
		<cfset var componentPath = ""/>
		<cfset var actualPath = ""/>
		
		<cfloop list="#arguments.childPaths#" index="childPath">
			<cfset actualPath = variables.fileSystem.getMappingPath(childPath) />
			<cfset componentPath = childPath & "." />
			<cfset objNames = variables.fileSystem.listFiles(actualPath)/>
			<cfloop list="#objNames#" index="obj">
				<cfif ListLast(obj,".") EQ "cfc" AND obj CONTAINS arguments.fileNamePrefix>
					<cftry>
						<cfset arguments.childCollection[replaceNoCase(ListLast(obj,"_"),".cfc","")] = CreateObject("component",componentPath & ReplaceNoCase(obj,".cfc","")).init(argumentCollection=arguments.initArguments) />
						<cfcatch type="any">
							<cfthrow type="ValidateThis.core.ChildObjectFactory.ErrorCreatingChildObject" message="Error creating #componentPath & obj# : #cfcatch.message#" />
						</cfcatch>
					</cftry>
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfreturn arguments.childCollection />
	</cffunction>
	
</cfcomponent>


	

