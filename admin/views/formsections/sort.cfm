<cfoutput>
	<div class="page-header clear">		
		<h1>#rc.Form.getName()#</h1>
		<h2>Sort Form Sections</h2>
	</div>

	<ul id="sortable">
		<cfloop index="local.section" array="#rc.sections#">
			<li data-sectionid="#local.section.getsectionid()#"><i class="icon-retweet"></i> #local.section.getname()#</li>
		</cfloop>
	</ul>

	<p><br/><span class="label label-info">Heads up!</span> You can move the sections by dragging them to the new position.</p>

	<button id="savesort" class="btn btn-primary">Save & exit</button>
	<a href="#buildURL( 'forms' )#" class="btn cancel">Cancel</a>

	<script>
	jQuery(function ($){
		var originalOrder = [];
		<cfloop index="local.section" array="#rc.sections#">
		originalOrder.push({sortorder: #local.section.getsortorder()#});
		</cfloop>
		
		$( "##sortable" ).sortable({
			placeholder: "ui-state-highlight"
		}).disableSelection();
		
		$('##savesort').bind('click', function (e){
			// figure out new positions...
			var newOrder = [];
			$('##sortable>li').each(function (i,el){
				newOrder.push( {sectionid: parseInt(el.getAttribute('data-sectionid')), sortorder: originalOrder[i].sortorder } );	
			});
			
			// send to server
			$.ajax({
				type: 'POST',
				url: '#buildURL( ".savesort" )#',
				data: { payload: JSON.stringify(newOrder) },
				dataType: 'json'
			})
			.done(function (data, textStatus) {
				if (data.saved) {
					window.location.href = '#buildURL( "forms" )#';
				}
			})
			.fail(function (jqXHR, exception) { 
			})
			.always(function () {});
			
			e.preventDefault();
		});
		
	});
	</script>
</cfoutput>