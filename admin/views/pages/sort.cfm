<cfoutput>
	<div class="page-header clear">
		<h1>Sort Pages</h1>
	</div>

	<ul id="sortable">
		<cfloop query="rc.subpages">
			<li data-pageid="#rc.subpages.pageId#"><i class="glyphicon glyphicon-retweet"></i> #rc.subpages.title#</li>
		</cfloop>
	</ul>

	<p><span class="label label-info">Heads up!</span> You can move the pages by dragging them to the new position.</p>

	<button id="savesort" class="btn btn-primary">Save & exit</button>

	<script>
		jQuery(function ($){
			var originalOrder = [];
			<cfloop query="rc.subpages">
				originalOrder.push({left: #rc.subpages.positionLeft#, right: #rc.subpages.positionRight#});
			</cfloop>

			$("##sortable").sortable({
				placeholder: "ui-state-highlight"
			}).disableSelection();

			$("##savesort").bind("click", function (e){
				// figure out new positions...
				var newOrder = [];
				$("##sortable>li").each(function (i,el){
					newOrder.push({pageid: parseInt(el.getAttribute("data-pageid")), left: originalOrder[i].left, right: originalOrder[i].right});
				});

				// send to server
				$.ajax({
					type: "POST",
					url: '#buildURL(".savesort")#',
					data: {payload: JSON.stringify(newOrder)},
					dataType: "json"
				})
				.done(function (data, textStatus) {
					if (data.saved) {
						window.location.href = '#buildURL("pages")#';
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
