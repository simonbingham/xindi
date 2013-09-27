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
<cfcomponent output="false" name="ClientRuleScripter_regex" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the regex validation.">

	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The value entered does not match the specified pattern ({0})">
		<cfset var theScript="" />
		<cfset var theCondition="" />
		
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(v,e,p){
			if(v===''){return true};
			return v.match(p);
		}</cfsavecontent>

		 <cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
	</cffunction>
	
	<cffunction name="getParameterDef" returntype="any" access="public" output="false" hint="I override the parameter def because the VT param names do not match those expected by the jQuery plugin.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var options = "" />
        <cfif arguments.validation.hasParameter("Regex")>
            <cfset options = arguments.validation.getParameterValue("Regex") />
        <cfelseif arguments.validation.hasParameter("ServerRegex")>
            <cfset options = arguments.validation.getParameterValue("ServerRegex")/>
        <cfelse>            
            <cfthrow type="validatethis.client.jQuery.ClientRuleScripter_Regex.missingParameter"
            message="Either a regex or a serverRegex parameter must be defined for a regex rule type." />
        </cfif>
		<cfreturn '"' & JSStringFormat(options) & '"' />
	</cffunction>

</cfcomponent>