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
<cfcomponent extends="validatethis.unitTests.BaseTestCase" output="false">
	
	<cfset FileSystem = "" />
	<cfset Destination = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			Result = mock();
			TF = mock();
			TF.newResult().returns(Result);
			FileSystem = CreateObject("component","ValidateThis.util.FileSystem").init(TF);
			//FileSystem = getBeanFactory().getBean("ValidateThis").getBean("FileSystem") ;
			Destination = GetDirectoryFromPath(GetCurrentTemplatePath());
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="checkFileExistsShouldWork" access="public" returntype="void">
		<cfscript>
			FileName = ListLast(Replace(GetCurrentTemplatePath(),"\","/","all"),"/");
			Result = FileSystem.checkFileExists(Destination,FileName);
			assertTrue(Result);
			Result = FileSystem.checkFileExists(Destination,FileName&".notafile");
			assertFalse(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithSingleExistingDirectoryShouldReturnTrue" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists(GetDirectoryFromPath(GetCurrentTemplatePath()));
			assertTrue(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithSingleExistingMappedDirectoryNoTrailingSlashShouldReturnTrue" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists("/ValidateThis/core");
			assertTrue(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithSingleExistingMappedDirectoryWithTrailingSlashShouldReturnTrue" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists("/ValidateThis/core/");
			assertTrue(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithSingleNonExistentDirectoryShouldReturnFalse" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "NotADirectory");
			assertFalse(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithSingleNonExistentMappedDirectoryShouldReturnFalse" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists("/ValidateThis/core/NotADirectory");
			assertFalse(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithListOfPathsWithOneExistingShouldReturnTrue" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "," & GetDirectoryFromPath(GetCurrentTemplatePath()) & "NotADirectory");
			assertTrue(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithListOfPathsWithOneExistingMappingShouldReturnTrue" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists("/ValidateThis/core" & "," & GetDirectoryFromPath(GetCurrentTemplatePath()) & "NotADirectory");
			assertTrue(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="checkDirectoryExistsWithListOfPathsWithNoExistingShouldReturnFalse" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckDirectoryExists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "NotADirectory," & GetDirectoryFromPath(GetCurrentTemplatePath()) & "NotADirectoryEither");
			assertFalse(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="createFileReadDeleteShouldWork" access="public" returntype="void">
		<cfscript>
			FileName = CreateUUID() & ".txt";
			Content = "The file content.";
			Result = FileSystem.checkFileExists(Destination,FileName);
			assertFalse(Result);
			Result = FileSystem.CreateFile(Destination,FileName,Content);
			Result = FileSystem.checkFileExists(Destination,FileName);
			assertTrue(Result);
			Result = FileSystem.Read(Destination,FileName);
			// this cannot be easily checked without an actual Result object
			//assertEquals(Trim(Result.getContent()),Content);
			Result = FileSystem.Delete(Destination,FileName);
			Result = FileSystem.checkFileExists(Destination,FileName);
			assertFalse(Result);
		</cfscript>  
	</cffunction>

</cfcomponent>

