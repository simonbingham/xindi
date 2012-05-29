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
<cfcomponent output="false" name="ClientRuleScripter_DateRange" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the past date validation.">

   <cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The date entered must be in the range specified.">
		<cfset var theScript="">
		<cfset var theCondition="function(value,e,options) { return true; }"/>

		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(v,e,o){
			if (v==='') return true;
			var thedate = new Date(v);
			var ok = !/Invalid|NaN/.test(thedate);
			var start = new Date();
			var end = new Date();
			
			if(ok){
				if(o.from){
					start=new Date(o.from);
				}
				if(o.until){
					var end=new Date(o.until);
				}
				if(start!==end){
					ok=((start<=thedate)&&(thedate<=end));
				}
			}
			return ok;
		}
		</cfsavecontent>

		<cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
	</cffunction>

	<cffunction name="getFailureArgs" returntype="array" access="private" output="false" hint="I provide arguments needed to generate the failure message.">
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />

		<cfset var args = [arguments.parameters.from,arguments.parameters.until] />
		<cfreturn args />
		
	</cffunction>

</cfcomponent>

