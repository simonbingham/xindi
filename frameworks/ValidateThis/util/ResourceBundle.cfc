<cfcomponent displayname="ResourceBundle" hint="reads and parses java resource bundles" output="no">
<!---
	
	Copyright 2009, Bob Silverberg
	
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

	<cffunction name="Init" access="Public" returntype="any" output="false">

		<cfreturn this />

	</cffunction>

	<cffunction access="public" name="getResourceBundle" output="No" returntype="struct" hint="reads and parses java resource bundle per locale">
		<cfargument name="rbFile" required="Yes" type="string">
		<cfscript>
			var isOk=false; // success flag
			var rB = createObject("java", "java.util.PropertyResourceBundle");
			var fis=createObject("java", "java.io.FileInputStream");
			var keys=""; // var to hold rb keys
			var resourceBundle=structNew(); // structure to hold resource bundle
			var thisKey="";
			var thisMSG="";
			if (RBFileExists(arguments.rbFile)) {
				isOk=true;
				fis.init(arguments.rbFile);
				rB.init(fis);
				keys=rB.getKeys();
				while (keys.hasMoreElements()) {
					thisKEY=keys.nextElement();
					thisMSG=rB.handleGetObject(thisKey);
					resourceBundle[thisKEY]=thisMSG;
				}
				fis.close();
			}
		</cfscript>
		<cfif isOK>
			<cfreturn resourceBundle>
		<cfelse>
			<cfthrow type="validatethis.util.ResourceBundle.FileNotFound" message="The resource bundle file: #arguments.rbFile# does not exist. Please check your path.">
		</cfif>
	</cffunction> 

	<cffunction access="private" name="RBFileExists" output="No" returntype="any" hint="wrapper for FileExists()">
		<cfargument name="rbFile" required="Yes" type="string">
		<cfreturn fileExists(arguments.rbFile) />
	</cffunction> 

</cfcomponent>