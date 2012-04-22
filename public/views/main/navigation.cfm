<!---
   Copyright 2012, Simon Bingham

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

<cfparam name="rc.pages" default="#rc.navigation#" />

<!--- here's lots of code that renders an indented list of pages - could probably be improved! --->

<cfset local.previouslevel = -1 />

<cfoutput>
	<cfif ArrayLen( rc.pages )>
		<cfloop array="#rc.pages#" index="local.Page">
			<cfsavecontent variable="local.link">
				<cfset local.title = local.Page.getNavigationTitle()>
				<cfset local.link = Replace( buildURL( local.Page.getSlug() ), "site:", "" )>
				
				<cfif local.Page.isRoot()>
					<cfset local.link = rc.basehref>
				</cfif>
				
				<a href="#local.link#">#local.title#</a>
			</cfsavecontent>		
			
			<cfif local.Page.getLevel() gt local.previouslevel>
				<ul><li>
					
				#local.link#
			<cfelseif local.Page.getLevel() lt local.previouslevel>
				<cfset local.temporary = local.previouslevel>
				
				<cfloop condition="local.temporary gt local.Page.getLevel()">
	 				</li></ul>
		
					<cfset local.temporary = local.temporary - 1>
				</cfloop>
			
				</li><li>
	
				#local.link#
			<cfelse>
				</li><li>
					
				#local.link#
			</cfif>
			
			<cfset local.previouslevel = local.Page.getLevel()>
		</cfloop>
	
		<cfset local.temporary = local.Page.getLevel()>
	
		<cfloop condition="local.temporary ge 0">
			</li></ul>
			
			<cfset local.temporary = local.temporary - 1>
		</cfloop>
	</cfif>
</cfoutput>