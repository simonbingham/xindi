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
<cfcomponent output="false" name="BOValidator" hint="I am a validator responsible for holding validation rules for a business object.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new BOValidator">
		<cfargument name="objectType" type="string" required="true" />
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="externalFileReader" type="any" required="true" />
		<cfargument name="annotationReader" type="any" required="true" />
		<cfargument name="ServerValidator" type="any" required="true" />
		<cfargument name="ClientValidator" type="any" required="true" />
		<cfargument name="TransientFactory" type="any" required="true" />
		<cfargument name="CommonScriptGenerator" type="any" required="true" />
		<cfargument name="Version" type="any" required="true" />
		<cfargument name="defaultFormName" type="string" required="true" />
		<cfargument name="defaultJSLib" type="string" required="true" />
		<cfargument name="JSIncludes" type="string" required="true" />
		<cfargument name="definitionPath" type="string" required="true" />
		<cfargument name="specificDefinitionPath" type="string" required="true" />
		<cfargument name="theObject" type="any" required="true" hint="The object from which to read annotations, a blank means no object was passed" />
		<cfargument name="componentPath" type="any" required="true" hint="The component path to the object - used to read annotations using getComponentMetadata" />
		<cfargument name="debuggingMode" type="string" required="true" hint="The debuggingMode from the VTConfig struct" />
		<cfargument name="defaultLocale" type="string" required="true" hint="The defaultLocale for the resource bundle" />

		<cfset variables.instance = {objectType = arguments.objectType, propertyDescs = {}, clientFieldDescs = {}, ClientFieldNames = {}, formContexts = {}, validations = {contexts = {___Default = arrayNew(1)}}, newRules = {}} />
		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.externalFileReader = arguments.externalFileReader />
		<cfset variables.annotationReader = arguments.annotationReader />
		<cfset variables.ServerValidator = arguments.ServerValidator />
		<cfset variables.ClientValidator = arguments.ClientValidator />
		<cfset variables.TransientFactory = arguments.TransientFactory />
		<cfset variables.defaultFormName = arguments.defaultFormName />
		<cfset variables.defaultJSLib = arguments.defaultJSLib />
		<cfset variables.JSIncludes = arguments.JSIncludes />
		<cfset variables.CommonScriptGenerator = arguments.CommonScriptGenerator />
		<cfset variables.Version = arguments.Version />
		<cfset variables.debuggingMode = arguments.debuggingMode />
		<cfset variables.defaultLocale = arguments.defaultLocale />

		<!--- Prepend a specified definitionPath to the paths in the ValidateThisConfig --->
		<cfset variables.definitionPath = listPrepend(arguments.definitionPath,arguments.specificDefinitionPath) />
		
		<cfif isObject(arguments.theObject) or len(arguments.componentPath) gt 0>
			<cfset loadRulesFromAnnotations(arguments.objectType,arguments.theObject,arguments.componentPath) />
		</cfif>
		
		<cfset loadRulesFromExternalFile(arguments.objectType,variables.definitionPath) />
		<cfset variables.instance.requiredPropertiesAndFields = determineRequiredPropertiesAndFields() />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="loadRulesFromAnnotations" returnType="void" access="private" output="false" hint="I ask the externalFileReader to read the validations XML file and reformat it into a struct">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="componentPath" type="any" required="true" />

		<cfset var theStruct = variables.annotationReader.loadRulesFromAnnotations(objectType=arguments.objectType,theObject=arguments.theObject,componentPath=arguments.componentPath) />
		<cfset loadRulesFromStruct(theStruct) />
		
	</cffunction>

	<cffunction name="loadRulesFromExternalFile" returnType="void" access="private" output="false" hint="I ask the externalFileReader to read the validations XML file and reformat it into a struct">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />

		<cfset var theStruct = variables.externalFileReader.loadRulesFromExternalFile(objectType=arguments.objectType,definitionPath=arguments.definitionPath) />
		<cfset loadRulesFromStruct(theStruct) />
		
	</cffunction>

	<cffunction name="loadRulesFromStruct" returnType="void" access="public" output="false" hint="I take a struct of validation data and call addrule for each validation">
		<cfargument name="theStruct" type="struct" required="true" />
		
		<cfset var context = 0 />
		<cfset var rule = 0 />

		<cfset structAppend(variables.instance.propertyDescs,theStruct.propertyDescs) />
		<cfset structAppend(variables.instance.clientFieldDescs,theStruct.clientFieldDescs) />
		<cfset structAppend(variables.instance.clientFieldNames,theStruct.clientFieldNames) />
		<cfset structAppend(variables.instance.formContexts,theStruct.formContexts) />
		
		<cfif structKeyExists(arguments.theStruct,"validations") and structKeyExists(arguments.theStruct.validations,"contexts")>
			<cfloop collection="#arguments.theStruct.validations.contexts#" item="context">
				<cfloop array="#arguments.theStruct.validations.contexts[context]#" index="rule">
					<cfset addRule(argumentCollection=rule,contexts=context) />
				</cfloop>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="determineRequiredPropertiesAndFields" access="private" output="false" returntype="any">
		<cfset var contexts = getAllContexts() />
		<cfset var context = 0 />
		<cfset var validation = 0 />
		<cfset var contextStruct = {} />
		<cfloop collection="#contexts#" item="context">
			<cfset contextStruct[context] = {properties=structNew(),fields=structNew()} />
			<cfloop array="#contexts[context]#" index="validation">
				<cfif validation.ValType EQ "required" AND StructIsEmpty(validation.Parameters) AND StructIsEmpty(validation.Condition)>
					<cfset contextStruct[context]["properties"][validation.PropertyName] = "required" />
					<cfset contextStruct[context]["fields"][validation.ClientFieldName] = "required" />
				</cfif>
			</cfloop>
		</cfloop>
		<cfreturn contextStruct />
	</cffunction>
	
	<cffunction name="addRule" returnType="void" access="public" output="false" hint="I am used to add a rule via CF code">
		<cfargument name="propertyName" type="any" required="true" />
		<cfargument name="valType" type="any" required="true" />
		<cfargument name="clientFieldName" type="any" required="false" default="#arguments.propertyName#" />
		<cfargument name="propertyDesc" type="any" required="false" default="#determineLabel(arguments.propertyName)#" />
		<cfargument name="condition" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="parameters" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="contexts" type="any" required="false" default="" />
		<cfargument name="failureMessage" type="any" required="false" default="" />
		<cfargument name="formName" type="any" required="false" default="" />
		
		<cfset var theRule = Duplicate(arguments) />
		<cfset var theContext = 0 />
		<cfset var ruleHash = getHashFromStruct(theRule) />
		
		<cfif NOT StructKeyExists(variables.instance.newRules,ruleHash)>
			<cfset structDelete(theRule,"contexts",false) />
			<cfset structDelete(theRule,"formName",false) />
			<cflock name="#ruleHash#" type="exclusive" timeout="10" throwontimeout="true">
				<cfif NOT StructKeyExists(variables.instance.newRules,ruleHash)>
					<cfset variables.instance.newRules[ruleHash] = 1 />
					<cfif theRule.propertyDesc neq theRule.propertyName>
						<cfif NOT StructKeyExists(variables.instance.propertyDescs,theRule.propertyName)>
							<cfset variables.instance.propertyDescs[theRule.propertyName] = theRule.propertyDesc />
						</cfif>
					<cfelseif StructKeyExists(variables.instance.propertyDescs,theRule.propertyName)>
						<cfset theRule.propertyDesc = variables.instance.propertyDescs[theRule.propertyName] />
					<cfelse>
						<cfset theRule.propertyDesc = determineLabel(theRule.propertyName)/>
                        <cfset variables.instance.propertyDescs[theRule.propertyName] = theRule.propertyDesc/>
					</cfif>
					<cfif NOT StructKeyExists(variables.instance.clientFieldDescs,theRule.clientFieldName)>
						<cfset variables.instance.clientFieldDescs[theRule.clientFieldName] = theRule.propertyDesc />
					</cfif>
					<cfif Len(arguments.contexts) AND NOT ListFindNoCase(arguments.contexts,"*")>
						<cfloop list="#arguments.contexts#" index="theContext">
							<cfif NOT StructKeyExists(variables.instance.Validations.Contexts,theContext)>
								<cfset variables.instance.Validations.Contexts[theContext] = ArrayNew(1) />
							</cfif>
							<cfset ArrayAppend(variables.instance.Validations.Contexts[theContext],theRule) />
							<cfif NOT StructKeyExists(variables.instance.formContexts,theContext) AND Len(arguments.formName)>
								<cfset variables.instance.formContexts[theContext] = arguments.formName />
							</cfif>
						</cfloop>
					<cfelse>
						<cfloop collection="#variables.instance.Validations.Contexts#" item="theContext">
							<cfset ArrayAppend(variables.instance.Validations.Contexts[theContext],theRule) />
						</cfloop>
					</cfif>
				</cfif>
			</cflock>
		</cfif>		

	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn variables.TransientFactory.newResult() />
		
	</cffunction>

	<cffunction name="newBusinessObjectWrapper" returntype="any" access="public" output="false" hint="I create a BusinessObjectWrapper object.">
		<cfargument name="theObject" type="any" required="yes" />

		<cfreturn variables.TransientFactory.newBusinessObjectWrapper(arguments.theObject) />
		
	</cffunction>
	
	<cffunction name="validate" returntype="any" access="public" output="false" 
		hint="I perform the validations using the Server Validator, returning info in the result object.">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="Result" type="any" required="false" default="" />
		<cfargument name="objectList" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="debuggingMode" type="string" required="false" default="#variables.debuggingMode#" />
		<cfargument name="ignoreMissingProperties" type="boolean" required="false" default="false" />
		<cfargument name="locale" type="string" required="false" default="#variables.defaultLocale#" />

		<cfif IsSimpleValue(arguments.Result)>
			<cfset arguments.Result = newResult() />
		</cfif>
		<!--- Put the object into the result so it can be retrieved from there --->
		<cfset arguments.Result.setTheObject(arguments.theObject) />
		<cfset variables.ServerValidator.validate(this,arguments.theObject,arguments.Context,arguments.Result,arguments.objectList,arguments.debuggingMode,arguments.ignoreMissingProperties,arguments.locale) />
		<cfreturn arguments.Result />
		
	</cffunction>

	<cffunction name="getValidationScript" returntype="any" access="public" output="false" 
		hint="I generate the JS using the Client Validator script.">
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="formName" type="any" required="false" default="#getFormName(arguments.Context)#" hint="The name of the form for which validations are being generated." />
		<cfargument name="JSLib" type="any" required="false" default="#variables.defaultJSLib#" />
		<cfargument name="locale" type="Any" required="no" default="#variables.defaultLocale#" />
		<cfargument name="theObject" type="Any" required="no" default="" />

		<cfreturn variables.ClientValidator.getValidationScript(getValidations(arguments.Context),arguments.formName,arguments.JSLib,arguments.locale,arguments.theObject) />

	</cffunction>
	
	<cffunction name="getValidationRulesStruct" returntype="any" access="public" output="false" hint="I generate the JS using the Client Validator script.">
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="formName" type="any" required="false" default="#getFormName(arguments.Context)#" hint="The name of the form for which validations are being generated." />
		<cfargument name="JSLib" type="any" required="false" default="#variables.defaultJSLib#" />
		<cfargument name="locale" type="Any" required="no" default="#variables.defaultLocale#" />
		<cfargument name="theObject" type="Any" required="no" default="" />

		<cfreturn variables.ClientValidator.getValidationRulesStruct(getValidations(arguments.Context),arguments.formName,arguments.JSLib,arguments.locale,arguments.theObject) />

	</cffunction>

	<cffunction name="getInitializationScript" returntype="any" access="public" output="false" hint="I generate JS statements required to setup client-side validations for VT.">

		<cfargument name="JSLib" type="any" required="false" default="#variables.defaultJSLib#" />
		<cfargument name="JSIncludes" type="Any" required="no" default="#variables.JSIncludes#" />
		<cfargument name="locale" type="Any" required="no" default="#variables.defaultLocale#" />

		<cfreturn variables.CommonScriptGenerator.getInitializationScript(argumentCollection=arguments) />

	</cffunction>

	<cffunction name="getValidations" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="false" default="" />
		
		<cfset var theContext = fixDefaultContext(arguments.Context) />
		
		<cfreturn variables.instance.Validations.Contexts[theContext] />
	</cffunction>

	<cffunction name="getFormName" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="true" />
		
		<cfset var formName = variables.defaultFormName />
		<cfif StructKeyExists(variables.instance.formContexts,arguments.Context)>
			<cfset formName = variables.instance.formContexts[arguments.Context] />
		</cfif>
		<cfreturn formName />
	</cffunction>

	<cffunction name="getValidationPropertyDescs" access="public" output="false" returntype="any">
		<cfreturn variables.instance.propertyDescs />
	</cffunction>
	
	<cffunction name="getPropertyDescription" access="public" output="false" returntype="string" hint="Returns the descriptive name of a property">
		<cfargument name="propertyName" required="true" type="string" />
		<cfif structKeyExists(variables.instance.propertyDescs,arguments.propertyName)>
			<cfreturn variables.instance.propertyDescs[arguments.propertyName] />
		</cfif>
		<cfreturn determineLabel(arguments.propertyName) />
	</cffunction>
	
	<cffunction name="getClientFieldName" access="public" output="false" returntype="string" hint="Returns the clientFieldName of a property">
		<cfargument name="propertyName" required="true" type="string" />
		<cfif not structKeyExists(variables.instance.clientFieldNames,arguments.propertyName)>
			<cfthrow type="validatethis.core.BOValidator.missingPropertyName" message="The property: #arguments.propertyName# is not defined for this object." >
		</cfif>
		<cfreturn variables.instance.clientFieldNames[arguments.propertyName] />
	</cffunction>
	
	<cffunction name="getRequiredPropertiesAndDescs" access="public" output="false" returntype="any">
		<cfargument name="context" required="false" type="string" default="">
		<cfset var RequiredPropertyDescs = {}/>
		<cfset var requiredFields = this.getRequiredProperties(arguments.context)/>
		<cfset var propertyDescs = this.getValidationPropertyDescs()>
		<cfset var name = "" />
		
		<cfloop list="#structKeyList(requiredFields)#" index="name">
			<cfset StructInsert(RequiredPropertyDescs,name,propertyDescs[name])>
		</cfloop>
		
		<cfreturn RequiredPropertyDescs />
		
	</cffunction>
		
	<cffunction name="getValidationClientFieldDescs" access="public" output="false" returntype="any">
		<cfreturn variables.instance.clientFieldDescs />
	</cffunction>
	
	<cffunction name="getValidationFormContexts" access="public" output="false" returntype="any">
		<cfreturn variables.instance.formContexts />
	</cffunction>
	
	<cffunction name="getAllContexts" access="public" output="false" returntype="any">
		<cfreturn variables.instance.Validations.Contexts />
	</cffunction>

	<cffunction name="getRequiredProperties" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="false" default="" />
		<cfreturn variables.instance.requiredPropertiesAndFields[fixDefaultContext(arguments.Context)].properties />
	</cffunction>
	
	<cffunction name="getRequiredFields" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="false" default="" />
		<cfreturn variables.instance.requiredPropertiesAndFields[fixDefaultContext(arguments.Context)].fields />
	</cffunction>
	
	<cffunction name="fixDefaultContext" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="true" />
		<cfif NOT Len(arguments.Context) OR arguments.Context EQ "*" OR NOT StructKeyExists(variables.instance.Validations.Contexts,arguments.Context)>
			<cfreturn "___Default" />
		<cfelse>
			<cfreturn arguments.Context />
		</cfif>
	</cffunction>
	
	<cffunction name="getHashFromStruct" access="public" output="false" returntype="any">
		<cfargument name="args" type="struct" required="true" />

		<cfset var arg = 0 />
		<cfset var argList = "" />

		<cfloop list="#ListSort(StructKeyList(arguments.args),'Text')#" index="arg">
			<cfif IsSimpleValue(arguments.args[arg])>
				<cfset argList = argList & arguments.args[arg] />
			</cfif>
		</cfloop>		

		<cfreturn Hash(argList) />
	</cffunction>
	
	<cffunction name="determineScriptType" returntype="any" access="public" output="false" hint="I try to determine the script type by looking at the missing method name.">
		<cfargument name="methodName" type="any" required="true" />

		<cfif Left(arguments.methodName,3) EQ "get" AND Right(arguments.methodName,6) EQ "Script">
			<cfreturn Mid(arguments.methodName,4,Len(arguments.methodName)-9) />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="determineFormName" returntype="any" access="public" output="false" hint="I try to determine the form name by looking at the missing method arguments.">
		<cfargument name="theArguments" type="any" required="true" />
		
		<cfif StructKeyExists(arguments.theArguments,"formName") AND Len(arguments.theArguments.formName)>
			<cfreturn arguments.theArguments.formName />
		<cfelseif StructKeyExists(arguments.theArguments,"Context")>
			<cfreturn getFormName(arguments.theArguments.Context) />
		<cfelse>
			<cfreturn getFormName("") />
		</cfif>
	</cffunction>

	<cffunction name="determineLocale" returntype="any" access="public" output="false" hint="I try to determine the locale by looking at the missing method arguments.">
		<cfargument name="theArguments" type="any" required="true" />
		
		<cfif StructKeyExists(arguments.theArguments,"locale")>
			<cfreturn arguments.theArguments.locale />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="propertyIsRequired" returntype="boolean" access="public" output="false" hint="I determine whether a property is required.">
		<cfargument name="propertyName" type="any" required="yes" hint="The name of the property." />
		<cfargument name="Context" type="any" required="false" default="" />

		<cfreturn structKeyExists(variables.instance.requiredPropertiesAndFields[fixDefaultContext(arguments.Context)].properties,arguments.propertyName) />
	
	</cffunction>

	<cffunction name="fieldIsRequired" returntype="boolean" access="public" output="false" hint="I determine whether a field is required.">
		<cfargument name="fieldName" type="any" required="yes" hint="The name of the property." />
		<cfargument name="context" type="any" required="false" default="" />

		<cfreturn structKeyExists(variables.instance.requiredPropertiesAndFields[fixDefaultContext(arguments.Context)].fields,arguments.fieldName) />
	
	</cffunction>

	<cffunction name="getVersion" returnType="any" output="false" hint="I report the current version of the framework">
		<cfreturn variables.Version.getVersion() />
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="This is used to eliminate the need for duplicate methods which all just pass calls on to the Client Validator.">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var scriptType = determineScriptType(arguments.missingMethodName) />
		<cfif Len(scriptType)>
			<cfreturn variables.ClientValidator.getGeneratedJavaScript(scriptType=scriptType,JSLib=arguments.missingMethodArguments.JSLib,formName=determineFormName(arguments.missingMethodArguments),locale=determineLocale(arguments.missingMethodArguments)) />
		<cfelse>
			<cfthrow type="ValidateThis.core.BOValidator.MethodNotDefined" detail="The method #arguments.missingMethodName# does not exist in the BOValidator object." />
		</cfif>
		
	</cffunction>
	
	<cffunction name="determineLabel" returntype="string" output="false" access="private">
	<cfargument name="label" type="string" required="true" />
	
	<!--- Note: this is a stop-gap measure to put this functionality in place. 
		The whole metadata population system will be refactored soon. --->
	
	<cfset var i = "" />
	<cfset var char = "" />
	<cfset var result = "" />
	
	<cfloop from="1" to="#len(arguments.label)#" index="i">
		<cfset char = mid(arguments.label, i, 1) />
		
		<cfif i eq 1>
			<cfset result = result & ucase(char) />
		<cfelseif asc(lCase(char)) neq asc(char)>
			<cfset result = result & " " & ucase(char) />
		<cfelse>
			<cfset result = result & char />
		</cfif>
	</cfloop>

	<cfreturn result />	
	</cffunction>

	<cffunction name="getObjectType" returntype="any" access="public" output="false" hint="I get the BOValidator Object type.">

		<cfreturn variables.Instance.objectType />

	</cffunction>

</cfcomponent>
	

