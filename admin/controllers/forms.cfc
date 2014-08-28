component accessors="true" extends="abstract"{
	
	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="FormService" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default( required struct rc ){
		rc.forms = variables.FormService.getForms();
	}

	void function delete( required struct rc ){
		param name="rc.formid" default="0";
		rc.result = variables.FormService.deleteForm( rc.formid );
		if( !rc.config.development && rc.result.getIsSuccess() ){
			var refreshsitemap = new Http( url="#rc.basehref#index.cfm/public:navigation/xml", method="get" );
			refreshsitemap.send();
		}
		variables.fw.redirect( "forms", "result" );
	}	
	
	void function maintain( required struct rc ){
		param name="rc.formid" default="0";
		param name="rc.context" default="create";
		if( !StructKeyExists( rc, "Form" ) ) rc.Form = variables.FormService.getForm( rc.formid );
		if( rc.Form.isPersisted() ) {
			rc.context = "update";
		}
		rc.Validator = variables.FormService.getValidator( rc.Form );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
	}	
	
	void function save( required struct rc ){
		param name="rc.formid" default="0";
		param name="rc.name" default="";
		param name="rc.longname" default="";
		param name="rc.instructions" default="";
		param name="rc.ispublished" default="false";
		param name="rc.context" default="create";
		param name="rc.submit" default="Save & exit";
		rc.result = variables.FormService.saveForm( rc, rc.context );
		rc.Form = rc.result.getTheObject();
		if( rc.result.getIsSuccess() ){
			if( !rc.config.development ){
				var refreshsitemap = new Http( url="#rc.basehref#index.cfm/public:navigation/xml", method="get" );
				refreshsitemap.send();
			}
			if( rc.submit == "Save & Continue" )  variables.fw.redirect( "formfields.default", "result,Form", "formid" );
			else variables.fw.redirect( "forms", "result" );
		}else{
			variables.fw.redirect( "forms.maintain", "result,Form", "formid" );
		}
	}
	
}