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
<cfcomponent output="false" name="RBTranslator" extends="BaseTranslator" hint="I use Resource Bundles to translate text.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new Translator">
		<cfargument name="RBLocaleLoader" type="any" required="true" />
		<cfargument name="localeMap" type="struct" required="true" />
		<cfargument name="defaultLocale" type="string" required="true" />

		<cfreturn super.init(arguments.RBLocaleLoader,arguments.localeMap,arguments.defaultLocale) />
	</cffunction>

	<cffunction name="translate" returnType="any" access="public" output="false" hint="I translate text">
		<cfargument name="translateThis" type="Any" required="true" />
		<cfargument name="locale" type="Any" required="false" default="#variables.defaultLocale#" />
		
		<cfset var theKey = safeKey(arguments.translateThis) />
		
		<cfif NOT StructKeyExists(variables.instance.locales,arguments.locale)>
			<cfthrow type="validatethis.core.RBTranslator.LocaleNotDefined"
				message="The locale requested, '#arguments.locale#', has not been defined in the localeMap in the ValidateThisConfig." />
		</cfif>
		
		<cfif StructKeyExists(variables.instance.locales[arguments.locale],theKey)>
			<cfreturn variables.instance.locales[arguments.locale][theKey] />
		<cfelse>
			<cfreturn arguments.translateThis />
		</cfif>

	</cffunction>

</cfcomponent>
	

