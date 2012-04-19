<!---
	
	Copyright 2011, John Whish & Bob Silverberg 
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="ValidateThis.core.BaseTranslator" 
	hint="I act as a translator / adapter between ColdBox resource bundle and ValidateThis" 
	output="false">

	<cffunction name="setResourceBundle" returntype="void" output="false" hint="I am used to inject the ColdBox ResourceBundle">
		<cfargument name="resourcebundle" type="coldbox.system.plugins.ResourceBundle" hint="I am the ColdBox ResourceBundle plugin">
		<cfset variables.instance.resourcebundle = arguments.resourcebundle>
	</cffunction>

	<cffunction name="translate" returnType="any" access="public" output="false" hint="I translate text using the available resource bundle">
		<cfargument name="translateThis" type="Any" required="true" />
		<cfargument name="locale" type="Any" required="false" default="" />
		
		<cfset var theKey = safeKey(arguments.translateThis) />

		<cfif arguments.locale eq "">
			<cfset arguments.locale = variables.defaultLocale>
		</cfif>

		<!--- return key from resource bundle if it exists, otherwise use the message VT creates --->
		<cfreturn variables.instance.resourcebundle.getResource( resource=theKey, default=arguments.translateThis, locale=arguments.locale )>
	</cffunction>

</cfcomponent>