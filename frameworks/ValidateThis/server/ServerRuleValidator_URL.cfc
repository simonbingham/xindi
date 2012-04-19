<cfcomponent output="false" displayname="ServerRuleValidator_URL" extends="AbstractServerRuleValidator"  hint="I am responsible for performing URL validation.">
	<cfscript>
		function validate(validation,locale){
			var theValue = arguments.validation.getObjectValue();
			var args = [arguments.validation.getPropertyDesc()];
			if (not shouldTest(arguments.validation)) return;
			if (not isValid("URL",theValue)) {
				fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_URL",args,arguments.locale));
			}
		}
	</cfscript>
</cfcomponent>