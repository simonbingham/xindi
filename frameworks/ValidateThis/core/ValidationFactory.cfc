<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" hint="I am _the_ factory object for ValidateThis, I also create BO Validators for the framework.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ValidationFactory">
		<cfargument name="ValidateThisConfig" type="struct" required="true" />

		<cfset var lwConfig = createObject("component","ValidateThis.util.BeanConfig").init(arguments.ValidateThisConfig) />
		<cfset variables.lwFactory = createObject("component","ValidateThis.util.LightWire").init(lwConfig) />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<cfset variables.Validators = StructNew() />

		<cfreturn this />
	</cffunction>

	<cffunction name="createBOVsFromCFCs" access="public" output="false" returntype="void" hint="I create BOVs from annotated CFCs">
		
		<cfset var fileSystem = getBean("fileSystem") />
		<cfset var BOComponentPath = ""/>
		<cfset var actualPath = ""/>
		<cfset var cfcNames = "" />
		<cfset var cfc = "" />
		<cfset var componentPath = ""/>
		<cfset var objectType = "" />
		<cfset var md = "" />
		
		<cfloop list="#variables.ValidateThisConfig.BOComponentPaths#" index="BOComponentPath">
			<cfset actualPath = fileSystem.getMappingPath(BOComponentPath) />
			<cfset cfcNames = fileSystem.listRelativeFilePaths(actualPath,"*.cfc",true)/>
			<cfloop list="#cfcNames#" index="cfc">
				<cfset componentPath = BOComponentPath & replace(replaceNoCase(cfc,".cfc","","last"),"/",".","all") />
				<cfset objectType = listLast(componentPath,".") />
				<cfset md = getComponentMetadata(componentPath) />
				
				<!--- TODO: Now we need to call getValidator --->
				<cfset getValidator(objectType=listLast(componentPath,"."),componentPath=componentPath,definitionPath=getDirectoryFromPath(fileSystem.getMappingPath(componentPath))) />
				<!---
				<cfif ListLast(obj,".") EQ "cfc" AND obj CONTAINS arguments.fileNamePrefix>
					<cfset arguments.childCollection[replaceNoCase(ListLast(obj,"_"),".cfc","")] = CreateObject("component",componentPath & ReplaceNoCase(obj,".cfc","")).init(argumentCollection=arguments.initArguments) />
				</cfif>
				--->
			</cfloop>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I return a singleton">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfif arguments.BeanName neq "ValidationFactory">
			<cfreturn variables.lwFactory.getSingleton(arguments.BeanName) />
		</cfif>
		<cfreturn this />
	
	</cffunction>
	
	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="false" default="" />
		<cfargument name="theObject" type="any" required="false" default="" hint="The object from which to read annotations" />
		<cfargument name="componentPath" type="any" required="false" default="" hint="The component path to the object - used to read annotations using getComponentMetadata" />

		<cfset var md = "" />
		<cfset var altPath = "" />

		<cfif NOT StructKeyExists(variables.Validators,arguments.objectType)>
			<cfif isObject(arguments.theObject)>
				<cfset md = getMetaData(theObject) />
				<cfset altPath = replace(md.fullname, ".", "/", "all") />
				<cfset altPath = listDeleteAt(altPath, listLen(altPath, "/"), "/") />
				<cfset altPath = variables.ValidateThisConfig.definitionPath & "/" & altPath />
				<cfset arguments.definitionPath = listAppend(arguments.definitionPath, altPath) />
			</cfif>			
			<cfset variables.Validators[arguments.objectType] = createValidator(argumentCollection=arguments) />
		</cfif>
		<cfreturn variables.Validators[arguments.objectType] />
		
	</cffunction>
	
	<cffunction name="createValidator" returntype="any" access="private" output="false">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" hint="The object from which to read annotations, a blank means no object was passed" />
		<cfargument name="componentPath" type="any" required="true" hint="The component path to the object - used to read annotations using getComponentMetadata" />
		
		<cflock type="exclusive" timeout="5" throwontimeout="true" name="#arguments.objectType#">
			<cfreturn CreateObject("component",variables.ValidateThisConfig.BOValidatorPath).init(arguments.objectType,getBean("FileSystem"),
				getBean("externalFileReader"),getBean("annotationReader"),getBean("ServerValidator"),getBean("ClientValidator"),getBean("TransientFactory"),
				getBean("CommonScriptGenerator"),getBean("Version"),
				variables.ValidateThisConfig.defaultFormName,variables.ValidateThisConfig.defaultJSLib,variables.ValidateThisConfig.JSIncludes,variables.ValidateThisConfig.definitionPath,
				arguments.definitionPath,arguments.theObject,arguments.componentPath,variables.ValidateThisConfig.debuggingMode,variables.ValidateThisConfig.defaultLocale) />
		</cflock>

	</cffunction>
	
	<cffunction name="createWrapper" returntype="any" access="public" output="false">
		<cfargument name="theObject" type="any" required="true" />
		
		<!--- Notes for Java/Groovy objects:
			If you're using Groovy, 
			you will need to write your own testCondition method into your BOs. You may consider doing this 
			by adding the method to a base BO class. I am not certain this can even be done in Java, as I do 
			not believe Java supports runtime evaluation. --->
			
		<cfif not isObject(arguments.theObject)>
			<cfset arguments.theObject = getBean("TransientFactory").newStructWrapper(arguments.theObject) />
			<cfreturn arguments.theObject/>
		</cfif>
		
		<!--- Inject testCondition & evaluateExpression if needed --->
		<cfif getBean("ObjectChecker").isCFC(arguments.theObject)>
			<cfif NOT StructKeyExists(arguments.theObject,"testCondition")>
				<cfset arguments.theObject["testCondition"] = this["testCondition"] />
			</cfif>
			<cfif NOT StructKeyExists(arguments.theObject,"evaluateExpression")>
				<cfset arguments.theObject["evaluateExpression"] = this["evaluateExpression"] />
			</cfif>
		</cfif>
		
		<cfreturn arguments.theObject/>
	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn getBean("TransientFactory").newResult() />
		
	</cffunction>

	<cffunction name="getServerRuleValidators" access="public" output="false" returntype="any">
		<cfargument name="validator" required="false" default=""/>
		<cfif len(arguments.validator) gt 0>
			<cfreturn getBean("ServerValidator").getRuleValidator(arguments.validator) />
		<cfelse>
			<cfreturn getBean("ServerValidator").getRuleValidators() />
		</cfif>
	</cffunction>

	<cffunction name="getClientRuleScripters" access="public" output="false" returntype="any">
		<cfargument name="JSLib" type="any" required="true"/>
		
		<cfreturn getBean("ClientValidator").getRuleScripters(arguments.JSLib) />
	
	</cffunction>
    
	<cffunction name="loadValidators" access="public" output="false" returntype="any">
		<cfargument name="objectList" type="any" required="true"/>
		
		<cfset var list = [] />
		<cfset var obj = "" />
		<cfset var name = "" />
		<cfset var objectType = "" />
		
		<cfif isSimpleValue(arguments.objectList)>
				<cfif (listLen(arguments.objectList) gt 1)>
					<cfloop list="#arguments.objectList#" index="obj">
						<cfset ArrayAppend(list,obj)/>
					</cfloop>
				<cfelse>
					<cfset ArrayAppend(list,arguments.objectList)/>
				</cfif>
		<cfelseif isStruct(arguments.objectList)>
			<cfscript>
				for (obj in arguments.objectList){
					ArrayAppend(list,obj);
				}
			</cfscript>
			
		<cfelseif isArray(arguments.objectList)>
			<cfset list = arguments.objectList/>
		<cfelse>
			<cfset list[0] = arguments.objectList>
		</cfif>
		
		<cfif isArray(list)>
			<cfloop array="#list#" index="objectType">
				<cfif isStruct(objectType)>
					<cfset name = listLast(getMetadata(objectType).name,".")>
					<cfset getValidator(objectType=name,theObject=objectType)/>
				<cfelseif isSimpleValue(objectType)>
					<cfset getValidator(objectType=objectType)/>
				</cfif>
		   </cfloop>
	   </cfif>
	   
	   <cfreturn getValidatorNames()/>
	   
    </cffunction>
    
	<cffunction name="clearValidators" access="public" output="false" returntype="void">

			<cfset variables.Validators = StructNew() />
			
	</cffunction>
	
	<cffunction name="getValidatorNames" access="public" output="false" returntype="any">
		
		<cfset var result = []/>
		<cfset var validatorName = "" />
		
		<cfloop collection="#variables.Validators#" item="validatorName">
			<cfset arrayAppend(result,validatorName)/>
		</cfloop>
		
		<cfreturn result/>
		
	</cffunction>	
	
	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="FOR MIXIN USE - I am here to dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>
	
	<cffunction name="evaluateExpression" access="Public" returntype="any" output="false" hint="I dynamically evaluate an expression and return the result.">
		<cfargument name="expression" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.expression)>

	</cffunction>
</cfcomponent>