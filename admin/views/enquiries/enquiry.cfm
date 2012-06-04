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
	<div class="page-header"><h1>#rc.Enquiry.getFullName()# <small>#DateFormat( rc.Enquiry.getCreated(), "full" )# at #TimeFormat( rc.Enquiry.getCreated(), "full" )#</small></h1></div>

	<p>
		<a href="#buildURL( 'enquiries' )#" class="btn"><i class="icon-chevron-left"></i> Back to enquiries</a>
		<a href="mailto:#rc.Enquiry.getEmail()#" class="btn btn-primary"><i class="icon-envelope icon-white"></i> Reply</a>
	</p>

	<hr>

	<blockquote>#rc.Enquiry.getDisplayMessage()#</blockquote>
</cfoutput>