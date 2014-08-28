component persistent="true" table="form_fieldtypes" cacheuse="transactional"{

	property name="typeid" column="type_id" fieldtype="id" setter="false" generator="native";
	property name="name" column="type_name" sqltype="varchar(150)";
	property name="showoptions" column="type_showoptions" ormtype="boolean" default="0" dbdefault="0";
	property name="settingstohide" column="type_settingstohide" sqltype="varchar(150)";
	property name="sortorder" column="type_sortorder" ormtype="int";
	
	// one Field Type can have many fields 
	 property name="fields" fieldtype="one-to-many" cfc="FormField" 
		fkcolumn="type_id" type="array" singularname="field" orderby="sortorder asc" 
    	inverse="true"; 
	
	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	FormFieldType function init(){
		variables.typename = "";
		variables.settingstohide = "";
		variables.fields = [];
		return this;
	}
	
	/** 
	  * Manages both sides of the relationship 
	  */ 
	  void function addField( required Field ) 
	  { 
	    if( !hasField( arguments.Field ) ) {	    	
		    ArrayAppend( variables.fields, arguments.Field ); 
		    arguments.Field.setFieldType( this ); 
	    }
	  }
	  
	  /** 
	  * I remove from both sides of the relationship 
	  */ 
	  void function removeField( required FormField Field ) 
	  { 
	    if( hasField( arguments.Field ) ) 
	    { 
	      ArrayDelete( variables.fields, arguments.Field ); 
	      arguments.Field.setFieldType(javaCast('null', '')); 
	    } 
	  } 
	  
	/** 
	  * I set from both sides of the relationship 
	  */ 
	  void function setFields( required array fields ) 
	  { 
		var Field = ""; 
		// loop through existing Fields  
		for ( Field in variables.fields ) 
		{ 
		 	if ( !ArrayContains( arguments.fields, Field ) )  
		 { 
		   	Field.removeFieldType( this ); 
		 } 
		} 
		// loop through passed Fields 
		for ( Field in arguments.fields ) 
		{ 
		 	if ( !Field.hasFieldType( this ) )  
		 { 
		   	Field.addFieldType( this ); 
		 } 
		} 
		variables.fields = arguments.fields; 
	} 

}