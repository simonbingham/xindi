component accessors="true" extends="abstract"{
	
	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="FormService" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default( required struct rc ){
		param name="rc.formid" default="0";
		rc.Form = variables.FormService.getForm( rc.formid );
		rc.fields = rc.Form.getFields();
	}

	void function delete( required struct rc ){
		param name="rc.fieldid" default="0";
		if( !StructKeyExists( rc, "Field" ) ) rc.Field = variables.FormService.getField( rc.fieldid );
		rc.Form = rc.Field.getForm();
		rc.formid = rc.Form.getFormId();
		rc.result = variables.FormService.deleteField( rc.fieldid );
		variables.fw.redirect( "formfields.default", "result", "formid" );
	}	
	
	void function maintain( required struct rc ){
		param name="rc.fieldid" default="0";
		param name="rc.formid" default="0";
		param name="rc.context" default="create";
		if( !StructKeyExists( rc, "Field" ) ) rc.Field = variables.FormService.getField( rc.fieldid );
		if( rc.Field.isPersisted() ) {
			rc.context = "update";
			rc.Form = rc.Field.getForm();
			rc.FieldType = rc.Field.getFieldType();
			rc.formid = rc.Form.getFormID();
			rc.typeid = rc.FieldType.getTypeID();
		} else {
			rc.Form = variables.FormService.getForm( rc.formid );
			rc.Field.setForm( rc.Form );
		}
		rc.fieldtypes = variables.FormService.getFieldTypes();
		rc.Validator = variables.FormService.getValidator( rc.Field );
		if( !StructKeyExists( rc, "result" ) ) rc.result = rc.Validator.newResult();
	}	
	
	void function save( required struct rc ){
		param name="rc.fieldid" default="0";
		param name="rc.formid" default="0";
		param name="rc.num_newoptions" default="0";
		param name="rc.delete_list" default="";
		param name="rc.typeid" default="0";
		param name="rc.name" default="";
		param name="rc.prompt" default="";
		param name="rc.instructions" default="";
		param name="rc.required" default="false";
		param name="rc.context" default="create";
		param name="rc.submit" default="Save & exit";
		rc.result = variables.FormService.saveField( rc, rc.context );
		rc.Field = rc.result.getTheObject();
		if( rc.result.getIsSuccess() ){
			if( rc.submit == "Save & add more" )  variables.fw.redirect( "formfields.maintain", "result,Form", "formid" );
			else variables.fw.redirect( "formfields.default", "result,Form", "formid" );
		}else{
			variables.fw.redirect( "formfields.default", "result,Form", "formid" );
		}
	}
	
	void function clone( required struct rc ){
		param name="rc.fieldid" default="0";
		rc.result = variables.FormService.cloneField( rc.fieldid );
		rc.Field = rc.result.getTheObject();
		rc.fieldid = rc.Field.getFieldId();
		variables.fw.redirect( "formfields.maintain", "result,Field", "fieldid" );
	}	
	
	void function sort( required struct rc ){
		param name="rc.formid" default="0";
		rc.Form = variables.FormService.getForm( rc.formid );
		if ( IsNull( rc.Form ) ) variables.fw.redirect( "forms" );
		rc.fields = rc.Form.getFields();
	}
	
	void function savesort( required struct rc ){
		rc.saved = false;
		if ( StructKeyExists( rc, "payload" ) ){
			var fields = DeserializeJSON( rc.payload );
			rc.saved = variables.FormService.saveFieldSortOrder( fields );
		}
		// convert result to JavaScript boolean
		rc.saved = rc.saved ? "true" : "false"; 
	}
	
}