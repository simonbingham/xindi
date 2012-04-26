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
<cfcomponent output="false" hint="I am a transient Parameter object.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I am the constructor">
		<cfreturn this />
	</cffunction>

	<cffunction name="setup" access="Public" returntype="any" output="false" hint="I am called after the constructor to load data into an instance">
		<cfargument name="validation" type="any" required="yes" hint="The validation object associated with this parameter" />
		<cfset variables.validation = arguments.validation />
		<cfreturn this />
	</cffunction>

	<cffunction name="load" access="Public" returntype="any" output="false" hint="I load a fresh parameter definition into the parameter object, which allows it to be reused">
		<cfargument name="paramStruct" type="any" required="yes" hint="The validation struct from the xml file" />
		<cfset variables.instance = duplicate(arguments.paramStruct) />
		<cfreturn this />
	</cffunction>

	<cffunction name="getValue" access="public" output="false" returntype="any">
		<cfif variables.instance.type eq "value">
			<cfreturn variables.instance.value />
		</cfif>
		<cfif variables.instance.type eq "expression">
			<cfreturn variables.validation.getTheObject().evaluateExpression(variables.instance.value) />
		</cfif>
		
		<cfif variables.instance.type eq "property">
			<cfreturn variables.validation.getObjectValue(variables.instance.value) />
		</cfif>
	</cffunction>

	<cffunction name="getMemento" access="public" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>
	

