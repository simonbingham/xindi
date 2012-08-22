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

jQuery(function($){
	// use jQuery to wire up dropdown menu using bootstrap classes
	var $dropdowns = $('#primary-navigation>ul>li').on('mouseenter', function(e){
		$dropdowns.removeClass('open');
		$self = $(this);
		if ($self.hasClass('dropdown')) {
			$(this).addClass('open');
		}
		e.stopPropagation();
	}).find('ul.dropdown-menu').on('mouseleave',function(e){
		$dropdowns.removeClass('open');
		e.stopPropagation();
	}).attr({role:'menu'}).siblings().filter('a').attr({'data-toggle':'dropdown',role:'button',class:'dropdown-toggle'}).append(' <b class="caret"></b>').parent().addClass('dropdown');
})