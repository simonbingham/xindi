<!---
	
	Copyright 2010, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.

--->

<cfcomponent output="false" name="ClientRuleScripter_NotInList" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the NotInList validation.">

	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="Value was found in list.">
		<cfset var theCondition="function(value,element,options) { return true; }"/>

		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(v,e,o){
			var delim = o.delim ? o.delim : ",";
			var lst = o.list.split(delim);
			var ok = true;
			$.each(lst, function(i,el){
				if (v.toLowerCase()===el.toLowerCase()){
					ok=false;
					return false;
				}
			});
			return ok;
		}</cfsavecontent>
		
		<cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
	</cffunction>

	<cffunction name="getParameterDef" returntype="any" access="public" output="false" hint="I override the parameter def because the VT param names do not match those expected by the jQuery plugin.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var options = true />
		<cfif arguments.validation.hasParameter("list")>
			<cfset options = {}/>
			<cfset options["list"] = arguments.validation.getParameterValue("list") />
			<cfif arguments.validation.hasParameter("delim")>
				<cfset options['delim'] = arguments.validation.getParameterValue("delim",",")/>
			</cfif>
		</cfif>
		<cfreturn serializeJSON(options) />
	</cffunction>

	<cffunction name="getFailureArgs" returntype="array" access="private" output="false" hint="I provide arguments needed to generate the failure message.">
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />

		<cfset var args = [""] />
		<cfif structKeyExists(arguments.parameters,"list")>
			<cfset args = [arguments.parameters.list] />
		</cfif>
		<cfreturn args />
		
	</cffunction>

</cfcomponent>