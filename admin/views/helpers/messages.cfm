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