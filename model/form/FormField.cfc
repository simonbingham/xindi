component persistent="true" table="form_fields" cacheuse="transactional"{

	property name="fieldid" column="field_id" fieldtype="id" setter="false" generator="native";
	property name="name" column="field_name" sqltype="varchar(150)" index="idx_name";
	property name="label" column="field_label" sqltype="varchar(750)" index="idx_label";
	property name="helptext" column="field_helptext" ormtype="text";
	property name="maxLength" column="field_maxlength" ormtype="integer" default="50" dbdefault="50";
	property name="css_class" column="field_css_class" sqltype="varchar(150)";
	property name="sortorder" column="field_sortorder" ormtype="int" default="0" dbdefault="0";
	property name="required" column="field_required" ormtype="boolean" default="true" dbdefault="1" index="idx_required";
	property name="addother" column="field_addother" ormtype="boolean" default="false" dbdefault="0" index="idx_addother";
	property name="created" column="field_created" ormtype="timestamp";
	property name="updated" column="field_updated" ormtype="timestamp";
	property name="updatedby" column="field_updatedby" sqltype="varchar(150)";
	
	// many Field entities can have one Form entity 
	property name="Form" fieldtype="many-to-one" cfc="Form" fkcolumn="form_id"  lazy="true" fetch="join"; 
	
	// many FormField entities can have one FormFieldType entity 
	property name="FieldType" fieldtype="many-to-one" cfc="FormFieldType" fkcolumn="type_id"  lazy="true" fetch="join"; 
	
	// one Field can have many options 
	 property name="options" fieldtype="one-to-many" cfc="FormFieldOption" fkcolumn="field_id" type="array" lazy="extra" batchsize="25" 
	 	 singularname="option" orderby="sortorder asc" inverse="true" cascade="all-delete-orphan"; 

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	FormField function init(){
		variables.name = "";
		variables.label = "";
		variables.helptext = "";
		variables.options = [];
		return this;
	}
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	
	/**
     * I return true if the form field is persisted
	 */
	boolean function isPersisted(){
		return !IsNull( variables.fieldid );
	}
	
	/** 
	  * Manages both sides of the relationship 
	  */ 
	  void function addOption( required Option ) 
	  { 
	    if( !hasOption( arguments.Option ) ) {	    	
		    ArrayAppend( variables.options, arguments.Option ); 
		    arguments.Option.setField( this ); 
	    }
	  }
	  
	  /** 
	  * I remove from both sides of the relationship 
	  */ 
	  void function removeOption( required FormFieldOption Option ) 
	  { 
	    if( hasOption( arguments.Option ) ) 
	    { 
	      ArrayDelete( variables.options, arguments.Option ); 
	      arguments.Option.setField(javaCast('null', '')); 
	    } 
	  } 
	  
	/** 
	  * I set from both sides of the relationship 
	  */ 
	  void function setOptions( required array options ) 
	  { 
		var Option = ""; 
		// loop through existing Options  
		for ( Option in variables.options ) 
		{ 
		 	if ( !ArrayContains( arguments.options, Option ) )  
		 { 
		   	removeOption( Option ); 
		 } 
		} 
		// loop through passed Options 
		for ( Option in arguments.options ) 
		{ 
		 	if ( !Option.hasField( this ) )  
		 { 
		   	addOption( Option ); 
		 } 
		} 
		variables.options = arguments.options; 
	} 

	/**
     * How many options are there for this field?
	 */		
	numeric function countOptions(){
		return arrayLen( this.getOptions() );
	}

}