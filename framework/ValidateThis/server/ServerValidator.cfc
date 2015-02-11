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
<cfcomponent displayname="ServerValidator" output="false" hint="I orchestrate server side validations.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ServerValidator">
		<cfargument name="childObjectFactory" type="any" required="true" />
		<cfargument name="TransientFactory" type="any" required="true" />
		<cfargument name="ObjectChecker" type="any" required="true" />
		<cfargument name="EqualsHelper" type="any" required="true" />
		<cfargument name="messageHelper" type="any" required="true" />
		<cfargument name="ExtraRuleValidatorComponentPaths" type="string" required="true" />
		<cfargument name="injectResultIntoBO" type="string" required="true" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />
		<cfargument name="vtFolder" type="string" required="true" />
		<cfargument name="defaultLocale" type="string" required="true" />
		
		<cfset variables.childObjectFactory = arguments.childObjectFactory />
		<cfset variables.TransientFactory = arguments.TransientFactory />
		<cfset variables.ObjectChecker = arguments.ObjectChecker />
		<cfset variables.EqualsHelper = arguments.EqualsHelper />
		<cfset variables.messageHelper = arguments.messageHelper />
		<cfset variables.ExtraRuleValidatorComponentPaths = arguments.ExtraRuleValidatorComponentPaths />
		<cfset variables.injectResultIntoBO = arguments.injectResultIntoBO />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />
		<cfset variables.vtFolder = arguments.vtFolder />
		<cfset variables.defaultLocale = arguments.defaultLocale />

		<cfset setRuleValidators() />
				
		<cfreturn this />
	</cffunction>

	<cffunction name="validate" returntype="void" access="public" output="false" hint="I perform the validation returning info in the result object.">
		<cfargument name="BOValidator" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="Context" type="any" required="true" />
		<cfargument name="Result" type="any" required="true" />
		<cfargument name="objectList" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="debuggingMode" type="string" required="false" default="#arguments.Result.getDebuggingMode()#" />
		<cfargument name="ignoreMissingProperties" type="boolean" required="false" default="false" />
		<cfargument name="locale" type="string" required="false" default="#variables.defaultLocale#" />
		<cfargument name="injectResultIntoBO" type="boolean" default="#variables.injectResultIntoBO#" />

		<cfset var v = "" />
		<cfset var theFailure = 0 />
		<cfset var FailureMessage = 0 />
		<cfset var Validations = arguments.BOValidator.getValidations(arguments.Context) />
		<cfset var theVal = variables.TransientFactory.newValidation(arguments.theObject,arguments.objectList) />
		<cfset var dependentPropertyExpression = 0 />
		<cfset var dependentPropertyValue = "" />
		<cfset var conditionPasses = true />
		<cfset var isObject = variables.ObjectChecker.isCFC(arguments.theObject) />
		<cfset var classname = "struct" />
		
		<cfif arguments.debuggingMode neq "none" AND isObject>
			<!--- for performance, only inspect metadata to get classname if debugging is enabled --->
			<cfset classname = GetMetaData( arguments.theObject ).name />
		</cfif>
		
		<cfif not variables.equalsHelper.isInArray(arguments.theObject,arguments.objectList)>
			<cfset arrayAppend(arguments.objectList, arguments.theObject) />

			<cfif IsArray(Validations) and ArrayLen(Validations)>
				<!--- Loop through the validations array, creating validation objects and using them --->
				<cfloop Array="#Validations#" index="v">
					<cfif v.processOn NEQ "client">
						<cfset theVal.load(v) />
						<!--- we only need to check if the property exists if the validation type IS NOT custom --->
						<cfif v.ValType EQ "custom" OR theVal.propertyExists()>
							<cfset conditionPasses = true />
							<!--- Deal with various conditions --->
							<cfif StructKeyExists(v.Condition,"ServerTest")>
								<cfset conditionPasses = arguments.theObject.testCondition(v.Condition.ServerTest) />
							<cfelseif StructKeyExists(v.Parameters,"DependentPropertyName")>
								<cfset dependentPropertyExpression = variables.ObjectChecker.findGetter(arguments.theObject,theVal.getParameterValue("DependentPropertyName")) />
								<cfset dependentPropertyValue = evaluate("arguments.theObject.#dependentPropertyExpression#") />
								<cfif not isDefined("dependentPropertyValue")>
									<cfset dependentPropertyValue = "" />
								</cfif>
								<cfif StructKeyExists(v.Parameters,"DependentPropertyValue")>
									<cfset conditionPasses = dependentPropertyValue EQ theVal.getParameterValue("DependentPropertyValue") />
								<cfelse>
									<cfset conditionPasses = len(dependentPropertyValue) GT 0 />
								</cfif>
							</cfif>
							<cfif conditionPasses>
								<cfset theVal.setIsRequired(arguments.BOValidator.propertyIsRequired(v.PropertyName)) />
								<cfset variables.RuleValidators[v.ValType].validate(theVal,arguments.locale) />
								<cfif NOT theVal.getIsSuccess()>
									<cfset arguments.Result.setIsSuccess(false) />
									<cfif not theVal.hasResult()>
										<cfset theFailure = StructNew() />
										<cfset theFailure.PropertyName = v.PropertyName />
										<cfset theFailure.ClientFieldName = v.ClientFieldName />
										<cfset theFailure.Type = v.ValType />
										<cfset theFailure.Message = determineFailureMessage(v,theVal) />
										<cfset theFailure.theObject = arguments.theObject />
										<cfset theFailure.objectType = arguments.BOValidator.getObjectType() />
										<cfset arguments.Result.addFailure(theFailure) />
									<cfelse>
										<cfset arguments.Result.addResult(theVal.getResult()) />
									</cfif>
								</cfif>
							</cfif>
							
							<cfif arguments.debuggingMode neq "none">
								<cfset arguments.Result.logCriteriaOutcome(classname=classname, context=arguments.context, criteria=v, passed=theVal.getIsSuccess()) />
							</cfif>
						<cfelseif NOT arguments.ignoreMissingProperties>
							<cfthrow type="ValidateThis.core.serverValidator.propertyNotFound"
								message="The property #theVal.getPropertyName()# was not found in the object passed into the validation object." />
						</cfif>
					</cfif>
				</cfloop>
				<!--- inject the Result object into the BO if configured to do so --->
				<cfif arguments.injectResultIntoBO and isObject>
					<cfset arguments.theObject["setVTResult"] = this["setVTResult"] />
					<cfset arguments.theObject["getVTResult"] = this["getVTResult"] />
					<cfset arguments.theObject.setVTResult(arguments.Result) />
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="determineFailureMessage" access="private" output="false" returntype="any">
		<cfargument name="v" type="struct" required="true" hint="The validation struct stored in the BOValidator" />
		<cfargument name="theVal" type="any" required="true" hint="The validation object being used to perform the validation" />

		<cfset var failureMessage = arguments.theVal.getFailureMessage() />
		<cfif StructKeyExists(arguments.v,"FailureMessage") AND Len(arguments.v.FailureMessage)
			AND (arguments.theVal.getValType() NEQ "custom" OR len(failureMessage) EQ 0)>
			<cfset failureMessage = v.FailureMessage />
		</cfif>

		<cfreturn failureMessage />
	</cffunction>

	<cffunction name="getRuleValidators" access="public" output="false" returntype="any">
		<cfreturn variables.RuleValidators />
	</cffunction>

	<cffunction name="setRuleValidators" returntype="void" access="private" output="false" hint="I create rule validator objects from a list of component paths">
		
		<cfset var initArgs = {messageHelper=variables.messageHelper,defaultFailureMessagePrefix=variables.defaultFailureMessagePrefix,vtFolder=variables.vtFolder} />
		<cfset variables.RuleValidators = variables.childObjectFactory.loadChildObjects(variables.vtFolder & ".server,#variables.ExtraRuleValidatorComponentPaths#","ServerRuleValidator_",structNew(),initArgs) />

	</cffunction>
	
	<cffunction name="getRuleValidator" access="public" output="false" returntype="any">
		<cfargument name="RuleType" type="any" required="true" />
		<cfreturn variables.RuleValidators[arguments.RuleType] />
	</cffunction>
	
	<cffunction name="setVTResult" access="Public" returntype="void" output="false" hint="I set the VT Result object. I am injected into the BO if configured to do so.">
		<cfargument name="result" type="any" required="true" />
		<cfset variables.VTResult = arguments.result />
	</cffunction>
	<cffunction name="getVTResult" access="Public" returntype="any" output="false" hint="I get the VT Result object. I am injected into the BO if configured to do so.">
		<cfreturn variables.VTResult />
	</cffunction>

</cfcomponent>

