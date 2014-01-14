component persistent="true" table="form_sectiontypes" cacheuse="transactional"{

	property name="typeid" column="type_id" fieldtype="id" setter="false" generator="native";
	property name="name" column="type_name" ormtype="string" length="150";
	property name="sortorder" column="type_sortorder" ormtype="int";
	
	// one Section Type can have many forms
	 property name="forms" fieldtype="one-to-many" cfc="Form" 
		fkcolumn="type_id" type="array" singularname="form" inverse="true"; 
	
	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	FormSectionType function init(){
		variables.typename = "";
		variables.forms = [];
		return this;
	}
	
	/** 
	  * Manages both sides of the relationship 
	  */ 
	  void function addForm( required Form ) 
	  { 
	    if( !hasForm( arguments.Form ) ) {	    	
		    ArrayAppend( variables.forms, arguments.Form ); 
		    arguments.Form.setSectionType( this ); 
	    }
	  }
	  
	  /** 
	  * I remove from both sides of the relationship 
	  */ 
	  void function removeForm( required Form Form ) 
	  { 
	    if( hasForm( arguments.Form ) ) 
	    { 
	      ArrayDelete( variables.forms, arguments.Form ); 
	      arguments.Form.setSectionType(javaCast('null', '')); 
	    } 
	  } 

}