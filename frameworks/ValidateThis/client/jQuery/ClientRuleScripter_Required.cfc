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
<cfcomponent output="false" name="ClientRuleScripter_Required" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the required validation.">
	<cfproperty name="DefaultFailureMessage" type="string" default="This field is required.">
	
	<cffunction name="determineFailureMessage" returntype="any" access="private" output="false" hint="I determin the actual failure message to be used.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />
		<cfset var otherInput = "" />
		<cfset var parameters = arguments.validation.getParameters() />
		<cfset var args = [arguments.validation.getPropertyDesc()] />
		<cfset var msgKey = "defaultMessage_Required" />

		
		<!--- Lets first try getCustomFailureMessage on either the AbstractClientRuleScripter or the CRS implementation --->
		<cfset var failureMessage = getCustomFailureMessage(arguments.validation) />

		<cfif len(failureMessage) eq 0>

			<cfif arguments.validation.hasParameter("DependentInputName") and len(parameters.DependentInputName) gt 0>
				
				<cfif arguments.validation.hasParameter("DependentInputDesc") and len(parameters.DependentInputDesc) gt 0>
					<cfset otherInput = parameters.DependentInputDesc />
				<cfelse>
					<cfset otherInput = parameters.DependentInputName />
				</cfif>
				
				<cfset arrayAppend(args,variables.defaultFailureMessagePrefix) />
				<cfset arrayAppend(args,otherInput) />
	             <cfif len(parameters.DependentInputValue) gt 0>
					<cfset msgKey = "defaultMessage_Required_DependentPropertyValue" />
	            <cfelse>
					<cfset msgKey = "defaultMessage_Required_DependentProperty" />
	            </cfif>
	    	</cfif>
	        <cfset failureMessage = variables.messageHelper.getGeneratedFailureMessage(msgKey,args,arguments.locale)  />
		</cfif>
	
		<cfreturn failureMessage />
	</cffunction>
	
	<cffunction name="getConditionDef" returntype="string" access="public" output="false" hint="I generate the JS script required to pass the appropriate depends conditions to the validator method.">
		<cfargument name="validation" type="any"/>
		<cfset var condition = arguments.validation.getCondition() />
		<cfset var parameters = arguments.validation.getParameters() />
		<cfset var conditionDef = "" />

		<cfif len(parameters.DependentInputName) GT 0>
			<cfif len(parameters.DependentInputValue) gt 0>
			    <cfset conditionDef = "$("":input[name='#parameters.DependentInputName#']"").getValue() == " & parameters.DependentInputValue & ";"/>
			<cfelse>
			    <cfset conditionDef = "$("":input[name='#parameters.DependentInputName#']"").getValue().length > 0;"/>
			</cfif>
		</cfif>
		<cfif len(conditionDef)>
			<cfset arguments.validation.addParameter("depends","#arguments.validation.getClientFieldName()#Depends")>
			<cfreturn ',"conditions": {"#arguments.validation.getClientFieldName()#Depends" : "#jsStringFormat(conditionDef)#"}' />
		<cfelse>
	     	<cfif arguments.validation.hasClientTest()>
				<cfreturn  ',"conditions": {"#arguments.validation.getConditionName()#" : "#arguments.validation.getClientTest()#"}' />
			<cfelse>
				<cfreturn ''>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="generateRuleStruct" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfargument name="locale" type="Any" required="yes" />
		<cfargument name="selector" type="Any" required="yes" />

		<cfscript>
			if (arguments.validation.hasParameter("DependentFieldName")){
				arguments.validation.addParameter("DependentInputName",arguments.validation.getParameterValue("DependentFieldName"));
			} else if (arguments.validation.hasParameter("DependentPropertyName")){
				arguments.validation.addParameter("DependentInputName",arguments.validation.getParameterValue("DependentPropertyName"));
			} else {
				arguments.validation.addParameter("DependentInputName","");
			}

			if (arguments.validation.hasParameter("DependentPropertyValue")){
				arguments.validation.addParameter("DependentInputValue",arguments.validation.getParameterValue("DependentPropertyValue"));
			} else if (arguments.validation.hasParameter("DependentFieldValue")){
				arguments.validation.addParameter("DependentInputValue",arguments.validation.getParameterValue("DependentFieldValue"));			
			} else {
				arguments.validation.addParameter("DependentInputValue","");
			}

			if (len(arguments.validation.getParameterValue("DependentInputName")) gt 0){
				if (arguments.validation.hasParameter("DependentPropertyDesc")){
					arguments.validation.addParameter("DependentInputDesc",arguments.validation.getParameterValue("DependentPropertyDesc"));
				} else if (arguments.validation.hasParameter("DependentFieldDesc")){
					arguments.validation.addParameter("DependentInputDesc",arguments.validation.getParameterValue("DependentFieldDesc"));
				} else {
					arguments.validation.addParameter("DependentInputDesc",arguments.validation.getParameterValue("DependentInputName"));
				}
			}	else {
				arguments.validation.addParameter("DependentInputDesc","");
			}
		</cfscript>
		<cfreturn super.generateRuleStruct(argumentCollection=arguments) />
		
	</cffunction>
	
	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="locale" type="string" required="yes" />
		<cfargument name="selector" type="string" required="no" default="" />

		<cfset var theCondition = "true" />
		<cfset var ConditionDesc = "" />
		<cfset var theScript = "" />
		
		<cfset var DependentInputName = "" />
		<cfset var DependentInputDesc = "" />
		<cfset var DependentInputValue = "" />
		
		<cfset var valType = getValType() />
		
		<cfset var failureMessage = ""/>

		<cfset var parameters = "" />

		<cfscript>
			if (arguments.validation.hasParameter("DependentFieldName")){
				arguments.validation.addParameter("DependentInputName",arguments.validation.getParameterValue("DependentFieldName"));
			} else if (arguments.validation.hasParameter("DependentPropertyName")){
				arguments.validation.addParameter("DependentInputName",arguments.validation.getParameterValue("DependentPropertyName"));
			} else {
				arguments.validation.addParameter("DependentInputName","");
			}

			if (arguments.validation.hasParameter("DependentPropertyValue")){
				arguments.validation.addParameter("DependentInputValue",arguments.validation.getParameterValue("DependentPropertyValue"));
			} else if (arguments.validation.hasParameter("DependentFieldValue")){
				arguments.validation.addParameter("DependentInputValue",arguments.validation.getParameterValue("DependentFieldValue"));			
			} else {
				arguments.validation.addParameter("DependentInputValue","");
			}

			if (len(arguments.validation.getParameterValue("DependentInputName")) gt 0){
				if (arguments.validation.hasParameter("DependentPropertyDesc")){
					arguments.validation.addParameter("DependentInputDesc",arguments.validation.getParameterValue("DependentPropertyDesc"));
				} else {
					arguments.validation.addParameter("DependentInputDesc",arguments.validation.getParameterValue("DependentInputName"));
				}
			}	else {
				arguments.validation.addParameter("DependentInputDesc","");
			}
		</cfscript>

		<cfset parameters = arguments.validation.getParameters() />

		<cfset failureMessage = determineFailureMessage(arguments.validation,arguments.locale) />

		<!--- Deal with various conditions --->
		<cfif StructKeyExists(arguments.validation.getCondition(),"ClientTest")>
			<cfset theCondition = "function(el){return #arguments.validation.getCondition().ClientTest#}" />
        </cfif>
		
        <cfif len(parameters.DependentInputName) GT 0>
            <cfif len(parameters.DependentInputValue) gt 0>
                <cfset theCondition = "function(el){return $("":input[name='#parameters.DependentInputName#']"").getValue() == '" & parameters.DependentInputValue & "';}" />
            <cfelse>
                <cfset theCondition = "function(el){return $("":input[name='#parameters.DependentInputName#']"").getValue().length > 0;}" />
            </cfif>
        </cfif>
		
        <cfset failureMessage = variables.Translator.translate(failureMessage,arguments.locale)/>
		
		<cfoutput>
		<cfsavecontent variable="theScript">
			if(#arguments.selector#.length){
				#arguments.selector#.rules("add",{#valType#:#theCondition#,messages:{#valType#:"#failureMessage#"}});
			}
		</cfsavecontent>
		</cfoutput>		
		<cfreturn trim(theScript) />
	</cffunction>
</cfcomponent>