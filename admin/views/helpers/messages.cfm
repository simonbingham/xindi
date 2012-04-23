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

<cfoutput>
	<cfif StructKeyExists( rc, "messages" )>
		<cfif StructKeyExists( rc.messages, "error" ) and !IsNull( rc.result ) and rc.result.hasErrors()>
	    	<div class="alert alert-error">
				<p>#rc.messages.error#</p>
				<ul>
					<cfloop array="#rc.result.getFailureMessages()#" index="local.message">
						<li>#local.message#</li>
					</cfloop>
				</ul>
	    	</div>
		<cfelseif StructKeyExists( rc.messages, "error" )>
	    	<div class="alert alert-error">
				#rc.messages.error#
	    	</div>
		</cfif>
		
		<cfif StructKeyExists( rc.messages, "information" )>
	    	<div class="alert alert-info">
	    		#rc.messages.information#
	    	</div>
		</cfif>
		
		<cfif StructKeyExists( rc.messages, "success" )>
	    	<div class="alert alert-success">
	    		#rc.messages.success#
	    	</div>
		</cfif>
		
		<cfif StructKeyExists( rc.messages, "warning" )>
	    	<div class="alert">
	    		#rc.messages.warning#
	    	</div>
		</cfif>
	</cfif>
</cfoutput>