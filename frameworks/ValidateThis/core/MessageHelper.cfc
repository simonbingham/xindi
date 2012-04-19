<!---
	
	Copyright 2011, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	Based on javaRB.cfc by paul hastings <paul@sustainableGIS.com>, see his notes below
	
--->
<!--- 

author:		paul hastings <paul@sustainableGIS.com>
date:		08-december-2003

revisions:	15-mar-2005	fixed un-scoped var variable in formatRBString method.
			4-mar-2006	added messageFormat,verifyPattern method

notes:		the purpose of this CFC is to extract text resources from a pure java resource bundle. these
			resource bundles should be produced by a tools such as IBM's rbManager and consist of:
				key=ANSI escaped string such as
				(english, no need for ANSI escaped chars)
				Cancel=Cancel
				Go=Ok
				(thai, ANSI escaped chars)
				Cancel=\u0E22\u0E01\u0E40\u0E25\u0E34\u0E01
				Go=\u0E44\u0E1B			

methods in this CFC:
	- getResourceBundle returns a structure containing all key/messages value pairs in a given resource 
	bundle file. required argument is rbFile containing absolute path to resource bundle file. optional
	argument is rbLocale to indicate which locale's resource bundle to use, defaults to us_EN (american
	english). PUBLIC
	- getRBKeys returns an array holding all keys in given resource bundle. required argument is rbFile 
	containing absolute path to resource bundle file. optional argument is rbLocale to indicate which 
	locale's resource bundle to use, defaults to us_EN (american english). PUBLIC
	- getRBString returns string containing the text for a given key in a given resource bundle. required
	arguments are rbFile containing absolute path to resource bundle file and rbKey a string holding the 
	required key. optional argument is rbLocale to indicate which locale's resource bundle to use, defaults
	to us_EN (american english). PUBLIC
	- formatRBString returns string w/dynamic values substituted. performs messageFormat like 
	operation on compound rb string: "You owe me {1}. Please pay by {2} or I will be forced to 
	shoot you with {3} bullets." this function will replace the place holders {1}, etc. with 
	values from the passed in array (or a single value, if that's all there are). required 
	arguments are rbString, the string containing the placeholders, and substituteValues either 
	an array or a single value containing the values to be substituted. note that the values 
	are substituted sequentially, all {1} placeholders will be substituted using the first 
	element in substituteValues, {2} with the  second, etc. DEPRECATED. only retained for 
	backwards compatibility. please use messageFormat method instead.
	- messageFormat returns string w/dynamic values substituted. performs MessageFormat 
	operation on compound rb string.  required arguments: pattern string to use as pattern for 
	formatting, args array of "objects" to use as substitution values. optional argument is 
	locale, java style locale 	ID, "th_TH", default is "en_US". for details about format 
	options please see http://java.sun.com/j2se/1.4.2/docs/api/java/text/MessageFormat.html
	- verifyPattern verifies MessageFormat pattern. required argument is pattern a string 
	holding the MessageFormat pattern to test. returns a boolean indicating if the pattern is 
	ok or not. PUBLIC	
	
 --->

<cfcomponent output="false" hint="I am a transient Parameter object.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I am the constructor">
		<cfargument name="rbTranslator" type="any" required="true" />
		<cfargument name="defaultFailureMessagePrefix" type="string" required="true" />

		<cfset variables.rbTranslator = arguments.rbTranslator />
		<cfset variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix />
		<cfset variables.defaultLocale = variables.rbTranslator.getDefaultLocale() />
		<cfreturn this />
	</cffunction>

	<cffunction name="messageFormat" access="public" output="no" returnType="string" hint="performs messageFormat on compound rb string">
		<cfargument name="thisPattern" required="yes" type="string" hint="pattern to use in formatting">
		<cfargument name="args" required="yes" hint="substitution values"> <!--- array or single value to format --->
		<cfargument name="thisLocale" required="no" default="en_US" hint="locale to use in formatting, defaults to en_US">
		<cfset var msgFormat=createObject("java", "java.text.MessageFormat") />
		<cfset var locale=createObject("java","java.util.Locale") />
		<!---<cfset var pattern=createObject("java","java.util.regex.Pattern")>--->
		<!---<cfset var regexStr="(\{[0-9]{1,},number.*?\})">--->
		<cfset var p="">
		<cfset var m="">
		<cfset var i=0>
		<cfset var thisFormat="">
		<cfset var inputArgs=arguments.args>
		<cfset var lang="">
		<cfset var country="">
		<cfset var variant="">
		<cfset var tLocale="">
		<cftry>
			<cfset lang=listFirst(arguments.thisLocale,"_")>
			<cfif listLen(arguments.thisLocale,"_") GT 1>
				<cfset country=listGetAt(arguments.thisLocale,2,"_")>
				<cfset variant=listLast(arguments.thisLocale,"_")>
			</cfif>
			<cfset tLocale=locale.init(lang,country,variant)>
			<cfif NOT isArray(inputArgs)>
				<cfset inputArgs=listToArray(inputArgs)>
			</cfif>	
			<cfset thisFormat=msgFormat.init(arguments.thisPattern,tLocale)>
			<!--- I have no idea what's going on in here, but it was putting commas into numbers and commenting it out doesn't seem to be an issue
			<!--- let's make sure any cf numerics are cast to java datatypes --->
			<cfset p=pattern.compile(regexStr,pattern.CASE_INSENSITIVE)>
			<cfset m=p.matcher(arguments.thisPattern)>
			<cfloop condition="#m.find()#">
				<cfset i=listFirst(replace(m.group(),"{",""))>
				<cfset inputArgs[i]=javacast("float",inputArgs[i])>
			</cfloop>
			--->
			<!--- I added the following loop to address the commas in numbers issue --->
			<cfloop from="1" to="#arrayLen(inputArgs)#" index="i">
				<cfset inputArgs[i]=javacast("string",inputArgs[i])>
			</cfloop>
			<cfset arrayPrepend(inputArgs,"")> <!--- dummy element to fool java --->
			<!--- coerece to a java array of objects  --->
			<cfreturn thisFormat.format(inputArgs.toArray())>
			<cfcatch type="Any">
				<cfthrow message="#cfcatch.message#" type="any" detail="#cfcatch.detail#">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getGeneratedFailureMessage" returntype="string" access="public" output="false" hint="I retrieve the default failure message from the resource bundle and do text replacement.">
		<cfargument name="msgKey" type="string" required="yes" hint="The key for the message in the resource bundle." />
		<cfargument name="args" type="array" required="no" default="#arrayNew(1)#" />
		<cfargument name="locale" type="string" required="no" default="#variables.defaultLocale#" />
		<cfargument name="addPrefix" type="boolean" required="no" default="true" />
		
		<cfscript>
			var pattern = variables.rbTranslator.translate(arguments.msgKey,arguments.locale);
			var formatted = messageFormat(pattern,arguments.args);
			if (not arguments.addPrefix) {
				return formatted;
			}
			return createDefaultFailureMessage(formatted);
		</cfscript>
	</cffunction>

	<cffunction name="createDefaultFailureMessage" returntype="string" access="private" output="false" hint="I prepend the defaultFailureMessagePrefix to a message.">
		<cfargument name="FailureMessage" type="any" required="yes" hint="A Failure message to add to." />
		<cfreturn variables.defaultFailureMessagePrefix & arguments.FailureMessage />
	</cffunction>

</cfcomponent>
