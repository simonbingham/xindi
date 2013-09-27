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
<cfcomponent output="false" name="ClientRuleScripter_equalTo" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the equalTo validation.">

	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The value cannot not contain the value of another property.">
		<!--- TODO: We can probably do away with the defaultMessage in here as it should never be used --->
		<cfset var theScript="">
		<cfset var theCondition="function(value, element, param) {return true;}" />
		
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(v,e,p){
			var $parentForm = $(e).closest("form");
			var $compareto = $(p,$parentForm);
			// bind to the blur event of the target in order to revalidate whenever the target field is updated
			// TODO find a way to bind the event just once, avoiding the unbind-rebind overhead
			var target = $compareto.unbind(".validate-equalTo").bind("blur.validate-equalTo",function(){
				$(e).valid();
			});
			return v==target.getValue();
		}
		</cfsavecontent>
		
		<cfreturn generateAddMethod(theCondition,arguments.defaultMessage) />
	</cffunction>	

	<cffunction name="getParameterDef" returntype="any" access="public" output="false" hint="I override the parameter def because the VT param names do not match those expected by the jQuery plugin.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object that describes the validation." />
		<cfset var params = arguments.validation.getParameters() />
		<cfset var compareFieldName = arguments.validation.getValidateThis().getClientFieldName(objectType=arguments.validation.getObjectType(),propertyName=params.ComparePropertyName) />

		<cfreturn """:input[name='#compareFieldName#']""" />
	</cffunction>

	<cffunction name="getFailureArgs" returntype="array" access="private" output="false" hint="I provide arguments needed to generate the failure message.">
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />

		<cfset var args = [variables.defaultFailureMessagePrefix,arguments.parameters.ComparePropertyDesc] />
		<cfreturn args />
		
	</cffunction>

</cfcomponent>
