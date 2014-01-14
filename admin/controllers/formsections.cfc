component accessors="true" extends="abstract"{
	
	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="FormService" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default( required struct rc ){
		param name="rc.formid" default="0";
		rc.sections = variables.FormService.getSectionsForForm( rc.formid );
	}

	void function delete( required struct rc ){
		param name="rc.sectionid" default="0";
		rc.result = variables.FormService.deleteSection( rc.sectionid );
		variables.fw.redirect( "forms", "result" );
	}	
	
	void function maintain( required struct rc ){
		param name="rc.sectionid" default="0";
		param name="rc.formid" default="0";
		param name="rc.context" default="create";
		if( !StructKeyExists( rc, "Section" ) ) rc.Section = variables.FormService.getSection( rc.sectionid );
		if( rc.Section.isPersisted() ) {
			rc.context = "update";
			rc.Form = rc.Section.getForm();
			rc.formid = rc.Form.getFormID();
		} else {
			rc.Form = variables.FormService.getForm( rc.formid );
			rc.Section.setForm( rc.Form );
		}
		rc.Validator = variables.FormService.getValidator( rc.Section );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
	}	
	
	void function save( required struct rc ){
		param name="rc.sectionid" default="0";
		param name="rc.formid" default="0";
		param name="rc.name" default="";
		param name="rc.context" default="create";
		param name="rc.submit" default="Save & exit";
		rc.result = variables.FormService.saveSection( rc, rc.context );
		rc.Section = rc.result.getTheObject();
		if( rc.result.getIsSuccess() ){
			if( rc.submit == "Save & Continue" )  variables.fw.redirect( "formsections.maintain", "result,Section", "formid,sectionid" );
			else variables.fw.redirect( "forms", "result");
		}else{
			variables.fw.redirect( "formsections.maintain", "result,Section", "formid,sectionid" );
		}
	}
	
	void function sort( required struct rc ){
		param name="rc.formid" default="0";
		rc.Form = variables.FormService.getForm( rc.formid );
		if ( IsNull( rc.Form ) ) variables.fw.redirect( "forms" );
		rc.sections = rc.Form.getSections();
	}
	
	void function savesort( required struct rc ){
		rc.saved = false;
		if ( StructKeyExists( rc, "payload" ) ){
			var sections = DeserializeJSON( rc.payload );
			rc.saved = variables.FormService.saveSectionSortOrder( sections );
		}
		// convert result to JavaScript boolean
		rc.saved = rc.saved ? "true" : "false"; 
	}
	
}