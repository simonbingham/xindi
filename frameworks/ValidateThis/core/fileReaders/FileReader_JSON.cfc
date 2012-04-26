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
<cfcomponent output="false" extends="BaseFileReader" hint="I am a responsible for reading and processing a JSON file.">

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I read the validations JSON file and reformat it into private properties">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" hint="the path to the file to read" />

		<cfset var jsonStruct = 0 />
		<cfset var VT = 0 />
		<cfset var fileContent = variables.FileSystem.read(arguments.metadataSource).getContent() />
		
		<cfif isJSON(fileContent)>
			<cfset jsonStruct = deserializeJSON(fileContent) />
			<cfif structKeyExists(jsonStruct,"validateThis")>
				<cfset VT = jsonStruct.validateThis />
				<cfif structKeyExists(VT,"conditions")>
					<cfset processConditions(VT.conditions) />
				</cfif>
				<cfif structKeyExists(VT,"contexts")>
					<cfset processContexts(VT.contexts) />
				</cfif>
				<cfif structKeyExists(VT,"objectProperties")>
					<cfset processPropertyDescs(VT.objectProperties) />
					<cfset processPropertyRules(arguments.objectType,VT.objectProperties) />
				</cfif>
			<cfelse>
				<cfthrow type="ValidateThis.core.fileReaders.Filereader_JSON.invalidJSON" detail="The json object in the file #arguments.metadataSource# does not contain a validateThis struct." />
			</cfif>
		<cfelse>
			<cfthrow type="ValidateThis.core.fileReaders.Filereader_JSON.invalidJSON" detail="The contents of the file #arguments.metadataSource# are not valid JSON." />
		</cfif>

	</cffunction>
		
</cfcomponent>
	

