component persistent="true" table="form_submission" cacheuse="transactional"{

	property name="submissionid" column="submission_id" fieldtype="id" setter="false" generator="native";
	property name="data" column="submission_data" ormtype="text";
	property name="submission_IP" column="submission_IP" sqltype="varchar(20)" update="false";
	property name="submission_date" column="submission_date" ormtype="timestamp" update="false" index="idx_submission_date";
	
	// many FormSubmission entities can have one Form entity 
	property name="Form" fieldtype="many-to-one" cfc="Form" fkcolumn="form_id"  lazy="true" fetch="join"; 
	
	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	FormSubmission function init(){
		return this;
	}
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	
	/**
     * I return true if the option is persisted
	 */
	boolean function isPersisted(){
		return !IsNull( variables.submissionid );
	}


}