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
<cfcomponent output="false" name="BaseLocaleLoader" hint="I am a responsible for loading locale translation metadata into a struct.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="Constructor">
		<cfargument name="LoaderHelper" type="Any" required="true" />
		<cfset variables.LoaderHelper = arguments.LoaderHelper />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="loadLocales" returnType="any" access="public" output="false" hint="I return a struct of locale info">
		<cfargument name="localeMap" type="Any" required="false" default="" />
		<cfreturn StructNew() />
	</cffunction>

</cfcomponent>
	

