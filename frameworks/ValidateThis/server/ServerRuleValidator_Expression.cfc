<cfcomponent output="false" name="ServerRuleValidator_Expression" extends="AbstractServerRuleValidator">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />

		<cfset var theObject = arguments.validation.getTheObject() />
		<cfset var Parameters = arguments.validation.getParameters() />
		<cfset var expr = Parameters.expression />
		<cfif NOT theObject.testCondition(expr)>
			<cfset fail(validation, validation.getFailureMessage()) />
		</cfif>
		
	</cffunction>

</cfcomponent>
	
