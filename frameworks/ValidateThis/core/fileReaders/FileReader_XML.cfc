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
<cfcomponent output="false" extends="BaseFileReader" hint="I am a responsible for reading and processing an XML file.">

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I read the validations XML file and reformat it into a struct">
		<cfargument name="objectType" type="string" required="true" hint="the type of object for which a BOValidator is being created" />
		<cfargument name="metadataSource" type="any" required="true" hint="the path to the file to read" />

		<cfset var theXML = "">
		<cfset var XmlErrors = {}>
		<cfset var theProperties = []>
		
		<cftry>
			<cfset theXML = XMLParse(arguments.metadataSource) />	
			<cfcatch>
				<cfthrow type="ValidateThis.core.fileReaders.Filereader_XML.invalidXML" detail="The content of the file #arguments.metadataSource# is not valid XML" />
			</cfcatch>
		</cftry>
		
		<cfif variables.debuggingMode neq "none">
			<cfset xmlErrors = XMLValidate( theXML, ExpandPath( "/validatethis/core/validateThis.xsd" ) )>
			<cfif !xmlErrors.status>
				<cfif variables.debuggingMode eq "strict">
					<cfthrow type="ValidateThis.core.fileReaders.Filereader_XML.invalidXML" detail="The xml in the file #arguments.metadataSource# does not validate against the validateThis.xsd. #SerializeJSON( XmlErrors )#" />
				<cfelse>
					<cflog type="warning" text="ValidateThis.core.fileReaders.Filereader_XML.invalidXML. The xml in the file #arguments.metadataSource# does not validate against the validateThis.xsd. #SerializeJSON( XmlErrors )#" />
				</cfif>
			</cfif>
		</cfif>
		
		<cfset theProperties = convertXmlCollectionToArrayOfStructs(XMLSearch(theXML,"//property")) />
		
		<cfset processConditions(convertXmlCollectionToArrayOfStructs(XMLSearch(theXML,"//condition"))) />
		<cfset processContexts(convertXmlCollectionToArrayOfStructs(XMLSearch(theXML,"//context"))) />
		<cfset processPropertyDescs(theProperties) />
		<cfset processPropertyRules(arguments.objectType,theProperties) />

	</cffunction>

	<cffunction name="convertXmlCollectionToArrayOfStructs" returnType="any" access="private" output="false" hint="I take data from an XML document and convert it into a standard array of structs">
		<cfargument name="xmlCollection" type="any" required="true" />
		
		<cfset var newArray = [] />
		<cfset var newStruct = 0 />
		<cfset var element = 0 />
		
		<cfloop array="#arguments.xmlCollection#" index="element">
			<cfset newStruct = {} />
			<cfset structAppend(newStruct,element.XmlAttributes) />
			<cfif structKeyExists(element,"XMLChildren") and isArray(element.XMLChildren) and arraylen(element.XMLChildren) gt 0>
				<cfset newStruct[element.XMLChildren[1].XmlName & "s"] = convertXmlCollectionToArrayOfStructs(element.XMLChildren) />
			</cfif>
			<cfset arrayAppend(newArray,newStruct) />
		</cfloop>
		<cfreturn newArray />
	
	</cffunction>

</cfcomponent>
	

