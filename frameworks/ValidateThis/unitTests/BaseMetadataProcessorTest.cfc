<!---
	// **************************************** LICENSE INFO **************************************** \\

	Copyright 2010, Bob Silverberg

	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in
	compliance with the License.  You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software distributed under the License is
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied.  See the License for the specific language governing permissions and limitations under the
	License.

--->
<cfcomponent extends="validatethis.unitTests.BaseTestCase" output="false">

	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			baseMetadataProcessor = CreateObject("component","ValidateThis.core.BaseMetadataProcessor").init();
			makePublic(baseMetadataProcessor,"processPropertyRules");
			injectMethod(baseMetadataProcessor, this, "getVariables", "getVariables");
		</cfscript>
		<cfsavecontent variable="jsonMetadata">
			<cfinclude template="/validatethis/samples/AnnotationDemo/model/json/user.json" />
		</cfsavecontent>
	</cffunction>

	<cffunction name="getVariables" access="public" output="false" returntype="any" hint="Used to retrieve the ATRs for testing.">
		<cfreturn variables />
	</cffunction>

	<cffunction name="processPropertyDescsDescriptionShouldOverwriteIdenticalName" access="public" returntype="void">
		<cfscript>
			// Note the difference in name/desc case
			properties = [{name="NAME",desc="Name",rules=[{type="required",params=[{name="min",value=5,type="expression"},{name="max",value=10,type="value"}]}]}];

			makePublic(baseMetadataProcessor,"processPropertyDescs");
			baseMetadataProcessor.processPropertyDescs(properties);
			vars = baseMetadataProcessor.getVariables();

			assertTrue(structKeyExists(vars.propertyDescs,"NAME"),"The key NAME should be in propertyDescs");
			assertEquals(0, compare(vars.propertyDescs["NAME"],"Name") );
		</cfscript>
	</cffunction>

	<cffunction name="processPropertyRulesShouldPickupTypeAttribute" access="public" returntype="void">
		<cfscript>
			properties = [{name="theName",rules=[{type="required",params=[{name="min",value=5,type="expression"},{name="max",value=10,type="value"}]}]}];
			baseMetadataProcessor.processPropertyRules("user",properties);
			validations = baseMetadataProcessor.getVariables().validations;
			parameters = validations.contexts.___default[1].parameters;
			assertEquals(true,isStruct(parameters.min));
			assertEquals(5,parameters.min.value);
			assertEquals("expression",parameters.min.type);
			assertEquals(10,parameters.max.value);
			assertEquals("value",parameters.max.type);
		</cfscript>
	</cffunction>

	<cffunction name="processPropertyRulesShouldAddObjectTypeToEachValidation" access="public" returntype="void">
		<cfscript>
			properties = [{name="theName",rules=[{type="required"},{type="email"}]}];
			baseMetadataProcessor.processPropertyRules("user",properties);
			validations = baseMetadataProcessor.getVariables().validations;
			validations = validations.contexts.___default;
			assertEquals("user",validations[1].objectType);
			assertEquals("user",validations[2].objectType);
		</cfscript>
	</cffunction>

	<cffunction name="processPropertyRulesShouldPickupProcessOnAttribute" access="public" returntype="void">
		<cfscript>
			properties = [{name="theName",rules=[{type="required",processOn="client"}]}];
			baseMetadataProcessor.processPropertyRules("user",properties);
			validations = baseMetadataProcessor.getVariables().validations;
			rule = validations.contexts.___default[1];
			assertEquals(true,structKeyExists(rule,"processOn"));
			assertEquals("client",rule.processOn);
		</cfscript>
	</cffunction>

	<cffunction name="processPropertyRulesShouldAddDefaultProcessOnToEachValidation" access="public" returntype="void">
		<cfscript>
			properties = [{name="theName",rules=[{type="required",processOn="server"},{type="email"}]}];
			baseMetadataProcessor.processPropertyRules("user",properties);
			validations = baseMetadataProcessor.getVariables().validations;
			validations = validations.contexts.___default;
			assertEquals("server",validations[1].processOn);
			assertEquals("both",validations[2].processOn);
		</cfscript>
	</cffunction>

</cfcomponent>

