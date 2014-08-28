component persistent="true" table="form_field_options" cacheuse="transactional"{

	property name="optionid" column="option_id" fieldtype="id" setter="false" generator="native";
	property name="label" column="option_label" sqltype="varchar(250)";
	property name="value" column="option_value" sqltype="varchar(250)";
	property name="isselected" column="option_isselected" ormtype="boolean" default="false" dbdefault="0" index="idx_isselected";
	property name="sortorder" column="option_sortorder" ormtype="int" default="0" dbdefault="0";
	property name="created" column="option_created" ormtype="timestamp";
	property name="updated" column="option_updated" ormtype="timestamp";
	property name="updatedby" column="option_updatedby" sqltype="varchar(150)";
	
	// many FormFieldOptions entities can have one FormField entity 
	property name="Field" fieldtype="many-to-one" cfc="FormField" fkcolumn="field_id" lazy="true" fetch="join"; 
	
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