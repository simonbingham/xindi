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

<!--- specify canonical url for page (http://support.google.com/webmasters/bin/answer.py?hl=en&answer=139394) --->
<cfsavecontent variable="local.canonicalurl">
	<cfoutput>
		<link rel="canonical" href="#buildURL( rc.Page.getSlug() )#">
	</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#local.canonicalurl#">

<cfoutput>
	<!--- breadcrumb trail --->
	<cfif !rc.Page.isRoot()>
		<div>	
			<cfloop array="#rc.Page.getPath()#" index="local.Page">
				<a href="#buildURL( local.Page.getSlug() )#">#local.Page.getNavigationTitle()#</a> &raquo;
			</cfloop>
			
			#rc.Page.getNavigationTitle()#
		</div>
	</cfif>
	
	<h1>#rc.Page.getTitle()#</h1>
	
	#rc.Page.getContent()#
</cfoutput>