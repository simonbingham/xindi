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
<cfcomponent output="false" extends="ValidateThis.core.BaseMetadataProcessor"  hint="I am a responsible for reading and processing an XML file.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new XMLFileReader">
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="debuggingMode" type="string" required="true" />

		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.debuggingMode = arguments.debuggingMode />
		<cfset super.init(argumentCollection=arguments) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I read the validations XML file and reformat it into a struct">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" hint="the path to the file to read" />
		
		<cfthrow type="ValidateThis.core.fileReaders.BaseFileReader.MissingImplementation" detail="The loadRules method must be implemented in a concrete FileReader object" />

	</cffunction>
	
</cfcomponent>
	

