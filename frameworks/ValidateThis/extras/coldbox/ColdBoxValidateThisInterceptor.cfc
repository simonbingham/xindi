<!---
	
	Copyright 2011, John Whish, Adam Drew, & Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent name="ColdBoxValidateThis"
			 extends="coldbox.system.interceptor" 
			 hint="I load and configure ValidateThis" 
			 output="false">

	<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="Configure" access="public" returntype="void" hint="This is the configuration method for your interceptor" output="false" >
		
		<cfscript>
			// If no definitionPath was defined, use the ModelsPath and (optionally) the ModelsExternalLocation from the ColdBox config
			if (NOT propertyExists("definitionPath"))
			{
				setProperty("definitionPath", getController().getSetting("ModelsPath") & "/");
				if (propertyExists("ModelsExternalLocation") AND Len(getController().getSetting("ModelsExternalLocation")))
				{
					setProperty("definitionPath", getProperty("definitionPath") & getController().getSetting("ModelsExternalLocation"));
				}
			}
			
			// Coldbox has i18n configured
			if (getController().settingExists("defaultLocale") AND getController().getSetting("defaultLocale") neq "")
			{
				if (NOT propertyExists("defaultLocale"))
				{
					// set ValidateThis up to use ColdBox default Locale
					setProperty("defaultLocale", getController().getSetting("defaultLocale"));
				}
				if (NOT propertyExists("translatorPath"))
				{
					// a custom translator hasn't been set so use ValidateThis.extras.coldbox.model.ColdBoxRBTranslator
					setProperty("translatorPath", "ValidateThis.extras.coldbox.ColdBoxRBTranslator");
				}
			}
			
			// name of key to use in the cache
			if (NOT propertyExists('ValidateThisCacheKey'))
			{
				setProperty('ValidateThisCacheKey',"ValidateThis");
			}
			// name of key to use in the prc
			if (NOT propertyExists('ValidationResultKey'))
			{
				setProperty("ValidationResultKey","ValidationResult");
			}
		</cfscript>
				
	</cffunction>
	
	<!------------------------------------------- INTERCEPTION POINTS ------------------------------------------->

	<!--- After Aspects Load --->
	<cffunction name="afterAspectsLoad" access="public" returntype="void" output="false" hint="Load ValidateThis after configuration has loaded">
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		
		<cfscript>
		var ValidateThis = "";
			
		ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(getProperties());
		
		if (getController().settingExists("defaultLocale") AND getController().getSetting("defaultLocale") neq "")
		{
			// inject the ColdBox resource bundle into the translator, this does assume that if a custom translator has been defined it will have a setResourceBundle() method
			try
			{
				ValidateThis.getBean("Translator").setResourceBundle(getPlugin("ResourceBundle"));
			}
			catch(Any exception) 
			{
				// using the logger plugin for compatibility with ColdBox 2.6 and ColdBox 3
				getPlugin("logger").error("ColdBoxValidateThisInterceptor error: setResourceBundle method not found in  #getProperty('translatorPath')#");
			}
		}

		// ValidateThis is loaded and configured so cache it
		setValidateThis(ValidateThis);
		
		// using the logger plugin for compatibility with ColdBox 2.6 and ColdBox 3
		logMessage("loaded", SerializeJSON(ValidateThis.getValidateThisConfig()));
		</cfscript>

	</cffunction>
	
	<!--- Validate API --->
	<cffunction name="preValidate" access="public" returntype="void" output="false" hint="Perform validation via ValidateThis Facade">
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="validation request for validate.">
		<cfscript>
			// using the logger plugin for compatibility with ColdBox 2.6 and ColdBox 3
			logMessage("preValidate", SerializeJSON(arguments.interceptData));
		</cfscript>
	</cffunction>

	<cffunction name="validate" access="public" returntype="void" output="false" hint="Perform validation via ValidateThis Facade">
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">

		<cfscript>
			var rc = arguments.event.getCollection();
			var prc = arguments.event.getCollection(private=true);
			var currentResult = getValidationResultInRequest(arguments.event);
			var validation = {};
			
			arguments.interceptData[getProperty("ValidationResultKey")] = currentResult;
			
			// Announce beforeValidate interception point
			announceInterception("preValidate",arguments.event.getCollection());

			// validate 
			currentResult = getValidateThis().validate(argumentCollection=arguments.interceptData);
			
			// set results in request collection
			setValidationResultInRequest(event,currentResult);

			// log result using the logger plugin for compatibility with ColdBox 2.6 and ColdBox 3
			logMessage("validate", SerializeJSON(currentResult.getErrors()));

			// Announce afterValidate interception point
			announceInterception("postValidate");

		</cfscript>
	</cffunction>

	<cffunction name="postValidate" access="public" returntype="void" output="false" hint="Perform validation via ValidateThis Facade">
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="resultObject returned from validate.">
		<cfscript>
			logMessage("postValidate", SerializeJSON(arguments.event.getCollection()));
		</cfscript>
	</cffunction>

	<cffunction name="prepareValidationRequest" access="public" returntype="void" output="false" hint="Prepare Event Collection for Validate Facade">
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		<cfscript>
			var rc = arguments.event.getCollection();
			
			arguments.event.paramValue("context","");
			arguments.event.paramValue("locale","");
			arguments.event.paramValue("objectType","");
			arguments.event.paramValue("theObject","");
			
			if (!isStruct(arguments.event.getValue('theObject')) or !isObject(arguments.event.getValue('theObject'))){
				announceInterception("getObjectForValidation");
			}
			
			getValidationResultInRequest(arguments.event);
		</cfscript>
	</cffunction>

	<cffunction name="loadValidators" access="public" returntype="void" output="false" hint="Prepare Validators For Given Objects, Types">
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		<cfscript>
			if (structKeyExists(arguments.interceptData,"objectlist")){
				arguments.event.setValue("ValidatorNames",getValidateThis().loadValidators(arguments.interceptData.objectlist));
			}
		</cfscript>
	</cffunction>
	
	<!------------------------------------------- PRIVATE METHODS ------------------------------------------->
	<cffunction name="logMessage" access="private" returntype="void" output="false">
		<cfargument name="message" type="string"/>
		<cfargument name="extrainfo" type="string"/>
		<cfscript>
			getPlugin("logger").info("ValidateThis " & getValidateThis().getVersion() & " " & arguments.message,arguments.extrainfo);
		</cfscript>
	</cffunction>
	
	<cffunction name="getValidateThis" access="private" returntype="any" output="false">
		<cfreturn getColdboxOCM().get(getProperty('ValidateThisCacheKey'))/>
	</cffunction>
	<cffunction name="setValidateThis" access="private" returntype="void" output="false">
		<cfargument name="ValidateThis" type="any" required="true">
		<cfset getColdboxOCM().set(getProperty('ValidateThisCacheKey'),arguments.ValidateThis,0)/>
	</cffunction>
	
	<cffunction name="setValidationResultInRequest" access="private" returntype="void" output="false">
		<cfargument name="event" type="any" required="true">
		<cfargument name="result" type="any" required="true">
		<cfset var rc = event.getCollection()/>
		<cfset rc[getProperty("ValidationResultKey")] = arguments.result/>
	</cffunction>
	<cffunction name="getValidationResultInRequest" access="private" returntype="any" output="false">
		<cfargument name="event" type="any" required="true">
		<cfset var rc = arguments.event.getCollection()/>
		<cfif !structKeyExists(rc,getProperty("ValidationResultKey"))>
			<cfset setValidationResultInRequest(arguments.event,getValidateThis().newResult(theObject=arguments.event.getValue("theObject",StructNew())))>
		</cfif>
		<cfreturn rc[getProperty("ValidationResultKey")]/>
	</cffunction>

</cfcomponent>