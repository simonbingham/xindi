<!---
	
	Copyright 2009, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="RbLocaleLoader" extends="BaseLocaleLoader" hint="I am a responsible for loading locale translation metadata into a struct.">

	<cffunction name="loadLocales" returnType="any" access="public" output="false" hint="I load the resource bundle info into a struct and return it">
		<cfargument name="localeMap" type="Any" required="true" />

		<cfset var locale = 0 />
		<cfset var locales = StructNew() />
		
		<cfloop collection="#arguments.localeMap#" item="locale">
			<cfset locales[locale] = variables.LoaderHelper.getResourceBundle(findLocaleFile(arguments.localeMap[locale])) />
		</cfloop>

		<cfreturn locales />

	</cffunction>

	<cffunction name="findLocaleFile" returnType="any" access="public" output="false" hint="I return the complete path to a locale file">
		<cfargument name="localeFile" type="Any" required="true" />
		<cfreturn ExpandPath(arguments.localeFile) />
	</cffunction>

</cfcomponent>
