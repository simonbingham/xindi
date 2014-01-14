component persistent="true" table="form_sections" cacheuse="transactional"{

	property name="sectionid" column="section_id" fieldtype="id" setter="false" generator="native";
	property name="name" column="section_name" ormtype="string" length="150";
	property name="sortorder" column="section_sortorder" ormtype="int";
	property name="created" column="section_created" ormtype="timestamp";
	property name="updated" column="section_updated" ormtype="timestamp";
	property name="updatedby" column="section_updatedby" ormtype="string" length="150";
	
	// many Section entities can have one Form entity 
	property name="Form" fieldtype="many-to-one" cfc="Form" fkcolumn="form_id" lazy="false" ; 
	
	// one Section can have many fields 
	 property name="fields" fieldtype="one-to-many" cfc="FormField" 
		fkcolumn="section_id" type="array" singularname="field" orderby="sortorder asc" 
    	inverse="true"; 
	
	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	FormSection function init(){
		variables.name = "";
		return this;
	}
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	
	/**
     * I return true if the form section is persisted
	 */
	boolean function isPersisted(){
		return !IsNull( variables.sectionid );
	}
	
	/** 
	  * Manages both sides of the relationship 
	  */ 
	  void function addField( required Field ) 
	  { 
	    if( !hasField( arguments.Field ) ) {	    	
		    ArrayAppend( variables.fields, arguments.Field ); 
		    arguments.Field.setSection( this ); 
	    }
	  }
	  
	 /** 
	  * I remove from both sides of the relationship 
	  */ 
	  void function removeField( required Field Field ) 
	  { 
	    if( hasField( arguments.Field ) ) 
	    { 
	      ArrayDelete( variables.fields, arguments.Field ); 
	      arguments.Field.removeSection( this ); 
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
		   	Field.removeSection( this ); 
		 } 
		} 
		// loop through passed Fields 
		for ( Field in arguments.fields ) 
		{ 
		 	if ( !Field.hasSection( this ) )  
		 { 
		   	Field.addSection( this ); 
		 } 
		} 
		variables.fields = arguments.fields; 
	} 
	  
	 /**
     * How many fields are there for this section?
	 */		
	numeric function countFields(){
		return arrayLen( this.getFields() );
	}
	
	/**
     * Get the maximum sort order for the fields
	 */		
	numeric function getMaxSortOrder(){
		var maxSortOrder = 0;
		if ( arrayLen( this.getFields() ) ) {
			maxSortOrder = ORMExecuteQuery( "select max(sortorder) as maxsort from FormField ff where ff.Section.sectionid=:sectionid", { sectionid=variables.sectionid }, true );
		} 
		return maxSortOrder;
	}


}