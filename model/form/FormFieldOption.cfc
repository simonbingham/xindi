component persistent="true" table="form_field_options" cacheuse="transactional"{

	property name="optionid" column="option_id" fieldtype="id" setter="false" generator="native";
	property name="prompt" column="option_prompt" ormtype="string" length="250";
	property name="sortorder" column="option_sortorder" ormtype="int";
	property name="created" column="option_created" ormtype="timestamp";
	property name="updated" column="option_updated" ormtype="timestamp";
	property name="updatedby" column="option_updatedby" ormtype="string" length="150";
	
	// many FormFieldOptions entities can have one FormField entity 
	property name="Field" fieldtype="many-to-one" cfc="FormField" fkcolumn="field_id" lazy="false"; 
	
	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	FormFieldOption function init(){
		variables.prompt = "";
		return this;
	}
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	
	/**
     * I return true if the option is persisted
	 */
	boolean function isPersisted(){
		return !IsNull( variables.optionid );
	}


}