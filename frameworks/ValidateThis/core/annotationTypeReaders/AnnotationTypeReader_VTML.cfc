<!---
TODO: UNIT TESTING

VTML
	syntax: 'valtype(key=value,parameter=pairs)[All,Contexts,Go,Here]{conditional,function,list}"your fail message goes here." formName|clientFieldName:propertyDesc;'
	example:
		property name="Test" type="string" length="255"
		validateThis='
			min(minlength=1)[*]"not long enough.";
			rangelength(minlength=5,maxlength=:length)[*,update]"value out of range.";
		';
--->

<cfcomponent extends="BaseAnnotationTypeReader" output="false" hint="I am used to setup validation rules in the framework with annotation &amp; vtml.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new VTML Annotation Reader">
		<cfset super.init(argumentCollection=arguments) />
		
		<cfset variables.VTML = structNew() />
		<!--- Default VTML REGEX MATCHER --->
		<cfset variables.VTML.RulePattern = '^[\w].*[\([\w=?\w\|?]+]?\)]?.*[\[.*\]]?.*[{.*}]?.*[".*"]?.*[\w]?\|?[\w]?[:\w]?(\+|;)?(\s|\n)?' />
		<!--- start with the valType --->
		<cfset variables.VTML.ValType = {Test='^\w+'} />
		<!--- match for () parameter group --->
		<cfset variables.VTML.Parameters = {Test='\(.*\)',Getter='\(|\)',Splitter='\|',ListDelim=',',ParamTest='(\w+=\w+)'} />
		<!--- match for [] context list--->
		<cfset variables.VTML.Contexts =  {Test='\[.*\]'} />
		<!--- match for {} condition block with optional crap before it --->
		<cfset variables.VTML.Condition = {Test = '[.*]?(\{.*\})'} />
		<!--- match for "" failure message quote--->
		<cfset variables.VTML.FailureMessage = {Test = '".*"'} />
		<!--- match for Form|client:propertyDesc options --->
		<cfset variables.VTML.FormSettings = {Test = '\w+\|\w+:?\w+$'} />
		<!--- match for rule appender --->
		<cfset variables.VTML.Appender = {Test = '(\+|;)'} />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isVTML" returntype="boolean" access="public" output="false" hint="I determin if the annotation matches the VTML pattern.">
		<cfargument name="theSource" type="string" required="true" />
		<cfset var Result = false />
		<cfif reFind(variables.VTML.RulePattern,trim(arguments.theSource))>
			<cfset Result = true />
		</cfif>
		<cfreturn Result />
	</cffunction>

	<cffunction name="processVTML" returntype="any" access="private" output="false" hint="I translate annotations to a struct the framework can use to add new rules.">
		<cfargument name="theSource" type="string" required="true" />
		<cfset var result = {} />
		<cfset var processedResult = {} />
		<cfset var localSource = trim(arguments.theSource) />
		
		<cftry>
			<cfset processedResult = convertVTML(localSource) />
			
			<cfif structKeyExists(processedResult,"Rules")>
				<cfreturn processedResult.Rules />
			<cfelse>
				<cfthrow type="Custom" extendedinfo="#localSource#" detail="#localSource.toString()#" errorcode="ValidateThis.core.AnnotationReader.InvalidMarkup" message="The annotation format is invalid. #arguments.theSource#" />
			</cfif>	
			
			<cfcatch>
				<!--- <cfthrow object="#cfcatch#"/> --->
				<cfthrow type="Custom" extendedinfo="#cfcatch.message#" detail="#localSource.toString()#" errorcode="ValidateThis.core.AnnotationReader.InvalidMarkup" message="The annotation format is invalid. #arguments.theSource#" />
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="convertVTML" returntype="any" access="private" output="false" hint="I convert VTML annotation format for the framework.">
		<cfargument name="theSource" type="any" required="true" />
		<cfset var test = {} />
		<cfset var result = {} />
		<cfset var rule = {} />
		<cfset var pos = {} />
		<cfset var tempValue = {} />
		<cfset var theRules = {} />
		<cfset var theRule = "" />
		<cfset var theCondition = "" />
		<cfset var theParameters = "" />
		<cftry>
			<cfparam name="result.Rules" default="#arrayNew(1)#" />
			<cfparam name="result.Tests" default="#structNew()#" />
			<cfparam name="result.Positions" default="#structNew()#" />
			<cfset theRules = arguments.theSource.split(variables.VTML.Appender.Test) />
			<cfloop array="#theRules#" index="theRule">
				<cfscript>
					test = {};
					rule = {};
					pos = {};
					theCondition={};
					theParameters={};

					// trim line breaks from rules
					theRule = trim(reReplace(theRule,"\n","","all"));
					test.IsVtml = theRule.matches(variables.VTML.RulePattern);

					 if (test.IsVtml){

						test.HasContexts = reFind(variables.VTML.Contexts.Test,theRule,0,false) gt 0;
						test.HasParameters = reFind(variables.VTML.Parameters.Test,theRule,0,false) gt 0;
						test.HasCondition = reFind(variables.VTML.Condition.Test,theRule,0,false) gt 0;
						test.HasFailureMessage = reFind(variables.VTML.FailureMessage.Test,theRule,0,false) gt 0;
						test.HasFormProperties = reFind(variables.VTML.FormSettings.Test,theRule,0,false) gt 0;

						pos.ValType = reFind(variables.VTML.ValType.Test,theRule,0,true);
						rule.Type = getElementFromVTMLRule(theRule,pos.ValType);

						if (test.HasParameters){
							pos.Parameters = reFind(variables.VTML.Parameters.Test,theRule,0,true);
							theParameters = getElementFromVTMLRule(theRule,pos.Parameters,variables.VTML.Parameters.Getter);
							if (len(theParameters)){
								rule.params = createParametersArray(theParameters);
							}
						}
						
						if (test.HasContexts){
							pos.Contexts = reFind(variables.VTML.Contexts.Test,theRule,0,true);
							rule.Contexts = getElementFromVTMLRule(theRule,pos.Contexts,"\[|\]");
						}
						if (test.HasFailureMessage){
							pos.Message = reFind(variables.VTML.FailureMessage.Test,theRule,0,true);
							rule.FailureMessage = reReplace(getElementFromVTMLRule(theRule,pos.Message),'"',"","all");
						}
						if (test.HasCondition){
							pos.Condition = reFind(variables.VTML.Condition.Test,theRule,0,true);
							rule.Condition =  getElementFromVTMLRule(theRule,pos.Condition,"\{|\}");
						}
						if (test.HasFormProperties){
						pos.FormProperties = reFind(variables.VTML.FormSettings.Test,theRule,0,true);
								//rule.FormProperties = getElementFromVTMLRule(theRule,pos.FormProperties);
						}
						} else {
							// why are we here?
						}
				</cfscript>
				
				<cfset structInsert(result.Tests,theRule,test) />
				<cfset structInsert(result.Positions,theRule,pos) />
				<cfset arrayAppend(result.Rules,rule) />
				
			</cfloop>
			<cfcatch>
				<cfthrow message="#cfcatch.message#" type="ValidateThis.core.AnnotationReader.VTMLConversionError" detail="#cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>

	<cffunction name="getElementFromVTMLRule" returntype="any" access="private" output="false">
		<cfargument name="theString" type="string" required="true" />
		<cfargument name="thePos" type="struct" required="true" />
		<cfargument name="mask" type="string" required="false" default="" />
		<cfset var result = "" />
		<cftry>
			<cfset result = mid(arguments.theString,arguments.thePos.pos[1],arguments.thePos.len[1]) />
			<cfif len(arguments.mask)>
				<cfset result = reReplace(result,arguments.mask,"","all") />
			</cfif>
			<cfcatch><cfthrow object="#cfobject#" /></cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>

	<cffunction name="createParametersArray" returntype="Array" access="private" output="false">
		<cfargument name="theString" type="string" required="true" />
		<cfset var result = [] />
		<cfset var param = {name="",value=""} />
		<cfset var test = 0 />
		<cfset var splitPairs = 0 />
		<cfset var pair = 0 />
		<cfset var splitParams = 0 />
		<cfset var vtml = variables.VTML.Parameters/>
		<cftry>
			<cfset test = reFind("#vtml.ParamTest##vtml.splitter#?",arguments.theString) />
			<cfif test>
				<cfset splitPairs =  arguments.theString.split(vtml.Splitter) />
				<cfif isArray(splitPairs) and ArrayLen(splitPairs) gt 0>
					<cfloop array="#splitPairs#" index="pair">
						<cfset param = structNew()/>
						<cfset splitParams = pair.split("=") />
						<cfif isArray(splitParams) and ArrayLen(splitParams) eq 2>
							<cfset structInsert(param,"name",splitParams[1],true) />
							<cfset structInsert(param,"value",splitParams[2],true) />
							<cfset arrayAppend(result,param) />
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfcatch><cfthrow object="#cfcatch#" /></cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>

	<cffunction name="createConditionStruct" returntype="any" access="private" output="false">
		<cfargument name="theString" type="string" required="true" />
		<cfset var result = "#arguments.theString#" />
		<!---  TODO: Set  Conditions From VTML --->
		<cfreturn result />
	</cffunction>

	<cffunction name="createContextsStruct" returntype="any" access="private" output="false">
		<cfargument name="theString" type="string" required="true" />
		<cfset var result = [] />
		<cfset var param = {} />
		<cfset var key = {} />
		<cfset var test = 0 />
		<cfset var splitPairs = 0 />
		<cfset var pair = 0 />
		<cfset var splitParams = 0 />
		<cftry>
			<cfset test = reFind("(\w+\|\w+),?",arguments.theString) />
			<cfif test>
				<cfset splitPairs =  arguments.theString.split(",") />
				<cfif isArray(splitPairs) and ArrayLen(splitPairs) gt 0>
					<cfloop array="#splitPairs#" index="pair">
						<cfset splitParams = pair.split("|") />
						<cfif isArray(splitParams) and ArrayLen(splitParams) eq 2>
							<cfset structInsert(key,"context",splitParams[1]) />
							<cfset structInsert(key,"formName",splitParams[2]) />
							<cfset arrayAppend(result,key) />
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfcatch></cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>

	<cffunction name="normalizeValidations" returntype="any" access="private" output="false" hint="I process a BusinessObject (CFC) and reformat property validation annotations it into a struct">
		<cfargument name="theValidation" type="any" required="true" />
		<cfargument name="theMetadata" type="any" required="true" />
		<cfset var result = {} />
		<cfset var theParameterName = {} />
		<cfset var theKey = 0 />
		<cfset var theOldParameter = 0 />
		<cfset var theNewParameter = 0 />
		<cfset var theParameter = 0 />
		<cfif structKeyExists(arguments.theMetadata,variables.ValidateThisConfig.AnnotationAttributeKey) and isVTML(arguments.theMetadata[variables.ValidateThisConfig.annotationAttributeKey])>
			<!--- Deal With Psudo Paramter Values --->
			<cfif structKeyExists(arguments.theValidation,"Parameters") and structCount(arguments.theValidation.Parameters) gt 0>
				<cfloop collection="#arguments.theValidation.Parameters#" item="theParameterName">
					<cfset theParameter = arguments.theValidation.parameters[theParameterName] />
					<cfif theParameter.matches("(:\w+)")>
						<cfset theKey = trim(reReplace(theParameter,":","","all")) />
						<cfif structKeyExists(arguments.theMetadata,theKey)>
							<cfset arguments.theValidation.parameters[theParameterName] = arguments.theMetadata[theKey] />
						<cfelse>
							<cfbreak />
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
			<!--- Deal With Psudo Failure Messages --->
			<cfif structKeyExists(arguments.theValidation,"failureMessage") and len(arguments.theValidation["failureMessage"] gt 0)>
				<cfloop condition="#arguments.theValidation.failureMessage.matches(".*(:\w+).*")#">
				<cfset theParameter = trim(getElementFromVTMLRule(arguments.theValidation.failureMessage,refind("(:\w+)",arguments.theValidation.failureMessage,0,true))) />
				<cfset theKey = trim(reReplace(theParameter,":","","all")) />
				<cfif structKeyExists(arguments.theMetadata,theKey)>
					<cfset arguments.theValidation.failureMessage = replaceNoCase(arguments.theValidation.failureMessage,theParameter,arguments.theMetaData[theKey],"all") />
				<cfelse>
					<cfbreak />
				</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<cfreturn result />
	</cffunction>

	<cffunction name="isThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		<cfargument name="annotationValue" type="string" required="true" />
		
		<cfif isVTML(arguments.annotationValue)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I take the object metadta and reformat it into private properties">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" hint="the object metadata" />
		<cfset var properties = {}/>
		<cfif structKeyExists(arguments.metadataSource,"vtConditions")>
			<cfset processConditions(arguments.metadataSource.vtConditions) />
		</cfif>
		<cfif structKeyExists(arguments.metadataSource,"vtContexts")>
			<cfset processContexts(arguments.metadataSource.vtContexts) />
		</cfif>
		<cfif structKeyExists(arguments.metadataSource,"properties")>
			<cfset properties = reformatProperties(arguments.metadataSource.properties)>
			<cfset processPropertyDescs(properties) />
			<cfset processPropertyRules(arguments.objectType,properties) />
		</cfif>

	</cffunction>

	<cffunction name="reformatProperties" returnType="array" access="private" output="false" hint="I translate metadata into an array of properties to be used by the BaseMetadataProcessor">
		<cfargument name="properties" type="any" required="true" />
		<cfset var theProperty = 0 />
		<cfset var newProperty = 0 />
		<cfset var theProperties = [] />

		<cfloop array="#arguments.properties#" index="theProperty">
			<cfset newProperty = {name=theProperty.name} />
			<cfif StructKeyExists(theProperty,"vtDesc")>
				<cfset newProperty.desc = theProperty.vtDesc />
			<cfelseif structKeyExists(theProperty,"displayname")>
				<cfset newProperty.desc = theProperty.displayname />
			</cfif>
			<cfif StructKeyExists(theProperty,"vtClientFieldname")>
				<cfset newProperty.clientfieldname = theProperty.vtClientFieldname />
			</cfif>
			<cfif StructKeyExists(theProperty,"vtRules")>
				<cfif isVTML(theProperty.vtRules)>
					<cfset newProperty.rules = processVTML(theProperty.vtRules,theProperty) />
				<cfelse>
					<cfthrow type="ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_VTML.InvalidVTML" detail="The contents of a vtRules annotation on the #theProperty.name# property (#theProperty.vtRules#) does not contain valid VTML." />
				</cfif>
			</cfif>
			
			<cfset arrayAppend(theProperties,newProperty) />
		</cfloop>
		<cfreturn theProperties />
	</cffunction>

</cfcomponent>
