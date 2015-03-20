<cfoutput>
	<h1>Edit Image</h1>

	<!--- big image offer so offer to resize --->
	<cfset local.thumbnail.width = 110>
	<cfset local.small.width = 320>
	<cfset local.medium.width = 650>
	<cfset local.large.width = 950>

	<cfset local.thumbnail.factor = rc.ImageInfo.width / local.thumbnail.width>
	<cfset local.small.factor = rc.ImageInfo.width / local.small.width>
	<cfset local.medium.factor = rc.ImageInfo.width / local.medium.width>
	<cfset local.large.factor = rc.ImageInfo.width / local.large.width>

	<form action="#buildURL('filemanager.docrop?subdirectory=#urlSafePath(rc.subdirectory)#&image=#rc.image#')#" method="post">
		<p>To resize the image you can choose a predefined sizes or drag the slider.</p>

		<cfif rc.ImageInfo.width gt 100>
			<label><input type="radio" name="resize-width" value="#local.thumbnail.width#"> Thumbnail (#local.thumbnail.width# x #Round(rc.ImageInfo.height / local.thumbnail.factor)#)</label>
		</cfif>

		<cfif rc.ImageInfo.width gt local.small.width>
			<label><input type="radio" name="resize-width" value="#local.small.width#"> Small (#local.small.width# x #Round(rc.ImageInfo.height / local.small.factor)#)</label>
		</cfif>

		<cfif rc.ImageInfo.width gt local.medium.width>
			<label><input type="radio" name="resize-width" value="#local.medium.width#"> Medium (#local.medium.width# x #Round(rc.ImageInfo.height / local.medium.factor)#)</label>
		</cfif>

		<cfif rc.ImageInfo.width gt local.large.width>
			<label><input type="radio" name="resize-width" value="#local.large.width#"> Large (#local.large.width# x #Round(rc.ImageInfo.height / local.large.factor)#)</label>
		</cfif>

		<label><input type="radio" name="resize-width" value="#rc.ImageInfo.width#" checked="checked"> Original (#rc.ImageInfo.width# x #rc.ImageInfo.height#)</label>

		<br>

		<label for="resize-width-slider">Width (px):</label>
		<input type="text" id="width" name="width" value="#rc.ImageInfo.width#" class="textField" style="font-weight:bold; width:40px" placeholder="Width (px)">
		<input type="hidden" name="height" id="height" value="#rc.ImageInfo.height#">
		<input type="hidden" name="x1" id="x1">
		<input type="hidden" name="x2" id="x2">
		<input type="hidden" name="y1" id="y1">
		<input type="hidden" name="y2" id="y2">
		<input type="submit" name="submit" id="submit" value="save">
		<input type="button" name="cancel" id="cancel" value="cancel">
	</form>

	<div id="slider"></div>

	<p>To crop the image, click on the picture and drag to highlight the area you want to keep.</p>

	<img src="#rc.basehref##rc.clientfilesdirectory##rc.subdirectory#/#rc.image#" id="photo" width="#rc.ImageInfo.width#" height="#rc.ImageInfo.height#" style="border:2px solid ##e5e5e5">
</cfoutput>

<script>
	jQuery(function($){
		$("#cancel").click(function(){
			document.location.href = <cfoutput>"#buildURL('filemanager?subdirectory=#urlSafePath(rc.subdirectory)#')#"</cfoutput>;
		});

		$("form").keypress(function (e) {
			if (e.keyCode == 13) return false;
		});

		$width = $("#width").bind("blur keypress keyup",function(e){
			var width = $(this).val();
			if(typeof e.which == "undefined"||e.which==13){
				var re = /[^0-9]/gi;
				if (!re.test(width)) {
					$slider.slider("value", parseInt(width));
				}
				return false;
			}
		});

		$(":radio[name='resize-width']").bind('click', function(){
			$slider.slider("value", parseInt($(this).val()));
		});

		$photo = $("#photo").imgAreaSelect({
			onSelectEnd: function (img, selection) {
				$("input[name=x1]").val(selection.x1);
				$("input[name=y1]").val(selection.y1);
				$("input[name=x2]").val(selection.x2);
				$("input[name=y2]").val(selection.y2);
			}
		});

		$slider = $("#slider").slider({
			min: 0,
			max: $photo.attr("width"),
			value: $photo.attr("width"),
			slide: function(event, ui){
				$width.val(ui.value);
				$(":input[name=resize-width]").removeAttr("checked");
			},
			change: function(event, ui){
				var width = ui.value;
				var height = Math.round($photo.attr("height")/($photo.attr("width")/width));
				resizeImage(width,height);
			}
		});

		if($photo.attr("width") <= <cfoutput>#local.large.width#</cfoutput>) $slider.css({width:$photo.attr("width")+"px"});

		function resizeImage(width, height){
			$("#width").val(width);
			$("#height").val(height);
			$photo.animate({
				width: width + "px",
				height: height + "px"
			});
		}
	});
</script>

<cfscript>
	string function urlSafePath(required string path){
		local.result = Replace(arguments.path, "/", ":", "all");
		if(!Len(Trim(local.result))) {
			local.result = "*";
		}
		return local.result;
	}
</cfscript>
