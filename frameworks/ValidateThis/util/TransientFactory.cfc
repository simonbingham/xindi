<!--- 
   Copyright 2007 Paul Marcotte, Bob Silverberg

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

 --->
<cfcomponent output="false" hint="I create Transient objects.">

	<!--- public --->

	<cffunction name="init" access="public" output="false" returntype="any" hint="returns a configured transient factory">
		<cfargument name="lightWire" type="any" required="yes" />
		<cfset variables.lightWire = arguments.lightWire />
		<cfset variables.afterCreateMethod = "setup" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="any" hint="returns a configured, autowired transient">
		<cfargument name="transientName" type="string" required="true">
		<cfargument name="afterCreateArgs" type="struct" required="false" default="#structNew()#">
		
		<cfset var temp = ''/>
		<cfset var key = ''/>
		<cfset var obj = variables.lightWire.getTransient(arguments.transientName) />
		<cfif StructKeyExists(obj,variables.afterCreateMethod)>
			<!--- TODO: http://groups.google.com/group/validatethis/browse_thread/thread/8c72b46ed61de4c4 --->
			<cfloop collection="#arguments.afterCreateArgs#" item="key">
		        <cfset temp = arguments.afterCreateArgs[key] />
		        <cfset StructDelete(arguments.afterCreateArgs, key) />
		        <cfset arguments.afterCreateArgs[JavaCast('string', key)] = temp />
			</cfloop> 
			<cfinvoke component="#obj#" method="#variables.afterCreateMethod#" argumentcollection="#arguments.afterCreateArgs#" />
		</cfif>
		<cfreturn obj>
	</cffunction>

	<cffunction name="newValidation" access="public" output="false" returntype="any" hint="a concrete method to allow for the ValidateThis facade object to be injected into a validation">
		<cfargument name="theObject" type="any" required="no" default="" hint="The object being validated" />
		<cfargument name="objectList" type="any" required="no" default="#arrayNew(1)#" hint="A list of objects already validated" />
		
		<cfset var validation = variables.lightWire.getTransient("Validation") />
		<cfset validation.setup(ValidateThis=variables.validateThis,theObject=arguments.theObject,objectList=arguments.objectList) />
		<cfreturn validation>
		
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="any" hint="provides virtual api [new{transientName}] for any registered transient.">
		<cfargument name="MissingMethodName" type="string" required="true" />
		<cfargument name="MissingMethodArguments" type="struct" required="true" />
		<cfif (Left(arguments.MissingMethodName,3) eq "new")>
			<cfreturn create(Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-3),arguments.MissingMethodArguments)>
		</cfif>
	</cffunction>

	<cffunction name="setValidateThis" access="public" returntype="any">
		<cfargument name="validateThis" />
		<cfset variables.validateThis = arguments.validateThis />
		<cfreturn this />
	</cffunction>
	
</cfcomponent>