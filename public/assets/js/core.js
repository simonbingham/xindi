// log errors to Hoth (serverside)
window.onerror = function(message, url, linenumber){
	var e = {message:message, url:url, linenumber:linenumber};
	if (typeof jQuery != "undefined"){
		var jqxhr = jQuery.ajax({
			type:"POST",
			url:"remote/RemoteProxy.cfc?method=logClientSideError",
			data:e
		});
	}
	return document.domain !== "localhost"; // true stops errors being shown to the client
}

$(function(){
	$("#navbar").addClass("collapse navbar-collapse");
	$("#navbar > ul").addClass("nav navbar-nav");
	$("#navbar ul ul")
		.each(function(){
			$parentLink = $(this).prev();
			$(this).prepend($("<li><a href='" + $parentLink.attr("href") + "'>" + $parentLink.text() + "</a></li>"));
		})
		.addClass("dropdown-menu")
		.prev().addClass("dropdown-toggle").attr("data-toggle", "dropdown").append(' <b class="caret"></b>')
		.parent().addClass("dropdown");
	$("#navbar a").each(function(i){
		if (this.href.replace(/^.*\/\/[^\/]+/, "") === window.location.pathname) {
			$(this).parent().addClass("active");
			return false;
		}
	});

	if (document.createElement("input").webkitSpeech !== undefined) {
		$("#searchterm").attr("x-webkit-speech","x-webkit-speech");
	}
});
