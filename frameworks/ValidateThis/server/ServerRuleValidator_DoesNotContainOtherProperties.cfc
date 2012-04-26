<!--- 
DoesNotContain: (OtherPropertiesOrValues)
	@Marc Escher
	@Adam Drew

Usage Example:

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

<cfcomponent output="false" extends="AbstractServerRuleValidator" hint="Fails if the validated property contains the values of nother properties">
	<cfscript>
		function validate(validation,locale){
			var value = arguments.validation.getObjectValue();
			var params = arguments.validation.getParameters();
			var property = "";
			var propIndex = "";
			var propValue = "";
			var propertyNames = "";
			var theDelim= ",";
			var args = [arguments.validation.getPropertyDesc(),params.propertyNames];

		 	if (not shouldTest(arguments.validation) or len(value) eq 0) {
			   return;
			}

			if (arguments.validation.hasParameter("delim")){
				theDelim= arguments.validation.getParameterValue("delim");
			}
			propertyNames = listToArray(arguments.validation.getParameterValue("propertyNames"),theDelim);
			
			for (propIndex = 1; propIndex <= ArrayLen(propertyNames); propIndex++) {
				property = propertyNames[propIndex];
				propValue = arguments.validation.getObjectValue(property);
				if(propValue NEQ "" AND value contains propValue){
					fail(validation, variables.messageHelper.getGeneratedFailureMessage("defaultMessage_DoesNotContainOtherProperties",args,arguments.locale));
				}
			}
		}
	</cfscript>
</cfcomponent>
