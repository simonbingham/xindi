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
<cfcomponent output="false" name="externalFileReader" hint="I am a responsible for reading and processing external rules files.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new externalFileReader">
		<cfargument name="fileSystem" type="any" required="true" />
		<cfargument name="transientFactory" type="any" required="true" />
		<cfargument name="extraFileReaderComponentPaths" type="string" required="true" />
		<cfargument name="externalFileTypes" type="string" required="true" />

		<cfset variables.fileSystem = arguments.fileSystem />
		<cfset variables.transientFactory = arguments.transientFactory />
		<cfset variables.extraFileReaderComponentPaths = arguments.extraFileReaderComponentPaths />
		<cfset variables.externalFileTypes = arguments.externalFileTypes />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="verifyAtLeastOnePathIsValid" returnType="void" access="private" output="false" hint="I check to ensure that at least one path can be found">
		<cfargument name="definitionPath" type="any" required="true" />
		
		<cfif NOT variables.fileSystem.CheckDirectoryExists(arguments.definitionPath)>
			<cfthrow type="ValidateThis.core.externalFileReader.definitionPathNotFound" detail="None of the folder(s) #arguments.definitionPath# can be found. You must specify either a complete path to a physical folder or a mapping to a physical folder." />
		</cfif>

	</cffunction>

	<cffunction name="locateRulesFile" returnType="string" access="private" output="false" hint="I attempt to find an external rules definition file for an object and file type">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />
		<cfargument name="fileType" type="any" required="true" />

		<cfset var aPath = 0 />
		<cfset var defPath = 0 />
		<cfset var fileName = "" />
		
		<cfloop list="#arguments.definitionPath#" index="aPath">
			<cfset defPath = variables.fileSystem.getAbsolutePath(aPath) />
			<cfif variables.fileSystem.checkFileExists(defPath,arguments.objectType & "." & arguments.fileType)>
				<cfset fileName = arguments.objectType & "." & arguments.fileType />
			<cfelseif variables.fileSystem.checkFileExists(defPath,arguments.objectType & "." & arguments.fileType & ".cfm")>
				<cfset fileName = arguments.objectType & "." & arguments.fileType & ".cfm" />
			<cfelseif variables.fileSystem.checkFileExists(defPath & arguments.objectType & "/",arguments.objectType & "." & arguments.fileType)>
				<cfset fileName = arguments.objectType & "/" & arguments.objectType & "." & arguments.fileType />
			<cfelseif variables.fileSystem.checkFileExists(defPath & arguments.objectType & "/",arguments.objectType & "." & arguments.fileType & ".cfm")>
				<cfset fileName = arguments.objectType & "/" & arguments.objectType & "." & arguments.fileType & ".cfm" />
			</cfif>
			<cfif len(fileName) NEQ 0>
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif len(fileName) NEQ 0>
			<cfreturn defPath & fileName />
		<cfelse>
			<cfreturn "" />
		</cfif>
		
	</cffunction>

	<cffunction name="loadRulesFromExternalFile" returnType="any" access="public" output="false" hint="I read the validation metadata from external files and reformat it into a struct">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />

		<!--- NOTE: Right now this will only process one file per object - the first one found.
			That won't allow for rule inheritance. Is that something that was meant to be in place?
		--->
		<cfset var fileType = "" />
		<cfset var fileName = "" />
		<cfset var fileReader = "" />
		<cfset var rulesStruct = {PropertyDescs = StructNew(), ClientFieldDescs = StructNew(), ClientFieldNames = StructNew(), FormContexts = StructNew(), Validations = {Contexts = {___Default = ArrayNew(1)}}} />

		<cfset verifyAtLeastOnePathIsValid(arguments.definitionPath) />
		
		<cfloop list="#variables.externalFileTypes#" index="fileType">
			<cfset fileName = locateRulesFile(arguments.objectType,arguments.definitionPath,fileType) />
			<cfif len(fileName) NEQ 0>
				<cfset fileReader = variables.transientFactory.create("FileReader_" & fileType) />
				<cfset rulesStruct = fileReader.getValidations(arguments.objectType,fileName) />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif len(fileName) eq 0>
			<!--- TODO: We're not going to throw an error if no file is found.  Rather we'll just end up with a BO validator with no rules in it.
					It would be nice to have a way of notifying the user of this for debugging purposes. trying a throw within a try for now. --->
			<cftry>
				<cfthrow type="ValidateThis.core.externalFileReader.#arguments.objectType#.definitionFileNotFound" detail="No rules definition files were found for #arguments.objectType# in #arguments.definitionPath#." />
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>
		
		<cfreturn rulesStruct />
	</cffunction>
	
</cfcomponent>
	

