<cfoutput>
	<ul class="breadcrumb">
		<li><a href="#rc.basehref#">Home</a> <span class="divider">/</span></li>
		<li class="active">Forms</li>
	</ul>

	<div><h1>Forms</h1></div>
	
	<cfif ArrayLen( rc.forms )>
		<cfloop array="#rc.forms#" index="local.Form">
			<div class="well">
				<h2>
					<a href="#buildURL( action='forms.form', querystring='slug=#local.Form.getSlug()#' )#">#local.Form.getName()#</a>
				</h2>
			</div>
		</cfloop>
		<ul class="pager append-top">
			<cfif rc.offset>
				<li class="previous"><a href="#buildURL( action='forms', querystring='offset=#rc.offset-rc.maxresults#' )#">&larr; Newer</a></li>
			<cfelse>
				<li class="previous disabled"><a href="">&larr; Newer</a></li>
			</cfif>
			 
			<cfif rc.maxresults + rc.offset lt rc.formcount>
				<li class="next"><a href="#buildURL( action='forms', querystring='offset=#rc.offset+rc.maxresults#' )#">Older &rarr;</a></li>
			<cfelse>
				<li class="next disabled"><a href="">Older &rarr;</a></li>
			</cfif>
		</ul>
	<cfelse>
		<p>There are currently no available forms.</p>
	</cfif>
	
	<script>
	jQuery(function($){
		$(".previous.disabled,.next.disabled").click(function(e){
			e.preventDefault();
		});
	});
	</script>	
</cfoutput>