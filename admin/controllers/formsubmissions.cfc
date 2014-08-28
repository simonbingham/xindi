component accessors="true" extends="abstract"{
	
	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="FormService" setter="true" getter="false";
	
	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default( required struct rc ){
		param name="rc.formid" default="0";
		rc.Form = variables.FormService.getForm( rc.formid );
		rc.FirstFields = rc.Form.getFirstFields();
		rc.submissions = rc.Form.getSubmissions();
	}

	void function view( required struct rc ){
		param name="rc.submissionid" default="0";
		if( !StructKeyExists( rc, "Submission" ) ) rc.Submission = variables.FormService.getSubmission( rc.submissionid );
		rc.Form = rc.Submission.getForm();
		rc.formid = rc.Form.getFormId();
		rc.FormData = deserializeJSON(rc.Submission.getData());
	}

	void function print( required struct rc ){
		param name="rc.submissionid" default="0";
		if( !StructKeyExists( rc, "Submission" ) ) rc.Submission = variables.FormService.getSubmission( rc.submissionid );
		rc.Form = rc.Submission.getForm();
		rc.formid = rc.Form.getFormId();
		rc.FormData = deserializeJSON(rc.Submission.getData());
	}

	/*void function delete( required struct rc ){
		param name="rc.fieldid" default="0";
		if( !StructKeyExists( rc, "Field" ) ) rc.Field = variables.FormService.getField( rc.fieldid );
		rc.Form = rc.Field.getForm();
		rc.formid = rc.Form.getFormId();
		rc.result = variables.FormService.deleteField( rc.fieldid );
		variables.fw.redirect( "formfields.default", "result", "formid" );
	}	*/
	
}