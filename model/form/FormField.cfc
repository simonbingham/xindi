component persistent="true" table="form_fields" cacheuse="transactional"{

	property name="fieldid" column="field_id" fieldtype="id" setter="false" generator="native";
	property name="name" column="field_name" ormtype="string" length="150";
	property name="prompt" column="field_prompt" ormtype="text";
	property name="instructions" column="field_instructions" ormtype="text";
	property name="sortorder" column="field_sortorder" ormtype="int";
	property name="css_class" column="field_css_class" ormtype="string" length="150";
	property name="required" column="field_required" ormtype="boolean" default="0" ;
	property name="addother" column="field_addother" ormtype="boolean" default="0" ;
	property name="created" column="field_created" ormtype="timestamp";
	property name="updated" column="field_updated" ormtype="timestamp";
	property name="updatedby" column="field_updatedby" ormtype="string" length="150";
	
	// many FormField entities can have one Section entity 
	property name="Section" fieldtype="many-to-one" cfc="FormSection" fkcolumn="section_id" lazy="false"; 
	
	// many FormField entities can have one FormFieldType entity 
	property name="FieldType" fieldtype="many-to-one" cfc="FormFieldType" fkcolumn="type_id" lazy="false"; 
	
	// one Field can have many options 
	 property name="options" fieldtype="one-to-many" cfc="FormFieldOption" 
		fkcolumn="field_id" type="array" singularname="option" orderby="sortorder asc" 
    	inverse="true"; 

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	FormField function init(){
		variables.name = "";
		variables.prompt = "";
		variables.options = [];
		return this;
	}
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	
	/**
     * I return true if the form section is persisted
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