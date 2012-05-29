<!---
	
	Copyright 2008, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->

<cfcomponent output="false" name="ClientRuleScripter_FutureDate" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the past date validation.">

	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The date entered must be in the future." />
		<cfset var theCondition="function(value,element,options) { return true; }" />
		
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
			function(v,e,o){ 
				if(v===''){return true;}
				var dToday = new Date();
				var dValue = new Date(v);
				if(o.after){
					dToday = new Date(o.after);
				}
				return (dToday<dValue);
			}
		</cfsavecontent>
		
		<cfreturn generateAddMethod(theCondition,arguments.defaultMessage) />
	</cffunction>
	
	<cffunction name="getParameterDef" returntype="any" access="public" output="false" hint="I override the parameter def because the VT param names do not match those expected by the jQuery plugin.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var options = true />
		<cfif arguments.validation.hasParameter("after")>
			<cfset options = {}/>
			<cfset options["after"] = arguments.validation.getParameterValue("after") />
		</cfif>
		<cfreturn serializeJSON(options) />
	</cffunction>

	<cffunction name="getGeneratedFailureMessage" returntype="string" access="private" output="false" hint="I return the generated failure message from the resource bundle for this CRS. Override me to customize further.">
		<cfargument name="validation" type="any"/>
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />

		<cfset var args = [arguments.validation.getPropertyDesc()] />
		<cfset var msgKey = "defaultMessage_FutureDate" />

		<cfif arguments.validation.hasParameter("after")>
			<cfset theDate = arguments.validation.getParameterValue("after")/>
			<cfset msgKey = "defaultMessage_FutureDate_WithAfter" />
			<cfset arrayAppend(args,theDate) />
		</cfif>
		<cfreturn variables.messageHelper.getGeneratedFailureMessage(msgKey,args,arguments.locale) />
	</cffunction>

</cfcomponent>
