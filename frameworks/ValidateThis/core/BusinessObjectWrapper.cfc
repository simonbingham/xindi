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
<cfcomponent displayname="BusinessObjectWrapper" output="false" hint="I wrap a Business Object to allow for 'shadow' properties.">

	<cffunction name="Init" access="Public" returntype="any" output="false" hint="I am the constructor">

		<!---<cfargument name="theObject" type="any" required="yes" hint="The Object to be wrapped" />--->

		<cfset variables.instance = StructNew() />
		<!---<cfset variables.instance.theObject = arguments.theObject />--->
		<cfset variables.instance.invalidVars = StructNew() />
		<cfreturn this />
	</cffunction>

	<cffunction name="setup" access="Public" returntype="any" output="false" hint="I am called after the constructor to load data into an instance">
		<cfargument name="theObject" type="any" required="yes" hint="The Object to be wrapped" />
		<cfset variables.instance.theObject = arguments.theObject />
		<cfreturn this />
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="Very useful!">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />
		
		<cfset var varName = ReplaceNoCase(arguments.missingMethodName,"get","") />

		<cfif Left(arguments.missingMethodName,3) EQ "get" AND StructKeyExists(variables.instance.invalidVars,varName)>
			<cfreturn variables.instance.invalidVars[varName] />
		<cfelse>
			<cfinvoke component="#variables.instance.theObject#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="returnValue" />
			<!--- trap null values --->
			<cfif NOT IsDefined("returnValue")>
				<cfset returnValue = "" />
			</cfif>
			<cfreturn returnValue />
		</cfif>
		
	</cffunction>

	<cffunction name="setInvalid" access="public" output="false" returntype="void" hint="Allows for invlaid values to be stored in the wrapper">
		<cfargument name="varName" type="any" required="true" />
		<cfargument name="varValue" type="any" required="true" />
		
		<cfset variables.instance.invalidVars[arguments.varName] = arguments.varValue />
		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn getTheObject().testCondition(arguments.Condition) />

	</cffunction>


	<cffunction name="getTheObject" access="public" output="false" returntype="any">
		<cfreturn variables.instance.TheObject />
	</cffunction>
	<cffunction name="setTheObject" returntype="void" access="public" output="false">
		<cfargument name="TheObject" type="any" required="true" />
		<cfset variables.instance.TheObject = arguments.TheObject />
	</cffunction>

</cfcomponent>
	

