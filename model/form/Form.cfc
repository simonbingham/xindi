component persistent="true" table="forms" cacheuse="transactional"{
	
	// ------------------------ PROPERTIES ------------------------ //

	property name="formid" column="form_id" fieldtype="id" setter="false" generator="native";
	
	property name="slug" column="form_slug" ormtype="string" length="150";
	property name="name" column="form_name" ormtype="string" length="150";
	property name="longname" column="form_longname" ormtype="string" length="250";
	property name="instructions" column="form_instructions" ormtype="text";
	property name="ispublished" column="form_ispublished" ormtype="boolean" default="0" ;
	property name="sendemail" column="form_sendemail" ormtype="boolean" default="0" ;
	property name="emailto" column="form_emailto" ormtype="string" length="250";
	property name="created" column="form_created" ormtype="timestamp";
	property name="updated" column="form_updated" ormtype="timestamp";
	property name="updatedby" column="form_updatedby" ormtype="string" length="150";
	
	 // one Form can have many Sections 
	 property name="sections" fieldtype="one-to-many" cfc="FormSection" 
		fkcolumn="form_id" type="array" singularname="section" orderby="sortorder asc" 
    	inverse="true"; 
    	
    // many Form entities can have one FormSectionType entity 
	property name="SectionType" fieldtype="many-to-one" cfc="FormSectionType" fkcolumn="type_id" lazy="false"; 
	
	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	Form function init(){
		variables.slug = "";
		variables.name = "";
		variables.longname = "";
		variables.instructions = "";
		variables.ispublished = false;
		variables.sections = []; 
		return this;
	}
	
	// ------------------------ PUBLIC METHODS ------------------------ //
	
	/**
     * I return true if the form is persisted
	 */
	boolean function isPersisted(){
		return !IsNull( variables.formid );
	}
	
	/**
     * I return 0/1 for the isPublished property
	 */
	boolean function isPublishedVal(){
		return variables.ispublished ? 1 : 0;
	}

	/**
	* I am called before inserting the form into the database
	*/
	void function preInsert(){
		setSlug();
	}

	/**
     * I generate a unique id for the form
	 */		
	void function setSlug( string slug ){
		variables.slug = ReReplace( LCase( variables.name ), "[^a-z0-9]{1,}", "-", "all" );
		while ( !isSlugUnique() ) variables.slug &= "-"; 
	}
	
	 /** 
	  * Manages both sides of the relationship 
	  */ 
	  void function addSection( required Section ) 
	  { 
	    if( !hasSection( arguments.Section ) ) {	    	
		    ArrayAppend( variables.sections, arguments.Section ); 
		    arguments.Section.setForm( this ); 
	    }
	  }
	  
	  /** 
	  * I remove from both sides of the relationship 
	  */ 
	  void function removeSection( required FormSection Section ) 
	  { 
	    if( hasSection( arguments.Section ) ) 
	    { 
	      ArrayDelete( variables.sections, arguments.Section ); 
	      arguments.Section.removeForm( this ); 
	    } 
	  } 
	  
	 /** 
	  * I set from both sides of the relationship 
	  */ 
	  void function setSections( required array sections ) 
	  { 
		var Section = ""; 
		// loop through existing Sections  
		for ( Section in variables.sections ) 
		{ 
		 	if ( !ArrayContains( arguments.sections, Section ) )  
		 { 
		   	Section.removeForm( this ); 
		 } 
		} 
		// loop through passed Sections 
		for ( Section in arguments.sections ) 
		{ 
		 	if ( !Section.hasForm( this ) )  
		 { 
		   	Section.addForm( this ); 
		 } 
		} 
		variables.sections = arguments.sections; 
	} 
	  
	 /**
     * How many sections are there for this form?
	 */		
	numeric function countSections(){
		return arrayLen( this.getSections() );
	}
	
	/**
     * Get the maximum sort order for the sections
	 */		
	numeric function getMaxSortOrder(){
		var maxSortOrder = 0;
		if ( arrayLen( this.getSections() ) ) {
			maxSortOrder = ORMExecuteQuery( "select max(sortorder) as maxsort from FormSection fs where fs.Form.formid=:formid", { formid=variables.formid }, true );
		} 
		return maxSortOrder;
	}
	
	// ------------------------ PRIVATE METHODS ------------------------ //

	/**
     * I return true if the id of the form is unique
	 */	
	private boolean function isSlugUnique(){
		var matches = []; 
		if( isPersisted() ) matches = ORMExecuteQuery( "from Form where formid <> :formid and slug = :slug", { formid=variables.formid, slug=variables.slug } );
		else matches = ORMExecuteQuery( "from Form where slug=:slug", { slug=variables.slug } );
		return !ArrayLen( matches );
	}
	

}