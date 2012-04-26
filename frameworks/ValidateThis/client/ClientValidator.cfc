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
<cfcomponent displayname="ClientValidator" output="false" hint="I generate client side validations from Business Object validations.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientValidator">
		<cfargument name="childObjectFactory" type="any" required="true" />
		<cfargument name="translator" type="any" required="true" />
		<cfargument name="messageHelper" type="any" required="true" />
		<cfargument name="fileSystem" type="any" required="true" />
		<cfargument name="transientFactory" type="any" required="true" />
		<cfargument name="JSRoot" type="string" required="true" />
		<cfargument name="extraClientScriptWriterComponentPaths" type="string" required="true" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />
		<cfargument name="vtFolder" type="string" required="true" />
		<cfargument name="defaultLocale" type="string" required="true" />

		<cfset variables.childObjectFactory = arguments.childObjectFactory />
		<cfset variables.translator = arguments.translator />
		<cfset variables.messageHelper = arguments.messageHelper />
		<cfset variables.fileSystem = arguments.fileSystem />
		<cfset variables.transientFactory = arguments.TransientFactory />
		<cfset variables.JSRoot = arguments.JSRoot />
		<cfset variables.extraClientScriptWriterComponentPaths = arguments.extraClientScriptWriterComponentPaths />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />
		<cfset variables.vtFolder = arguments.vtFolder />
		<cfset variables.defaultLocale = arguments.defaultLocale />

		<cfset setScriptWriters() />
		<cfreturn this />
	</cffunction>

	<cffunction name="getValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script.">
		<cfargument name="Validations" type="any" required="true" />
		<cfargument name="formName" type="any" required="true" />
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="locale" type="Any" required="no" default="#variables.defaultLocale#" />
		<cfargument name="theObject" type="Any" required="no" default="" />

		<cfset var validation = "" />
		<cfset var theScript = "" />
		<cfset var theScriptWriter = variables.ScriptWriters[arguments.JSLib] />
		<cfset var theVal = variables.TransientFactory.newValidation(theObject=theObject) />
		<cfset var safeFormName = reReplace(arguments.formName,"[\W]","","all") />
		<!--- I hold the fieldnames that have been rendered to improve JS performance --->
		<cfset var fields = StructNew() />
		
		<cfif IsArray(arguments.Validations) and ArrayLen(arguments.Validations)>
			<cfsavecontent variable="theScript">
				<cfoutput>#Trim(theScriptWriter.generateScriptHeader(arguments.formName))#</cfoutput>
				<cfoutput>var fm={};</cfoutput>
				<cfloop Array="#arguments.Validations#" index="validation">
					<cfif validation.processOn NEQ "server">
						<cfset theVal.load(validation) />
						<cfif !StructKeyExists( fields, validation.clientfieldname )>
							<!--- create js reference --->
							<cfoutput>#Trim(theScriptWriter.generateJSFieldRefence(validation.clientfieldname,arguments.formName))#</cfoutput>
							<cfset fm[validation.clientfieldname]="">
						</cfif>
						<cfoutput>#Trim(theScriptWriter.generateValidationScript(theVal,arguments.formName,arguments.locale))#</cfoutput>
					</cfif>
				</cfloop>
				<cfoutput>#Trim(theScriptWriter.generateScriptFooter())#</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<!--- strip whitespace --->
		<cfreturn ReReplace( theScript, "[\n\r\t]", "", "all" ) />

	</cffunction>
	
	<cffunction name="getValidationRulesStruct" returntype="any" access="public" output="false" hint="I generate the client side rules structure.">
		<cfargument name="Validations" type="any" required="true" />
		<cfargument name="formName" type="any" required="true" />
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="locale" type="Any" required="no" default="#variables.defaultLocale#" />
		<cfargument name="theObject" type="Any" required="no" default="" />
		
		<cfset var validation = "" />
		<cfset var theScriptWriter = variables.ScriptWriters[arguments.JSLib] />
		<cfset var theVal = variables.TransientFactory.newValidation(theObject=theObject) />
		<cfset var theJSON = "" />
		<cfset var theCondition = "" />
		<cfset var theArray = [] />
		<cfset var theResult = {} />
		<cfset var message = {} />
		<cfset var key = "" />
		<cfset var clientFieldName = "" />
		<cfset var field = "" />

		<cfset theResult['messages'] = {}/>
		<cfset theResult['rules'] = {}/>
		<cfset theResult['conditions'] = {}/>

		<cfif IsArray(arguments.Validations) and ArrayLen(arguments.Validations)>
			<cfloop Array="#arguments.Validations#" index="validation">
				<cfset theVal.load(validation) />
				<cfset theJSON = listAppend(theJSON,Trim(theScriptWriter.generateValidationJSON(theVal,arguments.locale,arguments.formName)))/>
			</cfloop>
			
			<!--- Wrap validation json as array  --->
			<cfset theJSON = replace("[#theJSON#]",",,",",","all")/>
			
			<!--- Check if generated valid json and deserialize for structure manipulation --->
			<cfif isJSON(theJSON)>
				<cfset theArray = deserializeJSON(theJSON)/>
			<cfelse>
				<cftry>
					<cfset theArray = deserializeJSON(theJSON)/>
					<cfcatch>
						<cfthrow type="validatethis.client.ClientValidator.InvalidJSON" message="Invalid CRS JSON: #theJSON#" />
					</cfcatch>
				</cftry>
			</cfif>
			
			<cfloop array="#theArray#" index="field">
				<cfloop collection="#field#" item="clientFieldName">
					<cfparam name="theResult['messages']['#clientFieldName#']" default="#structNew()#"/>
					<cfparam name="theResult['rules']['#clientFieldName#']" default="#structNew()#"/>
					
					<cfloop collection="#field[clientFieldName]#" item="key">
						<cfif key eq "messages">
							<cfloop collection="#field[clientFieldName][key]#" item="message">
								<cfset structInsert(theResult['messages'][clientFieldName],message,field[clientFieldName][key][message],true)/>
							</cfloop>
						<cfelseif key eq "conditions">
							<cfloop collection="#field[clientFieldName][key]#" item="condition">
								<cfset structInsert(theResult['conditions'],condition,field[clientFieldName][key][condition],true)/>
							</cfloop>
						<cfelse>
							<cfset structInsert(theResult['rules'][clientFieldName],key,field[clientFieldName][key],true)/>
						</cfif>
					</cfloop>
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfreturn theResult />
	</cffunction>
	
	<cffunction name="getGeneratedJavaScript" returntype="any" access="public" output="false" hint="I ask the appropriate client script writer to generate some JS for me.">
		<cfargument name="scriptType" type="any" required="true" hint="Current valid values are JSInclude, Locale and VTSetup." />
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="formName" type="any" required="false" default="" />
		<cfargument name="locale" type="Any" required="no" default="#variables.defaultLocale#" />

		<cfset var theScript = "" />
		<cfinvoke component="#variables.ScriptWriters[arguments.JSLib]#" method="generate#arguments.scriptType#Script" locale="#arguments.locale#" formName="#arguments.formName#" returnvariable="theScript" />
		<cfreturn theScript />

	</cffunction>

	<cffunction name="getScriptWriters" access="public" output="false" returntype="any">
		<cfreturn variables.ScriptWriters />
	</cffunction>

	<cffunction name="setScriptWriters" returntype="void" access="private" output="false" hint="I create script writer objects from a list of component paths">
		
		<cfset var initArgs = {childObjectFactory=variables.childObjectFactory,translator=variables.translator,messageHelper=variables.messageHelper,JSRoot=variables.JSRoot,extraClientScriptWriterComponentPaths=variables.extraClientScriptWriterComponentPaths,defaultFailureMessagePrefix=variables.defaultFailureMessagePrefix,vtFolder=variables.vtFolder} />
		<cfset var thisFolder = getDirectoryFromPath(getCurrentTemplatePath()) />
		<cfset var swDirs = variables.fileSystem.listDirs(thisFolder) />
		<cfset var swDir = 0 />
		<cfset var swPaths = "" />
				
		<cfloop list="#swDirs#" index="swDir">
			<cfset swPaths = listAppend(swPaths, variables.vtFolder & ".client." & swDir) />
		</cfloop>
		<cfset variables.ScriptWriters = variables.childObjectFactory.loadChildObjects(swPaths & "," & variables.extraClientScriptWriterComponentPaths,"ClientScriptWriter_",structNew(),initArgs) />

	</cffunction>

	<cffunction name="getScriptWriter" access="public" output="false" returntype="any">
		<cfargument name="JSLib" type="any" required="true" />
		<cfreturn variables.ScriptWriters[arguments.JSLib] />
	</cffunction>

	<cffunction name="getRuleScripters" access="public" output="false" returntype="any">
		<cfargument name="JSLib" default="#variables.validateThisConfig.DefaultJSLib#" type="any" required="false" />
		
		<cfreturn getScriptWriter(arguments.JSLib).getRuleScripters() />
		
	</cffunction>	

</cfcomponent>

