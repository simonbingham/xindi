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
<cfcomponent output="false" name="ValidateThis" hint="I accept a BO and use the framework to validate it.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ValidateThis">
		<cfargument name="ValidateThisConfig" type="any" required="false" default="#StructNew()#" />

		<cfset var defaultLocaleMap = {en_US='/ValidateThis/locales/en_US.properties'} />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<!--- Set default values for keys in ValidateThisConfig --->
		<cfparam name="variables.ValidateThisConfig.TranslatorPath" default="ValidateThis.core.BaseTranslator" />
		<cfparam name="variables.ValidateThisConfig.LocaleLoaderPath" default="ValidateThis.core.BaseLocaleLoader" />
		<cfparam name="variables.ValidateThisConfig.BOValidatorPath" default="ValidateThis.core.BOValidator" />
		<cfparam name="variables.ValidateThisConfig.ResultPath" default="ValidateThis.util.Result" />
		<cfparam name="variables.ValidateThisConfig.DefaultJSLib" default="jQuery" />
		<cfparam name="variables.ValidateThisConfig.JSRoot" default="js/" />
		<cfparam name="variables.ValidateThisConfig.defaultFormName" default="frmMain" />
		<cfparam name="variables.ValidateThisConfig.definitionPath" default="/model/" />
		<cfparam name="variables.ValidateThisConfig.localeMap" default="#defaultLocaleMap#" />
		<cfparam name="variables.ValidateThisConfig.defaultLocale" default="en_US" />
		<cfparam name="variables.ValidateThisConfig.abstractGetterMethod" default="getValue" />
		<cfparam name="variables.ValidateThisConfig.ExtraRuleValidatorComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.ExtraClientScriptWriterComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.extraFileReaderComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.externalFileTypes" default="xml,json" />
		<cfparam name="variables.ValidateThisConfig.injectResultIntoBO" default="false" />
		<cfparam name="variables.ValidateThisConfig.JSIncludes" default="true" />
		<cfparam name="variables.ValidateThisConfig.defaultFailureMessagePrefix" default="The " />
		<cfparam name="variables.ValidateThisConfig.BOComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.extraAnnotationTypeReaderComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.debuggingMode" default="none" /><!--- possible values: none|info|strict --->
		<cfparam name="variables.ValidateThisConfig.ajaxProxyURL" default="" /><!--- possible values: any web webservice path that exposes the VT api --->
		<cfparam name="variables.ValidateThisConfig.vtFolder" default="#getVTFolder()#" />
		
		<cfset variables.ValidationFactory = CreateObject("component","core.ValidationFactory").init(variables.ValidateThisConfig) />
		<cfset variables.CommonScriptGenerator = getBean("CommonScriptGenerator") />
		<cfset variables.TransientFactory = getBean("TransientFactory") />
		<cfset variables.TransientFactory.setValidateThis(this) />
		
		<cfset variables.ValidationFactory.createBOVsFromCFCs() />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="false" default="" />
		<cfargument name="definitionPath" type="any" required="false" default="" />
		<cfargument name="theObject" type="any" required="false" default="" />

		<cfset var theObjectType = determineObjectType(argumentCollection=arguments) />
		<cfif len(arguments.definitionPath) EQ 0 AND isObject(arguments.theObject)>
			<cfset arguments.definitionPath = getDirectoryFromPath(getMetadata(arguments.theObject).path) />
		</cfif>
		<cfreturn variables.ValidationFactory.getValidator(theObjectType,arguments.definitionPath,arguments.theObject) />
		
	</cffunction>
	
	<cffunction name="getVTFolder" access="public" output="false" returntype="any" hint="returns the name of the folder in which VT is installed">

		<cfset var thisFolder = getDirectoryFromPath(getCurrentTemplatePath()) />
		<cfreturn listLast(thisFolder,"/\") />

	</cffunction>
	
	<cffunction name="createWrapper" access="public" output="false" returntype="any">
		<cfargument name="theObject" type="any" required="true"/>
		<cfreturn variables.ValidationFactory.createWrapper(arguments.theObject)/>
	</cffunction>
	
	<cffunction name="validate" access="public" output="false" returntype="any">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="objectType" type="any" required="false" default="" />
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="Result" type="any" required="false" default="" />
		<cfargument name="objectList" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="debuggingMode" type="string" required="false" default="#variables.ValidateThisConfig.debuggingMode#" />
		<cfargument name="ignoreMissingProperties" type="boolean" required="false" default="false" />
		<cfargument name="locale" type="string" required="false" default="#variables.ValidateThisConfig.defaultLocale#" />

		<cfset var BOValidator = getValidator(argumentCollection=arguments) />
		
		<cfset arguments.theObject = createWrapper(arguments.theObject)/>

		<cfset arguments.Result = BOValidator.validate(arguments.theObject,arguments.Context,arguments.Result,arguments.objectList,arguments.debuggingMode,arguments.ignoreMissingProperties,arguments.locale) />
		
		<cfreturn arguments.Result />

	</cffunction>
	
	<cffunction name="getInitializationScript" returntype="any" access="public" output="false" hint="I generate JS statements required to setup client-side validations for VT.">
		<cfargument name="JSLib" type="any" required="false" default="#variables.ValidateThisConfig.defaultJSLib#" />
		<cfargument name="JSIncludes" type="Any" required="no" default="#variables.ValidateThisConfig.JSIncludes#" />
		<cfargument name="locale" type="Any" required="no" default="#variables.ValidateThisConfig.defaultLocale#" />
		<cfargument name="format" type="string" required="no" default="script" hint="" />
		
		<cfreturn variables.CommonScriptGenerator.getInitializationScript(argumentCollection=arguments) />

	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="This is used to help communicate with the BOValidator, which is accessed via the ValidationFactory when needed">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var returnValue = "" />
		<cfset var BOValidator = getValidator(argumentCollection=arguments.missingMethodArguments) />

		<cfparam name="arguments.missingMethodArguments.theObject" default="" />
		<cfset arguments.missingMethodArguments.theObject = createWrapper(arguments.missingMethodArguments.theObject) />
		
		<cfinvoke component="#BOValidator#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="returnValue" />

		<cfif NOT IsDefined("returnValue")>
			<cfset returnValue = "" />
		</cfif>
		
		<cfreturn returnValue />
		
	</cffunction>

	<cffunction name="determineObjectType" returntype="any" access="public" output="false" hint="I try to determine the object type by looking at objectType and theObject arguments.">

		<cfset var theObjectType = "" />
		<cfif StructKeyExists(arguments,"objectType") AND Len(arguments.objectType)>
			<cfreturn arguments.objectType />
		<cfelseif StructKeyExists(arguments,"theObject")>
			<cfif IsObject(arguments.theObject)>
				<cfif StructKeyExists(arguments.theObject,"getobjectType")>
					<cfinvoke component="#arguments.theObject#" method="getobjectType" returnvariable="theObjectType" />
				<cfelse>
					<cfset theObjectType = ListLast(getMetaData(arguments.theObject).Name,".") />
				</cfif>
			<cfelseif isStruct(arguments.theObject) and structKeyExists(arguments.theObject,"objectType")>
				<cfset theObjectType = arguments.theObject.objectType />
			</cfif>
		</cfif>
		<cfif NOT IsDefined("theObjectType") OR NOT Len(theObjectType)>
			<cfthrow type="ValidateThis.ValidateThis.ObjectTypeRequired" detail="You must pass either an object type name (via objectType) or an actual object when calling a method on the ValidateThis facade object." />
		</cfif>
		<cfreturn theObjectType />
	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn variables.ValidationFactory.newResult() />
		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

	<cffunction name="evaluateExpression" access="Public" returntype="any" output="false" hint="I dynamically evaluate an expression and return the result.">
		<cfargument name="expression" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.expression)>

	</cffunction>

	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I am used to allow the facade to ask the factory for beans">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfreturn variables.ValidationFactory.getBean(arguments.BeanName) />
	
	</cffunction>
	
	<cffunction name="getVersion" access="public" output="false" returntype="any">
		
		<cfreturn getBean("Version").getVersion() />
				
	</cffunction>
		
	<cffunction name="getValidateThisConfig" access="public" output="false" returntype="any">
        
		<cfreturn variables.ValidateThisConfig />
				
    </cffunction>
	
	<cffunction name="getServerRuleValidators" access="public" output="false" returntype="any">
		<cfargument name="validator" required="false" default=""/>
		<cfreturn variables.ValidationFactory.getServerRuleValidators(argumentCollection=arguments) />
	</cffunction>
	<cffunction name="getSRV" access="public" output="false" returntype="any">
		<cfargument name="validator" required="true"/>
		<cfreturn getServerRuleValidators(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getClientRuleScripters" access="public" output="false" returntype="any">

		<cfreturn variables.ValidationFactory.getClientRuleScripters(variables.ValidateThisConfig.DefaultJSLib) />
		
	</cffunction>
		
	<cffunction name="loadValidators" access="public" output="false" returntype="any">
		<cfargument name="objectList" type="any" required="true"/>
		
		<cfreturn variables.ValidationFactory.loadValidators(objectList)/>
		
	</cffunction>
	
	<cffunction name="clearValidators" access="public" output="false" returntype="void">
		
		<cfset variables.ValidationFactory.clearValidators() />

	</cffunction>
		
	<cffunction name="getValidatorNames" access="public" output="false" returntype="any">

		<cfreturn variables.ValidationFactory.getValidatorNames() />
		
	</cffunction>
		
</cfcomponent>