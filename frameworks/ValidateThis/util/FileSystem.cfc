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
<cfcomponent name="FileSystem" output="false" hint="I am responsible for all file system access.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new Filesystem Object">
		<cfargument name="transientFactory" type="any" required="true" />

		<cfset variables.transientFactory = arguments.transientFactory />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="upload" access="public" output="false" returntype="any">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="formFieldName" required="true" type="string" />
		<cfargument name="NewFileName" required="false" type="string" />

		<cfset var Result = newResult() />
		<cfset var FileUpload = 0 />
		<cfset var theDestination = fixDestination(arguments.Destination,true) />

		<cftry>
			<cfif StructKeyExists(arguments,"NewFileName")>
				<cffile action="upload" filefield="#arguments.formFieldName#" destination="#theDestination#"  nameconflict="makeunique" result="FileUpload" />
				<cfset Result.setServerFile(FileUpload.serverFile) />
				<cfset move(theDestination,FileUpload.serverFileName,FileUpload.serverFileExt,arguments.NewFileName,Result) />
				<cfif NOT Result.getIsSuccess()>
					<cfthrow type="fileSystem.move">
				</cfif>
			<cfelse>
				<cffile action="upload" filefield="#arguments.formFieldName#" destination="#theDestination#"  nameconflict="overwrite" result="FileUpload" />
				<cfset Result.setServerFile(FileUpload.serverFile) />
				<cfset Result.setIsSuccess(true) />
			</cfif>
			<cfcatch type="any">
				<cfset Result.setIsSuccess(false) />
			</cfcatch>
		</cftry>
		<cfreturn Result />
	</cffunction>
	
	<cffunction name="move" access="public" output="false" returntype="struct">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="sourceFileName" required="true" type="string" />
		<cfargument name="sourceFileExt" required="true" type="string" />
		<cfargument name="fileName" required="false" type="string" default="#uniqueFileName()#" />
		<cfargument name="Result" required="false" type="any" default="#newResult()#" />

		<cftry>
			<cffile action="move" source="#variables.basePath##arguments.sourceFileName#.#arguments.sourceFileExt#" destination="#arguments.Destination##arguments.fileName#.#arguments.sourceFileExt#" />
			<cfset arguments.Result.setIsSuccess(true) />
			<cfset arguments.Result.setSourceFile(arguments.sourceFileName & "." & arguments.sourceFileExt) />
			<cfset arguments.Result.setDestinationFile(arguments.fileName & "." & arguments.sourceFileExt) />
			<cfcatch type="any">
				<cfset arguments.Result.setIsSuccess(false) />
			</cfcatch>
		</cftry>
		<cfreturn Result />
	</cffunction>
	
	<cffunction name="uniquefilename" access="private" output="false" returntype="string">
		<cfreturn "File_" & dateformat(now(),"mmddyy") & "_" & timeformat(now(),"HHmmss") />
	</cffunction>

	<cffunction name="getAbsolutePath" access="public" output="false" returntype="string" hint="Turn any system path, either relative or absolute, into a fully qualified one">
		<cfargument name="path" type="string" required="true" hint="Abstract pathname">
		
		<cfset var dirExists = false />
		<cftry>
            <cfset dirExists = DirectoryExists(arguments.path) /> 
            <cfcatch type="security" /> 
        </cftry>
        <cfif not dirExists>
			<cfif Right(arguments.path,1) EQ "/">
				<cfset arguments.path = left(arguments.path,len(arguments.path)-1) />
			</cfif>
			<cfset arguments.path = expandPath(arguments.path) />
		</cfif>
		<cfif Right(arguments.path,1) NEQ "/">
			<cfset arguments.path = arguments.path & "/" />
		</cfif>
		<cfreturn arguments.path />
	</cffunction>

	<cffunction name="CheckFileExists" access="public" output="false" returntype="any">
		<cfargument name="Destination" required="true" type="any" />
		<cfargument name="FileName" required="true" type="any" />
		
		<cfreturn FileExists(arguments.Destination & arguments.FileName) />
	</cffunction>

	<cffunction name="CheckDirectoryExists" access="public" output="false" returntype="any">
		<cfargument name="Destination" required="true" type="string" hint="A comma delimited list of relative or absolute paths" />
		
		<cfset var aPath = "" />
		<cfset var exists = false />
		<cfloop list="#arguments.Destination#" index="aPath">
			<cfif DirectoryExists(getAbsolutePath(aPath))>
				<cfset exists = true />
				<cfbreak />
			</cfif>
		</cfloop>
		<cfreturn exists />
	</cffunction>

	<cffunction name="listFiles" access="public" output="false" returntype="any" hint="returns a list of filenames">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="Filter" required="false" type="string" default=""/>
		<cfargument name="recurse" required="false" type="boolean" default="false"/>
		<cfset var qryDir = "">
		<cfdirectory directory="#arguments.Destination#" filter="#arguments.Filter#" name="qryDir" action="list" type="file" recurse="#arguments.recurse#" />
		<cfreturn ValueList(qryDir.name)>
	</cffunction>

	<cffunction name="listRelativeFilePaths" access="public" output="false" returntype="any" hint="returns a list of filenames with path info">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="Filter" required="false" type="string" default=""/>
		<cfargument name="recurse" required="false" type="boolean" default="false"/>
		<cfset var qryDir = "">
		<cfset var theList = "">
		<cfdirectory directory="#arguments.Destination#" filter="#arguments.Filter#" name="qryDir" action="list" type="file" recurse="#arguments.recurse#" />
		<cfloop query="qryDir">
			<cfset theList = listAppend(theList,replace(replaceNoCase(qryDir.directory,arguments.Destination,""),"\","/") & "/" & qryDir.name) />
		</cfloop>
		<cfreturn theList>
	</cffunction>

	<cffunction name="listDirs" access="public" output="false" returntype="any" hint="returns a list of directories">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="Filter" required="false" type="string" default=""/>
		
		<cfset var qryDir = "">
		<cfdirectory directory="#arguments.Destination#" filter="#arguments.Filter#" name="qryDir" action="list" type="dir" />
		<cfreturn ValueList(qryDir.name)>
	</cffunction>

	<cffunction name="CreateFile" access="public" output="false" returntype="any">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="FileName" required="true" type="any" />
		<cfargument name="Content" required="true" type="any" />
		
		<cfset var Result = newResult() />
		<cftry>
			<cflock type="exclusive" name="#arguments.Destination##arguments.FileName#" timeout="10">
				<cffile action="write" file="#arguments.Destination##arguments.FileName#" output="#arguments.Content#" />
			</cflock>
			<cfset Result.setIsSuccess(true) />
			<cfcatch type="any">
				<cfset Result.setFailure(cfcatch) />
				<cfset Result.setIsSuccess(false) />
			</cfcatch>
		</cftry>
		<cfreturn Result />

	</cffunction>

	<cffunction name="read" access="public" output="false" returntype="any">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="FileName" required="false" type="string" default="" />

		<cfset var Result = newResult() />
		<cfset var Content = 0 />
		<cftry>
			<cffile action="read" file="#arguments.Destination##arguments.FileName#" variable="Content" />
			<cfset Result.setContent(Content) />
			<cfset Result.setIsSuccess(true) />
			<cfcatch type="any">
				<cfset Result.setFailure(cfcatch) />
				<cfset Result.setIsSuccess(false) />
			</cfcatch>
		</cftry>
		<cfreturn Result />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="any">
		<cfargument name="Destination" required="true" type="string" />
		<cfargument name="FileName" required="true" type="string" />

		<cfset var Result = newResult() />
		<cftry>
			<cffile action="delete" file="#arguments.Destination##arguments.FileName#" />
			<cfset Result.setIsSuccess(true) />
			<cfcatch type="any">
				<cfset Result.setFailure(cfcatch) />
				<cfset Result.setIsSuccess(false) />
			</cfcatch>
		</cftry>
		<cfreturn Result />
	</cffunction>
	
	<cffunction name="getMappingPath" access="public" output="false" returntype="any" hint="I convert a dot path notation to full system path.">
		<cfargument name="Mapping" type="string" required="false" default="" />
			<cfset var componentPath = replace(arguments.Mapping,".","/","all")/>
			<!--- add the leading slash if none exists --->
			<cfif ListFirst(componentPath,"") NEQ "/">
				<cfset componentPath = "/" & componentPath />
			</cfif>
			<cfreturn expandPath(componentPath)/>
	</cffunction>
	
	
	<cffunction name="fixDestination" access="private" output="false" returntype="any" hint="I ensure that the destination ends with a slash, and I create the destination directory if it doesn't exist">
		<cfargument name="Destination" type="string" required="false" default="" />
		<cfargument name="createDir" type="boolean" required="false" default="false" />
		
		<cfset var theDestination = arguments.Destination />
		<!--- add the trailing slash if none exists --->
		<cfif ListLast(theDestination,"") NEQ "/">
			<cfset theDestination = theDestination & "/" />
		</cfif>
		<cfif arguments.createDir and not directoryExists(theDestination)>
			<cfdirectory action="create" directory="#theDestination#" />
		</cfif>
		<cfreturn theDestination />
	</cffunction>	

	<cffunction name="newResult" access="private" output="false" returntype="any">
		<cfreturn variables.transientFactory.newResult() />
	</cffunction>

</cfcomponent>
