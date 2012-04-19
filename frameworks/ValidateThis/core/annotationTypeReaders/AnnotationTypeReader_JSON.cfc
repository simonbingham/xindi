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
<cfcomponent output="false" extends="BaseAnnotationTypeReader" hint="I am a responsible for reading and processing a JSON annotation.">

	<cffunction name="isThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		<cfargument name="annotationValue" type="string" required="true" />
		
		<cfif isJSON(arguments.annotationValue)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I take the object metadta and reformat it into private properties">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" hint="the object metadata" />
		<cfset var properties = {}/>
		<cfif structKeyExists(arguments.metadataSource,"vtConditions")>
			<cfset processConditions(arguments.metadataSource.vtConditions) />
		</cfif>
		<cfif structKeyExists(arguments.metadataSource,"vtContexts")>
			<cfset processContexts(arguments.metadataSource.vtContexts) />
		</cfif>
		<cfif structKeyExists(arguments.metadataSource,"properties")>
			<cfset properties = reformatProperties(arguments.metadataSource.properties)>
			<cfset processPropertyDescs(properties) />
			<cfset processPropertyRules(arguments.objectType,properties) />
		</cfif>

	</cffunction>

	<cffunction name="reformatProperties" returnType="array" access="private" output="false" hint="I translate metadata into an array of properties to be used by the BaseMetadataProcessor">
		<cfargument name="properties" type="any" required="true" />
		<cfset var theProperty = 0 />
		<cfset var newProperty = 0 />
		<cfset var theProperties = [] />

		<cfloop array="#arguments.properties#" index="theProperty">
			<cfset newProperty = {name=theProperty.name} />
			<cfif StructKeyExists(theProperty,"vtDesc")>
				<cfset newProperty.desc = theProperty.vtDesc />
			<cfelseif structKeyExists(theProperty,"displayname")>
				<cfset newProperty.desc = theProperty.displayname />
			</cfif>
			<cfif StructKeyExists(theProperty,"vtClientFieldname")>
				<cfset newProperty.clientfieldname = theProperty.vtClientFieldname />
			</cfif>
			<cfif StructKeyExists(theProperty,"vtRules")>
				<cfif isJSON(theProperty.vtRules)>
					<cfset newProperty.rules = deserializeJSON(theProperty.vtRules) />
				<cfelse>
					<cfthrow type="ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_JSON.InvalidJSON" detail="The contents of a vtRules annotation on the #theProperty.name# property (#theProperty.vtRules#) does not contain valid JSON." />
				</cfif>
			</cfif>
			
			<cfset arrayAppend(theProperties,newProperty) />
		</cfloop>
		<cfreturn theProperties />
	</cffunction>

</cfcomponent>
