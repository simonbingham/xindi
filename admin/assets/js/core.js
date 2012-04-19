$(function() {
	
	$( "#top-of-page" ).click(function(e){
		$( "html,body" ).animate( { scrollTop: 0 }, "slow" );
		e.preventDefault();	
	});
	
	$( ".alert" ).alert();
	
	$( "a[title~='Delete']" ).click(function(){
		return confirm( "Delete this item?" );
	});	
	
});