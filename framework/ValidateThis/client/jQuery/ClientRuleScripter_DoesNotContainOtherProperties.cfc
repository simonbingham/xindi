<!--- 
DoesNotContain:

Definition Usage Example:

<rule type="DoesNotContain" failuremessage="Password may not contain your first or last name." >
	<param name="propertyNames" value="firstName,LastName"/>
</rule>
<rule type="DoesNotContain" failuremessage="Password may not contain your username.">
	<param name="propertyNames" value="username" />
</rule>
<rule type="DoesNotContain" failuremessage="Password may not contain your email address." >
	<param name="propertyNames" value="emailAddress"/>
</rule>
<rule type="DoesNotContain" failuremessage="This better be ignored!" >
	<param name="propertyNames" value"="thisPropertyDoesNotExist"/>
</rule>

--->

<cfcomponent name="ClientRuleScripter_DoesNotContain" extends="AbstractClientRuleScripter" hint="Fails if the validated property contains the value of another property">
	
	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The value cannot not contain the value of another property.">
		<cfset var theScript="">
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(v,e,o){
			var ok=true;
			var $form=$(e).closest("form");
			$(o).each(function(){
				var propertyValue = $(':input[name='+this+']',$form).getValue();
				if(propertyValue.length){
					// if this is a mutiple select list, split the value into an array for iteration
					if(propertyValue.search(",")){
						propertyValue = propertyValue.split(",");
					}
					// for each property value in the array to check
					$(propertyValue).each(function(){
						var test = v.toString().toLowerCase().search(this.toString().toLowerCase())===-1;
						if (!test){ // Only worry about failures here so we return true if none of the other values fail.
							ok = false;
						}
					});
				}
				return ok;
			});
			return ok;
		}
		</cfsavecontent>
			
		 <cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
	</cffunction>
	
	<cffunction name="getParameterDef" returntype="string" access="public" output="false" hint="I generate the JS script required to pass the appropriate paramters to the validator method.">
		<cfargument name="validation" type="any"/>
		
		<cfset var params = arguments.validation.getParameters() />
		<cfreturn serializeJSON(listToArray(trim(params.propertyNames))) />
		
	</cffunction>
	
	<cffunction name="getFailureArgs" returntype="array" access="private" output="false" hint="I provide arguments needed to generate the failure message.">
		<cfargument name="parameters" type="any" required="yes" hint="The parameters stored in the validation object." />

		<cfset var args = [arguments.parameters.propertyNames] />
		<cfreturn args />
		
	</cffunction>



</cfcomponent>