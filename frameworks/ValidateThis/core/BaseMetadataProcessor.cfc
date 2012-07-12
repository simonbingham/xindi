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
<cfcomponent output="false" hint="I am a responsible for reading and processing an XML file.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new metadataprocessor">

		<cfset variables.propertyDescs = {} />
		<cfset variables.clientFieldDescs = {} />
		<cfset variables.clientFieldNames = {} />
		<cfset variables.conditions = {} />
		<cfset variables.contexts = {} />
		<cfset variables.formContexts = {} />
		<cfset variables.validations = {contexts = {___Default = ArrayNew(1)}} />
		<cfreturn this />
	</cffunction>

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I read the validations XML file and reformat it into a struct">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" />

		<cfthrow type="ValidateThis.core.BaseMetadataProcessor.MissingImplementation" detail="The loadRules method must be implemented in a concrete object" />

	</cffunction>

	<cffunction name="getValidations" returnType="struct" access="public" output="false" hint="I return the processed metadata in a struct that is expected by the BOValidator">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" hint="the source of the metadata - may be a filename or a metadata struct" />

		<cfset var returnStruct = 0 />

		<cfset loadRules(arguments.objectType,arguments.metadataSource) />
		<cfset returnStruct = {propertyDescs=variables.propertyDescs,clientFieldDescs=variables.clientFieldDescs,clientFieldNames=variables.clientFieldNames,formContexts=variables.formContexts,validations=variables.validations} />
		<cfreturn returnStruct />
	</cffunction>

	<cffunction name="determineLabel" returntype="string" output="false" access="private">
	<cfargument name="label" type="string" required="true" />

	<cfset var i = "" />
	<cfset var char = "" />
	<cfset var result = "" />

	<cfloop from="1" to="#len(arguments.label)#" index="i">
		<cfset char = mid(arguments.label, i, 1) />

		<cfif i eq 1>
			<cfset result = result & ucase(char) />
		<cfelseif asc(lCase(char)) neq asc(char)>
			<cfset result = result & " " & ucase(char) />
		<cfelse>
			<cfset result = result & char />
		</cfif>
	</cfloop>

	<cfreturn result />
	</cffunction>

	<cffunction name="processConditions" returnType="void" access="private" output="false" hint="I process condition metadata">
		<cfargument name="conditions" type="any" required="true" />

		<cfset var theCondition = 0 />

		<cfloop array="#arguments.conditions#" index="theCondition">
			<cfset variables.conditions[theCondition.name] = theCondition />
		</cfloop>
	</cffunction>

	<cffunction name="processContexts" returnType="void" access="private" output="false" hint="I process context metadata">
		<cfargument name="contexts" type="any" required="true" />

		<cfset var theContext = 0 />

		<cfloop array="#arguments.contexts#" index="theContext">
			<cfset variables.contexts[theContext.name] = theContext />
			<cfif structKeyExists(theContext,"formName")>
				<cfset variables.formContexts[theContext.name] = theContext.formName />
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="processPropertyDescs" returnType="any" access="private" output="false" hint="I process property descriptions">
		<cfargument name="properties" type="any" required="true" />

		<cfset var theProperty = 0 />
		<cfset var theName = 0 />
		<cfset var theDesc = 0 />

		<cfloop array="#arguments.properties#" index="theProperty">
			<cfset theName = theProperty.name />
			<cfif StructKeyExists(theProperty,"desc")>
				<cfset theDesc = theProperty.desc />
			<cfelse>
				<cfset theDesc = determineLabel(theName) />
			</cfif>
			<cfif (StructKeyExists(theProperty,"desc") AND len(theProperty["desc"])) OR theDesc neq theName>
				<cfset variables.propertyDescs[theName] = theDesc />
				<cfif StructKeyExists(theProperty,"clientfieldname")>
					<cfset variables.clientFieldDescs[theProperty.clientfieldname] = theDesc />
				<cfelse>
					<cfset variables.clientFieldDescs[theName] = theDesc />
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="processPropertyRules" returnType="any" access="private" output="false" hint="I process property rules">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="properties" type="any" required="true" />

		<cfset var theProperty = 0 />
		<cfset var theRule = 0 />
		<cfset var theVal = 0 />
		<cfset var theParam = 0 />
		<cfset var paramType = 0 />
		<cfset var propertyType = 0 />
		<cfset var theContext = 0 />

		<!--- Must determine all Contexts first in order to add rules in the proper sequence --->
		<cfloop array="#arguments.properties#" index="theProperty">
			<cfif structKeyExists(theProperty,"rules")>
				<cfloop array="#theProperty.rules#" index="theRule">
					<cfif structKeyExists(theRule,"contexts")>
						<cfloop list="#theRule.contexts#" index="theContext">
							<cfif theContext NEQ "*" AND NOT structKeyExists(variables.validations.contexts,theContext)>
								<cfset variables.validations.contexts[theContext] = ArrayNew(1) />
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>

		<cfloop array="#arguments.properties#" index="theProperty">
			<cfif structKeyExists(theProperty,"rules")>
				<cfloop array="#theProperty.rules#" index="theRule">
					<cfset theVal = {objectType = arguments.objectType, propertyName = theProperty.name, valType = theRule.type, parameters = structNew(), processOn = "both"} />
					<cfif StructKeyExists(theProperty,"desc")>
						<cfset theVal.PropertyDesc = theProperty.desc />
					<cfelse>
						<cfset theVal.PropertyDesc = determineLabel(theVal.PropertyName) />
					</cfif>
					<cfif StructKeyExists(theProperty,"clientfieldname")>
						<cfset theVal.ClientFieldName = theProperty.clientfieldname />
					<cfelse>
						<cfset theVal.ClientFieldName = theVal.PropertyName />
					</cfif>
					<cfset variables.clientFieldNames[theProperty.name] = theVal.ClientFieldName />
					<cfif structKeyExists(theRule,"params")>
						<cfloop array="#theRule.params#" index="theParam">
							<cfset theVal.parameters[theParam.name] = theParam />
							<cfif NOT structKeyExists(theParam,"type")>
								<cfset theVal.parameters[theParam.name].type = "value" />
							</cfif>
							<cfloop list="compareProperty,dependentProperty" index="propertyType">
								<cfif theParam.name eq propertyType & "Name">
									<cfset theVal.parameters[propertyType & "Desc"] = {type="value"} />
									<cfif structKeyExists(variables.propertyDescs,theParam.value)>
										<cfset theVal.parameters[propertyType & "Desc"].value = variables.propertyDescs[theParam.value] />
									<cfelse>
										<cfset theVal.parameters[propertyType & "Desc"].value = determineLabel(theParam.value) />
									</cfif>
								</cfif>
							</cfloop>
						</cfloop>
					</cfif>
					<cfif structKeyExists(theRule,"failureMessage")>
						<cfset theVal.failureMessage = theRule.failureMessage />
					</cfif>
					<cfif structKeyExists(theRule,"condition") AND structKeyExists(variables.conditions,theRule.condition)>
						<cfset theVal.condition = variables.conditions[theRule.condition] />
					<cfelse>
						<cfset theVal.condition = {} />
					</cfif>
					<cfif structKeyExists(theRule,"processOn")>
						<cfset theVal.processOn = theRule.processOn />
					</cfif>
					<cfif NOT structKeyExists(theRule,"contexts") OR listFind(theRule.contexts,"*")>
						<cfloop collection="#variables.validations.contexts#" item="theContext">
							<cfset arrayAppend(variables.validations.contexts[theContext],theVal) />
						</cfloop>
					<cfelse>
						<cfloop list="#theRule.contexts#" index="theContext">
							<cfset arrayAppend(variables.validations.contexts[theContext],theVal) />
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cffunction>

</cfcomponent>


