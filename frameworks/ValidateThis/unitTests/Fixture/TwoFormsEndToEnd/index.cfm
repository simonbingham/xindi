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
<cfsilent>
	<cfif StructKeyExists(url,"init") OR NOT StructKeyExists(application,"ValidateThis")>
		<cfset ValidateThisConfig = {} />
		<cfset application.ValidateThis = createObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig) />
	</cfif>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>ValidateThis Demo Page</title>
		<link href="/css/demostyle.css" type="text/css" rel="stylesheet" />
		<link href="/css/uni-form-styles.css" type="text/css" rel="stylesheet" media="all" />
	</head>
	<body>
	<div id="container">
		<div id="sidebar">
			<cfinclude template="theSidebar.cfm" />
		</div>		
		<div id="content">
			<cfinclude template="bothForms.cfm" />
		</div>
	</div>
	</body>
</html>
