component accessors="true" extends="abstract"{

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="FormService" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //		

	void function form( required struct rc ){
		param name="rc.slug" default="";
		rc.Form = variables.FormService.getFormBySlug( rc.slug );
		if( rc.Form.isPersisted() ){
			rc.MetaData.setMetaTitle( rc.Form.getName() ); 
			rc.MetaData.setMetaDescription( rc.Form.getName() );
		}else{
			variables.fw.redirect( "main.notfound" );
		}		
	}
	
	void function default( required struct rc ){
		param name="rc.maxresults" default=rc.config.forms.recordsperpage;
		param name="rc.offset" default="0";	
		rc.forms = variables.FormService.getForms( ispublished=true, maxresults=rc.maxresults, offset=rc.offset );
		rc.formcount = variables.FormService.getFormCount();
		rc.MetaData.setMetaTitle( "Forms" );
		rc.MetaData.setMetaDescription( "" );
		rc.MetaData.setMetaKeywords( "" );
	}

}