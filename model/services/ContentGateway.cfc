<!---
	Xindi - http://www.getxindi.com/
	
	Copyright (c) 2012, Simon Bingham
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--->

<cfcomponent output="false">
	<cffunction name="getPages" output="false" returntype="Array">
		<cfargument name="searchterm" type="string" required="false" default="">
		<cfargument name="suppressancestorpages" type="boolean" required="false" default="false">
		<cfargument name="sortorder" type="string" required="false" default="leftvalue">
		<cfargument name="maxresults" type="numeric" required="false" default="-1">
		
		<cfset var qPages = "">
		<cfset var thesearchterm = Trim( arguments.searchterm )>
		
		<cfquery name="qPages" dbtype="hql" maxrows="#arguments.maxresults#">
			from Page
			where 1=1
			<cfif Len( thesearchterm )>
				and 
				(	
				 	lower( title ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%"> 
				 	or lower( content ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#thesearchterm#%">
				) 
			</cfif>
			<cfif arguments.suppressancestorpages>
				 and ( rightvalue-leftvalue = 1 or pageid = 1 )
			</cfif>
			order by #arguments.sortorder#
		</cfquery>
		
		<cfreturn qPages>
	</cffunction> 
</cfcomponent>