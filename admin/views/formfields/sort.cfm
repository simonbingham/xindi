<cfoutput>
	<div class="page-header clear">		
		<h2>#rc.Section.getForm().getName()#:</h2>
		<h3>#rc.Section.getName()#</h3>
		<h2>Sort Form Fields</h2>
	</div>

	<ul id="sortable">
		<cfloop index="local.field" array="#rc.fields#">
			<li data-fieldid="#local.field.getfieldid()#"><i class="icon-retweet"></i> #local.field.getname()#</li>
		</cfloop>
	</ul>

	<p><br/><span class="label label-info">Heads up!</span> You can move the fields by dragging them to the new position.</p>

	<button id="savesort" class="btn btn-primary">Save & exit</button>
	<a href="#buildURL( 'forms' )#" class="btn cancel">Cancel</a>

	<script>
	jQuery(function ($){
		var originalOrder = [];
		<cfloop index="local.field" array="#rc.fields#">
		originalOrder.push({sortorder: #local.field.getsortorder()#});
		</cfloop>
		
		$( "##sortable" ).sortable({
			placeholder: "ui-state-highlight"
		}).disableSelection();
		
		$('##savesort').bind('click', function (e){
			// figure out new positions...
			var newOrder = [];
			$('##sortable>li').each(function (i,el){
				newOrder.push( {fieldid: parseInt(el.getAttribute('data-fieldid')), sortorder: originalOrder[i].sortorder } );	
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