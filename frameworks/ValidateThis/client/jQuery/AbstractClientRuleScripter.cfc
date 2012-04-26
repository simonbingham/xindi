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
<cfcomponent output="false" name="AbstractClientRuleScripter" hint="I am a base object which all concrete ClientRuleScripters extend.">
	<cfproperty name="DefaultFailureMessage" type="string" default="">
	
	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientRuleScripter">
		<cfargument name="Translator" type="Any" required="yes" />
		<cfargument name="messageHelper" type="any" required="true" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />

		<cfset variables.ValType = lcase(ListLast(getMetadata(this).name,"_"))/>
		<cfset variables.Translator = arguments.Translator />
		<cfset variables.messageHelper = arguments.messageHelper />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />
		
		<cfreturn this />
	</cffunction>
	
	<!--- Public Functions --->
	
	<cffunction name="generateAddMethod" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="theMethod" type="any" required="yes" hint="The JS method to use for the validator." />
		<cfargument name="defaultMessage" type="string" required="yes">

		<cfset var theScript = "" />
		
		<cfoutput>
		<cfsavecontent variable="theScript">
		$.validator.addMethod("#getValType()#",#arguments.theMethod#,$.format("#arguments.defaultMessage#"));
		</cfsavecontent>
		</cfoutput>

		<cfreturn trim(theScript)/>

	</cffunction>

	<cffunction name="generateValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="formName" type="Any" required="yes" />
		<cfset var safeSelectorScript = getSafeSelectorScript(argumentCollection=arguments) />
		<cfset var theScript = generateRuleScript(validation=arguments.validation,locale=arguments.locale,selector=safeSelectorScript) />
		<cfreturn theScript />
	</cffunction>
	
	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="selector" type="Any" required="yes" />
		
		<cfreturn generateAddRule(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="generateAddRule" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="selector" type="Any" required="yes" />
		<cfset var theScript = "" />
		
		<cfoutput>
		<cfsavecontent variable="theScript">
			if(#arguments.selector#.length){
				#arguments.selector#.rules('add',#generateRuleStruct(argumentCollection=arguments)#);
			}
		</cfsavecontent>
		</cfoutput>		
		
		<cfreturn theScript/>
	</cffunction>
	
	<cffunction name="generateValidationJSON" returntype="any" access="public" output="false" hint="I generate the JS JSON object required to implement the validations.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="formName" type="Any" required="yes" />
		<cfset var theJSON = "" />
		<cfset arguments.selector = getSafeSelectorScript(argumentCollection=arguments) />
		<cfset theJSON = '{"#validation.getClientFieldName()#":#generateRuleStruct(argumentCollection=arguments)#}' />
		<cfreturn theJSON />
	</cffunction>
	
	<cffunction name="generateConditionJSON" returntype="any" access="public" output="false" hint="I generate the JSON object required to implement conditions for validations.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfscript>
			var theConditions = {};
			//theCondition = '{"conditions": #getConditionDef(argumentCollection=arguments)#}';
			//theConditions["#arguments.formName#"]["#arguments.validation.getClientFieldName()#"]["#arguments.validation.getValType()#"] = deserializeJSON(conditionDef);
		</cfscript>
		<cfreturn  serializeJSON(getConditionDef(argumentCollection=arguments)) />
	</cffunction>

	<cffunction name="generateRuleStruct" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="selector" type="Any" required="yes" />
		
		<!--- Determine what failureMessage to use for this Validation --->
		<cfset var parameters = arguments.validation.getParameters() />
		<cfset var failureMessage = determineFailureMessage(arguments.validation,arguments.locale,parameters) />
		<cfset var theStruct = "" />
		
		<cfset var conditionDef = getConditionDef(argumentCollection=arguments)>
		<cfset var ruleDef = getRuleDef(arguments.validation,parameters) />
		<cfset var messageDef = getMessageDef(failureMessage,getValType(),arguments.locale)/>
		
		<cfif len(ruleDef) GT 0>
			<cfset theStruct = "{#ruleDef##messageDef##conditionDef#}" />
		</cfif>
		
		<cfreturn theStruct/>
		
	</cffunction>
	
	<cffunction name="getRuleDef" returntype="any" access="public" output="false" hint="I return just the rule definition which is required for the generateAddRule method.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />
		<cfset var parameterDef = getParameterDef(arguments.validation)/>
		<cfset var ruleDef = '"#getValType()#":#parameterDef#' />
		<cfreturn ruleDef />
	</cffunction>	
	
	<cffunction name="getParameterDef" returntype="string" access="public" output="false" hint="I generate the JS script required to pass the appropriate paramters to the validator method.">
		<cfargument name="validation" type="any"/>

		<cfset var parameterDef = ""/>
		<cfset var conditionDef = ""/>
		
		<cfset var paramName = "" />
		<cfset var paramList = "" />
		<cfset var parameters = {} />

		<cfif arguments.validation.hasClientTest()>
			<cfset arguments.validation.addParameter("depends",arguments.validation.getConditionName())>
		</cfif>
		
		<cfset parameters = arguments.validation.getParameters()/>
		
		<cfif structCount(parameters) GT 0>
			<cfif structCount(parameters) EQ 1>
				<cfset paramName = structKeyArray(parameters) />
				<cfset paramName = paramName[1] />
				<cfset parameterDef = parameterDef & parameters[paramName] />
			<cfelse>
				<cfset parameterDef = serializeJSON(parameters)/>
			</cfif>
		</cfif>
		
		<cfif len(parameterDef) eq 0>
			<cfset parameterDef &= '"true"' />
			
		</cfif>
		
		<cfreturn parameterDef/>
		
	</cffunction>

	
	<cffunction name="getConditionDef" returntype="string" access="public" output="false" hint="I generate the JS script required to pass the appropriate depends conditions to the validator method.">
		<cfargument name="validation" type="any"/>
		<cfset var condition = arguments.validation.getCondition() />
		<cfset var parameters = arguments.validation.getParameters() />
		<cfset var conditionDef = "" />
		<cfif arguments.validation.hasClientTest()>
			<cfreturn  ',"conditions":{"#arguments.validation.getConditionName()#":"#arguments.validation.getClientTest()#"}' />
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cffunction>
	 
	<cffunction name="getMessageDef" returntype="string" access="public" output="false" hint="I generate the JS script required to display the appropriate failure message.">
		<cfargument name="message" type="string" default="#getGeneratedFailureMessage()#"/>
		<cfargument name="valType" type="string" default="#getValType()#"/>
		<cfargument name="locale" type="string" default=""/>
		
		<cfset var messageDef = ""/>
		<cfset var failureMessage = arguments.message/>		
		<cfif len(failureMessage) gt 0>
			<cfset failureMessage = translate(failureMessage,arguments.locale)/>
			<cfset messageDef = ',"messages":{"#arguments.valType#":"#failureMessage#"}'/>
		</cfif>
		<cfreturn messageDef/>
	</cffunction>

	<!--- Private Function --->	
	<cffunction name="getValType" returntype="string" access="private" output="false" hint="I generate the JS script required to implement a validation.">
		<cfreturn variables.ValType />
	</cffunction>

	<cffunction name="getSafeSelectorScript" returntype="string" access="private" output="false" hint="I generate the JS script required to select a property input element.">
		<cfargument name="validation" type="any"/>
		<cfargument name="formName" type="string" default=""/>
		<cfset var safeFieldName = arguments.validation.getClientFieldName()/>
		<cfreturn "fm['#safeFieldName#']" />
	</cffunction>	
	
	<cffunction name="determineFailureMessage" returntype="any" access="private" output="false" hint="I determin the actual failure message to be used.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />

		<!--- Lets first try getCustomFailureMessage on either the AbstractClientRuleScripter or the CRS implementation --->
		<cfset var failureMessage = getCustomFailureMessage(arguments.validation) />

		<!---  If we don't get anything there, lets go for getTheDefaultFailuremessage for this validation --->
		<cfif len(failureMessage) eq 0>
			<cfset failureMessage = getGeneratedFailureMessage(arguments.validation,arguments.locale,arguments.parameters) />
		</cfif>
		
		<cfreturn failureMessage/>
	</cffunction>
	
	<cffunction name="getCustomFailureMessage" returntype="any" access="private" output="false" hint="I return the custom failure message from the validation object.">
		<cfargument name="validation" type="any" default=""/>
		<!--- If this validation a failureMessage from the metadata, then use that --->
		<cfif arguments.validation.hasFailureMessage()>
			<cfreturn arguments.validation.getFailureMessage() />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="getGeneratedFailureMessage" returntype="string" access="private" output="false" hint="I return the generated failure message from the resource bundle for this CRS. Override me to customize further.">
		<cfargument name="validation" type="any"/>
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />

		<!--- TODO: Here is where the failure message is being retrieved from the RB --->
		<cfset var args = [arguments.validation.getPropertyDesc()] />
		<cfset args.addAll(getFailureArgs(arguments.parameters)) />

		<cfreturn variables.messageHelper.getGeneratedFailureMessage("defaultMessage_" & variables.ValType,args,arguments.locale) />
	</cffunction>

	<cffunction name="getFailureArgs" returntype="array" access="private" output="false" hint="I provide arguments needed to generate the failure message.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfreturn ArrayNew(1) />
	</cffunction>

	<cffunction name="translate" returntype="string" access="private" output="false" hint="I translate a message.">
		<cfargument name="message" type="string" default=""/>		
		<cfargument name="locale" type="string" default=""/>
		<cfreturn  variables.Translator.translate(arguments.message,arguments.locale) />
	</cffunction>

</cfcomponent>