<cfoutput>
	<div class="page-header clear"><h1>#rc.Enquiry.getFullName()# <small class="pull-right">#DateFormat( rc.Enquiry.getCreated(), "full" )# at #TimeFormat( rc.Enquiry.getCreated() )#</small></h1></div>

	<p><a href="mailto:#rc.Enquiry.getEmail()#" class="btn btn-primary"><i class="icon-envelope icon-white"></i> Reply</a></p>

	<hr>

	<blockquote>#rc.Enquiry.getDisplayMessage()#</blockquote>
</cfoutput>