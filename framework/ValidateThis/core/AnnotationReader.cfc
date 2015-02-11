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
<cfcomponent output="false" hint="I am a responsible for reading and processing rules in annotations from cfcs.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new annotationReader.">
		<cfargument name="transientFactory" type="any" required="true" />
		<cfargument name="childObjectFactory" type="any" required="true" />
		<cfargument name="extraFileReaderComponentPaths" type="string" required="true" />
		<cfargument name="externalFileTypes" type="string" required="true" />
		<cfargument name="extraAnnotationTypeReaderComponentPaths" type="string" required="true" />
		<cfargument name="vtFolder" type="string" required="true" />

		<cfset variables.transientFactory = arguments.transientFactory />
		<cfset variables.childObjectFactory = arguments.childObjectFactory />
		<cfset variables.extraFileReaderComponentPaths = arguments.extraFileReaderComponentPaths />
		<cfset variables.externalFileTypes = arguments.externalFileTypes />
		<cfset variables.extraAnnotationTypeReaderComponentPaths = arguments.extraAnnotationTypeReaderComponentPaths />
		<cfset variables.vtFolder = arguments.vtFolder />
		
		<cfset setAnnotationTypeReaders() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getObjectMetadata" returnType="struct" access="private" output="false" hint="I return the object metadata from either an object or a component path">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="componentPath" type="any" required="true" />

		<cfif isObject(arguments.theObject)>
			<cfreturn getMetadata(arguments.theObject) />
		<cfelse>
			<cfreturn getComponentMetadata(arguments.componentPath) />
		</cfif>
		
	</cffunction>

	<cffunction name="determineAnnotationFormat" returnType="string" access="private" output="false" hint="I determine the type of annotation used in a property's metadata">
		<cfargument name="properties" type="array" required="true" />

		<cfset var atr = 0 />
		
		<cfloop collection="#variables.annotationTypeReaders#" item="atr">
			<cfif variables.annotationTypeReaders[atr].annotationsAreThisFormat(arguments.properties)>
				<cfreturn atr />
			</cfif>
		</cfloop>
		<cfreturn "" />
		
	</cffunction>

	<cffunction name="loadRulesFromAnnotations" returnType="any" access="public" output="false" hint="I read the validation metadata from external files and reformat it into a struct">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="componentPath" type="any" required="true" />

		<cfset var rulesStruct = {PropertyDescs = StructNew(), ClientFieldDescs = StructNew(), ClientFieldNames = StructNew(), FormContexts = StructNew(), Validations = {Contexts = {___Default = ArrayNew(1)}}} />
		<cfset var md = getObjectMetadata(argumentCollection=arguments) />
		<cfset var annotationFormat = 0 />
		<cfset var annotationTypeReader = 0 />
		<cfif structKeyExists(md,"properties")>
			<cfset annotationFormat = determineAnnotationFormat(md.properties) />
			<cfif len(annotationFormat) gt 1>
				<cfset annotationTypeReader = variables.transientFactory.create("AnnotationTypeReader_" & annotationFormat) />
				<cfset rulesStruct = annotationTypeReader.getValidations(arguments.objectType,md) />
			</cfif>
		</cfif>
		
		<cfreturn rulesStruct />
	</cffunction>

	<cffunction name="setAnnotationTypeReaders" returntype="void" access="private" output="false" hint="I create rule validator objects from a list of component paths">
		<cfset var initArgs = {} />
		<cfset variables.AnnotationTypeReaders = variables.childObjectFactory.loadChildObjects(variables.vtFolder & ".core.annotationTypeReaders,#variables.extraAnnotationTypeReaderComponentPaths#","AnnotationTypeReader_",structNew(),initArgs) />
	</cffunction>
	
</cfcomponent>
	

