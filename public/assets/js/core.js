// log errors to Hoth (serverside)
window.onerror = function(message,url,linenumber){
	var e = {message:message,url:url,linenumber:linenumber};
	if(typeof jQuery != 'undefined'){
		var jqxhr = jQuery.ajax({
			type:'POST',
			url:'remote/RemoteProxy.cfc?method=logClientSideError',
			data:e
		});
	}
	return document.domain !== 'localhost'; // true stops errors being shown to the client
}

$(function(){
	$(".dropdown-toggle").dropdown();
});