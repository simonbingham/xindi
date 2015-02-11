<!--- 

Example Usage:

<rule type="MinPatternsMatch">
	<param name="minMatches" value="3" />
	<param name="pattern_lowerCaseLetter" value="[a-z]" />
	<param name="pattern_upperCaseLetter" value="[A-Z]" />
	<param name="pattern_digit" value="[\d]" />
	<param name="pattern_punct" value="[[:punct:]]" />
</rule>

 --->

<cfcomponent output="false" name="ClientRuleScripter_Patterns" extends="AbstractClientRuleScripter" hint="Fails if the validated property does not match at least 1 or the specficied ammount of regex patterns defined.">
	
	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="Value did not match the pattern requirements.">
		<cfargument name="locale" type="Any" required="no" default="" />
		<cfset var theScript="">
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(v,e,o){
			var minMatches = 1;
			var complexity = 0;
			if(!v.length){
				return true;
			}
			if(o.minMatches){
				minMatches = o.minMatches;
			}
			var re = /^pattern_/i;
			for(var key in o){
				if(re.test(key)&&v.match(o[key])){
					complexity++;
					if(complexity===minMatches){
						return true;
					}
				}
			}
			return complexity>=minMatches;
		}
		</cfsavecontent>			
		<cfreturn generateAddMethod(theCondition,arguments.defaultMessage,arguments.locale)/>
	</cffunction>
	
</cfcomponent>