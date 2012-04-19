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
<cfcomponent output="false" extends="ValidateThis.core.BaseMetadataProcessor" hint="I am a responsible for reading and processing an annotation.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new XMLFileReader">

		<cfset super.init(argumentCollection=arguments) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="annotationsAreThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		
		<cfargument name="properties" type="array" required="true" />
		
		<cfset var prop = 0 />
		
		<cfloop array="#arguments.properties#" index="prop">
			<cfif structKeyExists(prop,"vtRules") and isThisFormat(prop.vtRules)>
				<cfreturn true />
			</cfif>
		</cfloop>
		<cfreturn false />

	</cffunction>

	<cffunction name="processContexts" returnType="void" access="private" output="false" hint="I translate context annotation metadata into an array to be used by the BaseMetadataProcessor">
		<cfargument name="contexts" type="any" required="true" />
		
		<cfset arguments.contexts = processJSONOrList(arguments.contexts) />
		<cfset super.processContexts(arguments.contexts) />
	</cffunction>

	<cffunction name="processConditions" returnType="void" access="private" output="false" hint="I translate condition annotation metadata into an array to be used by the BaseMetadataProcessor">
		<cfargument name="conditions" type="any" required="true" />
		
		<cfset arguments.conditions = processJSONOrList(arguments.conditions) />
		<cfset super.processConditions(arguments.conditions) />
	</cffunction>

	<cffunction name="processJSONOrList" returnType="array" access="private" output="false" hint="I translate annotation metadata into an array to be used by the BaseMetadataProcessor">
		<cfargument name="theItems" type="any" required="true" />
		
		<cfset var items = [] />
		<cfset var item = "" />
		<cfset var newItem = "" />
		<cfif len(arguments.theItems) gt 0>
			<cfif isJSON(arguments.theItems)>
				<cfset items = deserializeJSON(arguments.theItems) />
				<cfif not isArray(items)>
					<cfthrow type="ValidateThis.core.annotationTypeReaders.BaseAnnotationTypeReader.InvalidJSON" detail="If items are supplied in a json string, they must be in the form of an array of structs." />
				</cfif>
			<cfelse>
				<cfloop list="#arguments.theItems#" index="item">
					<cfset newItem = {} />
					<cfset newItem.name = listFirst(item,"|") />
					<cfif listLen(item,"|") eq 2>
						<!--- context --->
						<cfset newItem.formName = listLast(item,"|") />
					<cfelse>
						<!--- condition --->
						<cfset newItem.serverTest = listGetAt(item,2,"|") />
						<cfset newItem.clientTest = listGetAt(item,3,"|") />
					</cfif>
					<cfset arrayAppend(items,newItem) />
				</cfloop>
			</cfif>
		</cfif>
		<cfreturn items />
	</cffunction>

	<cffunction name="processPropertyDescs" returnType="any" access="private" output="false" hint="I simply pass the call on to my parent">
		<cfargument name="theProperties" type="any" required="true" />
		<cfset super.processPropertyDescs(arguments.theProperties) />
	</cffunction>

	<cffunction name="processPropertyRules" returnType="any" access="private" output="false" hint="I simply pass the call on to my parent">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="theProperties" type="any" required="true" />
		<cfset super.processPropertyRules(arguments.objectType,arguments.theProperties) />
	</cffunction>

	<cffunction name="normalizeValidations" returnType="struct" access="private" output="false" hint="I take the rules and post-process them using other property metadata">
		<cfargument name="allRules" type="struct" required="true" />
		
		<cfreturn arguments.allRules />
	</cffunction>

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I take the metadata and reformat it into a struct">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" hint="the object metadata" />
		
		<cfthrow type="ValidateThis.core.annotationTypeReaders.BaseAnnotationTypeReader.MissingImplementation" detail="The loadRules method must be implemented in a concrete AnnotationTypeReader object" />

	</cffunction>

	<cffunction name="isThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		<cfargument name="annotationValue" type="string" required="true" />
		
		<cfthrow type="ValidateThis.core.annotationTypeReaders.BaseAnnotationTypeReader.MissingImplementation" detail="The isThisFormat method must be implemented in a concrete AnnotationTypeReader object" />
		
	</cffunction>

</cfcomponent>
