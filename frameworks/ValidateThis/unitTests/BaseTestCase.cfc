<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
--->
<cfcomponent extends="mxunit.framework.TestCase">
	
	<cfset variables.beansXML = "">
	
	<cffunction name="setBeanFactory" access="private" output="false" returntype="void">
		<cfargument name="beansXML" type="string" required="false" default="" />
		<cfargument name="MockList" type="struct" required="false" default="#StructNew()#" />
		<cfargument name="params" type="struct" required="false" default="#StructNew()#" />
		<cfargument name="baseBeanPath" type="any" required="false" default="/validatethis/samples/BODemo/model/config/Coldspring.xml.cfm" />
		<cfargument name="forceRefresh" type="any" required="false" default="false" />
		
		
		<cfset var xmlFile = 0 />
		
		<cfif arguments.forceRefresh OR NOT structkeyExists(variables,"beanFactory") OR comparenocase(variables.beansXML,arguments.beansXML) neq 0>
			<cfset variables.beansXML = arguments.beansXML />
			<cfset variables.beanFactory = createObject("component" ,"coldspring.beans.DefaultXmlBeanFactory").init(defaultProperties=arguments.params) />
			<cfset variables.beanFactory.loadBeans(expandPath(arguments.baseBeanPath)) />
			<cfif ListLen(arguments.beansXML)>
				<cfloop list="#variables.beansXML#" index="xmlFile">
					<cfset variables.beanFactory.loadBeans(xmlFile) />	
				</cfloop>
			</cfif>
			<cfif NOT StructIsEmpty(arguments.MockList)>
				<cfset variables.beanFactory.loadBeansFromXmlRaw(createMockXML(arguments.MockList)) />	
			</cfif>	
		</cfif>
	</cffunction>
	
	<cffunction name="createMockXML" access="private" output="false" returntype="any">
		<cfargument name="MockList" type="struct" required="true" />
		
		<cfset var xmlText = "" />
		<cfset var bean = 0 />
		
		<cfsavecontent variable="xmlText">
			<cfoutput>
				<beans>
				<cfloop collection="#arguments.MockList#" item="bean">
					<bean id="#bean#" factory-bean="MockFactory" factory-method="createMock">
						<constructor-arg name="objectToMock">
							<value>#arguments.MockList[bean]#</value>
						</constructor-arg>
					</bean>
				</cfloop>
				</beans>
			</cfoutput>
		</cfsavecontent>

		<cfreturn xmlText />		
	</cffunction>

	<cffunction name="getBeanFactory" access="private" output="false" returntype="any">
		<cfreturn variables.beanFactory>
	</cffunction>

	<cffunction name="getVTConfig" access="private" returntype="struct">
		<cfscript>
			// Deafult values copied from ValidateThis.cfc
			ValidateThisConfig = {};
			ValidateThisConfig.TranslatorPath="ValidateThis.core.BaseTranslator";
			ValidateThisConfig.LocaleLoaderPath="ValidateThis.core.BaseLocaleLoader";
			ValidateThisConfig.BOValidatorPath="ValidateThis.core.BOValidator";
			ValidateThisConfig.DefaultJSLib="jQuery";
			ValidateThisConfig.JSRoot="js/";
			ValidateThisConfig.defaultFormName="frmMain";
			ValidateThisConfig.definitionPath="/validatethis/samples/model/";
			ValidateThisConfig.localeMap={en_US='/ValidateThis/locales/en_US.properties'};
			ValidateThisConfig.defaultLocale="en_US";
			ValidateThisConfig.abstractGetterMethod="";
			ValidateThisConfig.ExtraRuleValidatorComponentPaths="";
			ValidateThisConfig.extraClientScriptWriterComponentPaths="";
			ValidateThisConfig.extraFileReaderComponentPaths="";
			ValidateThisConfig.ResultPath="ValidateThis.util.Result";
			ValidateThisConfig.externalFileTypes="xml,json";
			ValidateThisConfig.injectResultIntoBO=false;
			ValidateThisConfig.JSIncludes=true;
			ValidateThisConfig.defaultFailureMessagePrefix="The ";
			ValidateThisConfig.BOComponentPaths="";
			ValidateThisConfig.extraAnnotationTypeReaderComponentPaths="";
			ValidateThisConfig.debuggingMode="none";
			ValidateThisConfig.vtFolder="ValidateThis";
			return ValidateThisConfig;
		</cfscript>
	</cffunction>

</cfcomponent>


