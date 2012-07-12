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
<cfcomponent output="false" name="BaseTranslator" hint="I am a responsible for translating text.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new Translator">
		<cfargument name="LocaleLoader" type="any" required="true" />
		<cfargument name="localeMap" type="struct" required="true" />
		<cfargument name="defaultLocale" type="string" required="true" />

		<cfset variables.defaultLocale = arguments.defaultLocale />
		<cfset variables.instance = StructNew() />
		<cfset variables.instance.locales = arguments.LocaleLoader.loadLocales(arguments.localeMap) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="translate" returnType="any" access="public" output="false" hint="I translate text">
		<cfargument name="translateThis" type="Any" required="true" />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfreturn arguments.translateThis />
	</cffunction>
	
	<cffunction name="getLocales" returnType="any" access="public" output="false" hint="I return the cached locales">
		<cfreturn variables.instance.locales />
	</cffunction>
	
	<cffunction name="getDefaultLocale" returnType="string" access="public" output="false" hint="I return the default locale">
		<cfreturn variables.defaultLocale />
	</cffunction>
	
	<cffunction name="safeKey" returnType="any" access="public" output="false" hint="I take a message and turn it into a key">
		<cfargument name="message" type="Any" required="true" />
		
		<cfreturn REReplace(Replace(arguments.message," ","_","all"),"\W","","all") />
	</cffunction>

</cfcomponent>
	

