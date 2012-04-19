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
<cfcomponent output="false" hint="I am used to deal with different types of objects: standard CFCs, Wheels objects and Groovy objects.">

	<cffunction name="Init" access="Public" returntype="any" output="false">
		<cfargument name="abstractGetterMethod" type="string" required="true" />

		<cfset variables.abstractGetterMethod = arguments.abstractGetterMethod />
		<cfreturn this />

	</cffunction>

	<cffunction name="isCFC" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a cfc.">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="ancestry" type="string" required="false" default=""/>

		<cfif NOT len(ancestry)>
			<cfset ancestry = buildInheritanceTree( getMetadata(theObject) )>
		</cfif>

		<cfreturn listFindNoCase( ancestry, "WEB-INF.cftags.component" ) GT 0 OR listFindNoCase( ancestry, "railo-context.component" ) GT 0>
	</cffunction>

	<cffunction name="isWheels" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a Wheels object.">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="ancestry" type="string" required="false" default=""/>

		<cfif NOT len(ancestry)>
			<cfset ancestry = buildInheritanceTree( getMetadata(theObject) )>
		</cfif>

		<cfreturn listFindNoCase( ancestry, "models.Wheels" ) GT 0>
	</cffunction>

	<cffunction name="isGroovy" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a Groovy object.">
		<cfargument name="theObject" type="any" required="true" />

		<cfreturn structKeyExists(arguments.theObject,"metaclass") AND isInstanceOf(arguments.theObject.metaclass,"groovy.lang.MetaClassImpl") />

	</cffunction>

	<cffunction name="findGetter" access="public" output="false" returntype="any" hint="I try to locate a property in an object, returning the name of the getter">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="propertyName" type="any" required="true" />

		<cfset var theProp = "" />
		<cfset var theGetter = "" />
		<cfset var metaData = getMetaData( theObject )>
		<!--- using custom build inheritance checking due to significant performance problems with CF's in-build isInstanceOf() --->
		<cfset var ancestry = buildInheritanceTree( metaData )>

		<cfif isWheels(arguments.theObject, ancestry)>
			<cfif structKeyExists(arguments.theObject.properties(),arguments.propertyName)>
				<cfset theGetter = "$propertyvalue('#arguments.propertyName#')" />
			</cfif>
		<cfelseif isCFC(arguments.theObject, ancestry)>
			<cfif (metaData.name contains "structWrapper")>
				<cfset theGetter = "getValue('#arguments.propertyName#')"/>"
			<cfelse>
				<cfif structKeyExists(arguments.theObject,"get" & arguments.propertyName)>
					<cfset theGetter = "get#arguments.propertyName#()" />
				<cfelseif structKeyExists(arguments.theObject,variables.abstractGetterMethod)>
					<cfset theGetter = "#variables.abstractGetterMethod#('#arguments.propertyName#')" />
				<cfelseif structKeyExists(arguments.theObject,"onMissingMethod")>
					<cfset theGetter = "get#arguments.propertyName#()" />
				</cfif>
			</cfif>
		<cfelseif isGroovy(arguments.theObject)>
			<cfset theProp = arguments.theObject.metaclass.hasProperty(arguments.theObject,arguments.propertyName) />
			<cfif isDefined("theProp")>
				<cfset theGetter = theProp.getGetter().getName() & "()" />
			</cfif>
		</cfif>

		<cfreturn theGetter />

	</cffunction>

	<!--- taken from mxunit --->
	<cffunction name="buildInheritanceTree" access="private" returntype="string">
		<cfargument name="metaData"  />
		<cfargument name="accumulator" type="string" required="false" default=""/>

		<cfscript>
			var key = "";

			if( structKeyExists(arguments.metaData,"name") AND listFindNoCase(accumulator,arguments.metaData.name) eq 0 ){
				accumulator =  accumulator & arguments.metaData.name & ",";
			}

			if(structKeyExists(arguments.metaData,"extends")){
				//why, oh why, is the structure different for interfaces vs. extends? For F**k's sake!
				if( structKeyExists( metaData.extends, "name" ) ){
					accumulator = buildInheritanceTree(metaData.extends, accumulator);
				}else{
					accumulator = buildInheritanceTree(metaData.extends[ structKeyList(metaData.extends) ], accumulator);
				}
			}

			if(structKeyExists(arguments.metaData,"implements")){
				for(key in arguments.metaData.implements){
					accumulator = buildInheritanceTree(metaData.implements[ key ], accumulator);
				}
			}

			return  accumulator;
		</cfscript>
	</cffunction>

</cfcomponent>


