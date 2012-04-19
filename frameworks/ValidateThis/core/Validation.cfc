<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent displayname="Validation" output="false" hint="I am a transient validation object.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I am the constructor">
		<cfargument name="objectChecker" type="any" required="yes" hint="A component used to distinguish object types" />
		<cfargument name="parameter" type="any" required="yes" hint="A reusable transient Parameter object" />

		<cfset variables.objectChecker = arguments.objectChecker />
		<cfset variables.parameter = arguments.parameter />
		<cfset variables.parameter.setup(this) />
		
		<cfreturn this />

	</cffunction>

	<cffunction name="setup" access="Public" returntype="any" output="false" hint="I am called after the constructor to load data into an instance">
		<cfargument name="ValidateThis" type="any" required="yes" hint="The ValidateThis.cfc facade object" />
		<cfargument name="theObject" type="any" required="no" default="" hint="The object being validated" />
		<cfargument name="objectList" type="array" required="no" default="#arrayNew(1)#" hint="A list of objects already validated" />
		
		<cfset variables.ValidateThis = arguments.ValidateThis />
		<cfset variables.theObject = arguments.theObject />
		<cfset variables.objectList = arguments.objectList />
		<cfset variables.currentLocale = arguments.ValidateThis.getValidateThisConfig().defaultLocale />
		<cfset variables.context = "" />
		
		<cfreturn this />
		
	</cffunction>

	<cffunction name="load" access="Public" returntype="any" output="false" hint="I load a fresh validation rule into the validation object, which allows it to be reused">
		<cfargument name="ValStruct" type="any" required="yes" hint="The validation struct from the xml file" />
		
		<cfset variables.instance = Duplicate(arguments.ValStruct) />
		<cfset variables.instance.IsSuccess = true />
		<cfparam name="variables.instance.FailureMessage" default="" />
		<cfparam name="variables.instance.result" default="" />
		
		<cfreturn this />

	</cffunction>

	<cffunction name="fail" returntype="void" access="public" output="false" hint="I do what needs to be done when a validation fails.">
		<cfargument name="FailureMessage" type="any" required="yes" hint="A Failure message to store." />
	
		<cfset setIsSuccess(false) />
		<cfset setFailureMessage(arguments.FailureMessage) />
	</cffunction>

	<cffunction name="failWithResult" returntype="void" access="public" output="false" hint="I do what needs to be done when a validation fails.">
		<cfargument name="result" type="any" required="yes" hint="A Failure message to store." />
	
		<cfset setIsSuccess(false) />
		<cfset setResult(arguments.result) />
	</cffunction>

	<cffunction name="getObjectValue" access="public" output="false" returntype="any" hint="I return the value from the stored object that corresponds to the field being validated.">
		<cfargument name="propertyName" type="any" required="false" default="#getPropertyName()#" />
		<cfset var theValue = "" />
		<cfset var methodName = getPropertyMethodName(arguments.propertyName) />
		
		<cfif len(methodName)>
			<!--- Using try/catch to deal with composed objects that throw an error if they aren't loaded --->
			<cftry>
				<cfset theValue = evaluate("variables.theObject.#methodName#") />
				<cfcatch type="any"></cfcatch>
			</cftry>
			<cfif NOT IsDefined("theValue")>
				<cfset theValue = "" />
			</cfif>
			<cfreturn theValue />
		<cfelse>
			<cfthrow type="ValidateThis.core.validation.propertyNotFound"
				message="The property #arguments.propertyName# was not found in the object passed into the validation object." />
		</cfif>
	</cffunction>

	<cffunction name="propertyHasValue" returntype="boolean" access="public" output="false" hint="I determine whether the property that the validation references has a value.">
		<cfargument name="propertyName" type="any" required="false" default="#getPropertyName()#" />
		 <cfset var theVal = getObjectValue(arguments.propertyName) />
		<cfreturn (isSimpleValue(theVal) and len(theVal) gt 0) or (isStruct(theVal) and structCount(theVal) gt 0) or (isArray(theVal) and arrayLen(theVal) gt 0)/>
	</cffunction>

	<cffunction name="propertyExists" returntype="boolean" access="public" output="false" hint="I report whether a property exists in the object being validated.">
		<cfargument name="propertyName" type="any" required="false" default="#getPropertyName()#" />
		<cfreturn len(getPropertyMethodName(arguments.propertyName)) gt 0 />
	</cffunction>

	<cffunction name="getPropertyMethodName" returntype="string" access="public" output="false" hint="I determine the method to use for a given property.">
		<cfargument name="propertyName" type="any" required="false" default="#getPropertyName()#" />
		<cfreturn variables.ObjectChecker.findGetter(variables.theObject,arguments.propertyName) />
	</cffunction>

	<cffunction name="getParameter" access="public" output="false" returntype="any">
		<cfargument name="parameterName" type="string" required="true" />
		<cfif not structKeyExists(variables.instance.parameters,arguments.parameterName)>
			<cfthrow type="ValidateThis.core.validation.parameterDoesNotExist"
				message="The requested parameter (#arguments.parameterName#) has not been defined for the rule." />
		</cfif>
		<cfreturn variables.parameter.load(variables.instance.parameters[arguments.parameterName]) />
	</cffunction>

	<cffunction name="getParameterValue" access="public" output="false" returntype="any">
		<cfargument name="parameterName" type="string" required="true" />
		<cfargument name="defaultValue" type="any" required="false" default="" />
		<cfset var theVal = arguments.defaultValue/>
		<cfif hasParameter(arguments.parameterName)>
			<cfset theVal = getParameter(arguments.parameterName).getValue() />
		</cfif>
		<cfreturn theVal/>
	</cffunction>

	<cffunction name="getParameters" access="public" output="false" returntype="any" hint="This will process the Parameters struct to return just values.">
		<cfset var theParam = 0 />
		<cfset var parameters = {} />
		
		<cfloop collection="#variables.instance.Parameters#" item="theParam">
			<cfset parameters[theParam] = getParameterValue(theParam) />
		</cfloop>
		<cfreturn parameters />
	</cffunction>

	<cffunction name="addParameter" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfargument name="type" type="string" required="false" default="value" />

		<cfset variables.instance.Parameters[arguments.name] = {value=arguments.value,type=arguments.type} />
		
	</cffunction>
	
	<cffunction name="hasParameter" access="public" output="false" returntype="boolean">
		<cfargument name="name" type="string" required="true" />
		<cfreturn structKeyExists(variables.instance.Parameters,arguments.name) />		
	</cffunction>
	
	<cffunction name="hasParameters" access="public" output="false" returntype="boolean">
		<cfreturn structCount(variables.instance.Parameters) gt 0 />
	</cffunction>

	<cffunction name="getValidateThis" access="public" output="false" returntype="any">
		<cfreturn variables.ValidateThis />
	</cffunction>

	<cffunction name="setObjectList" access="public" output="false" returntype="void">
		<cfargument name="objectList" type="array" required="yes" />
		<cfset variables.objectList = arguments.objectList />
	</cffunction>
	<cffunction name="getObjectList" access="public" output="false" returntype="array">
		<cfreturn variables.objectList />
	</cffunction>

	<cffunction name="getMemento" access="public" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="getValType" access="public" output="false" returntype="any">
		<cfreturn variables.instance.ValType />
	</cffunction>
	<cffunction name="setValType" access="public" output="false" returntype="void">
		<cfargument name="ValType" type="any" required="yes" />
		<cfset variables.instance.ValType = arguments.ValType />
	</cffunction>

	<cffunction name="getPropertyName" access="public" output="false" returntype="any">
		<cfreturn variables.instance.PropertyName />
	</cffunction>
	<cffunction name="setPropertyName" access="public" output="false" returntype="void">
		<cfargument name="PropertyName" type="any" required="yes" />
		<cfset variables.instance.PropertyName = arguments.PropertyName />
	</cffunction>

	<cffunction name="getClientFieldName" access="public" output="false" returntype="any">
		<cfreturn variables.instance.ClientFieldName />
	</cffunction>
	<cffunction name="setClientFieldName" access="public" output="false" returntype="void">
		<cfargument name="ClientFieldName" type="any" required="yes" />
		<cfset variables.instance.ClientFieldName = arguments.ClientFieldName />
	</cffunction>

	<cffunction name="getPropertyDesc" access="public" output="false" returntype="any">
		<cfreturn variables.instance.PropertyDesc />
	</cffunction>
	<cffunction name="setPropertyDesc" access="public" output="false" returntype="void">
		<cfargument name="PropertyDesc" type="any" required="yes" />
		<cfset variables.instance.PropertyDesc = arguments.PropertyDesc />
	</cffunction>

	<cffunction name="setParameters" returntype="void" access="public" output="false">
		<cfargument name="Parameters" type="any" required="true" />
		<cfset variables.instance.Parameters = arguments.Parameters />
	</cffunction>
	<cffunction name="setCondition" returntype="void" access="public" output="false">
		<cfargument name="Condition" type="any" required="true" />
		<cfset variables.instance.Condition = arguments.Condition />
	</cffunction>
	<cffunction name="getCondition" access="public" output="false" returntype="any">
		<cfreturn variables.instance.Condition />
	</cffunction>
	<cffunction name="hasCondition" access="public" output="false" returntype="any">
		<cfreturn structCount(getCondition()) gt 0 />
	</cffunction>
	<cffunction name="getConditionName" access="public" output="false" returntype="any">
		<cfreturn getCondition().name />
	</cffunction>
	<cffunction name="hasClientTest" access="public" output="false" returntype="any">
		<cfreturn structKeyExists(getCondition(),"clientTest") />
	</cffunction>
	<cffunction name="getClientTest" access="public" output="false" returntype="any">
		<cfreturn JSStringFormat(getCondition().clientTest) />
	</cffunction>
	<cffunction name="hasServerTest" access="public" output="false" returntype="any">
		<cfreturn structKeyExists(getCondition(),"serverTest") />
	</cffunction>
	<cffunction name="getServerTest" access="public" output="false" returntype="any">
		<cfreturn JSStringFormat(getCondition().serverTest) />
	</cffunction>

	<cffunction name="setTheObject" returntype="void" access="public" output="false">
		<cfargument name="theObject" type="any" required="true" />
		<cfset variables.theObject = arguments.theObject />
	</cffunction>
	<cffunction name="getTheObject" access="public" output="false" returntype="any">
		<cfreturn variables.theObject />
	</cffunction>

	<cffunction name="setIsSuccess" returntype="void" access="public" output="false">
		<cfargument name="IsSuccess" type="any" required="true" />
		<cfset variables.Instance.IsSuccess = arguments.IsSuccess />
	</cffunction>
	<cffunction name="getIsSuccess" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.IsSuccess />
	</cffunction>

	<cffunction name="setFailureMessage" returntype="void" access="public" output="false">
		<cfargument name="FailureMessage" type="any" required="true" />
		<cfset variables.Instance.FailureMessage = arguments.FailureMessage />
	</cffunction>
	<cffunction name="getFailureMessage" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.FailureMessage />
	</cffunction>
	<cffunction name="hasFailureMessage" access="public" output="false" returntype="any">
		<cfreturn len(variables.Instance.FailureMessage) gt 0 />
	</cffunction>

	<cffunction name="setIsRequired" returntype="void" access="public" output="false">
		<cfargument name="IsRequired" type="any" required="true" />
		<cfset variables.Instance.IsRequired = arguments.IsRequired />
	</cffunction>
	<cffunction name="getIsRequired" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.IsRequired />
	</cffunction>

	<cffunction name="setObjectType" returntype="void" access="public" output="false">
		<cfargument name="ObjectType" type="string" required="true" />
		<cfset variables.Instance.ObjectType = arguments.ObjectType />
	</cffunction>
	<cffunction name="getObjectType" access="public" output="false" returntype="string">
		<cfreturn variables.Instance.ObjectType />
	</cffunction>
	
	<cffunction name="setCurrentLocale" access="public" output="false" returntype="any">
		<cfargument name="currentLocale" type="string" required="false" default="" />
		<cfset variables.currentLocale = arguments.currentLocale/>
	</cffunction>
	<cffunction name="getCurrentLocale" access="public" output="false" returntype="any">
		<cfreturn variables.currentLocale/>
	</cffunction>
	
	<cffunction name="setContext" access="public" output="false" returntype="any">
		<cfargument name="context" type="string" required="false" default="" />
		<cfset variables.context = arguments.context/>
	</cffunction>
	<cffunction name="getContext" access="public" output="false" returntype="any">
		<cfreturn variables.context/>
	</cffunction>

	<cffunction name="setProcessOn" access="public" output="false" returntype="any">
		<cfargument name="processOn" type="string" required="false" default="" />
		<cfset variables.processOn = arguments.processOn/>
	</cffunction>
	<cffunction name="getProcessOn" access="public" output="false" returntype="any">
		<cfreturn variables.processOn/>
	</cffunction>

	<cffunction name="setResult" access="public" output="false" returntype="any">
		<cfargument name="result" type="any" required="false" default="" />
		<cfset variables.Instance.result = arguments.result/>
	</cffunction>
	<cffunction name="getResult" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.result/>
	</cffunction>
	<cffunction name="hasResult" access="public" output="false" returntype="boolean">
		<cfreturn isObject(variables.Instance.result) />
	</cffunction>

</cfcomponent>
	

