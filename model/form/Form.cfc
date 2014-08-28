component persistent="true" table="forms" cacheuse="transactional"{
	
	// ------------------------ PROPERTIES ------------------------ //

	property name="formid" column="form_id" fieldtype="id" setter="false" generator="native";
	
	property name="slug" column="form_slug" sqltype="varchar(150)" unique="true" index="idx_slug";
	property name="name" column="form_name" sqltype="varchar(150)" index="idx_name";
	property name="longname" column="form_longname" sqltype="varchar(250)";
	property name="instructions" column="form_instructions" sqltype="varchar(2000)";
	property name="ispublished" column="form_ispublished" ormtype="boolean" default="0" ;
	property name="sortorder" column="form_sortorder" ormtype="int" default="0" dbdefault="0";
	property name="submitmessage" column="form_submitmessage" sqltype="varchar(2000)";
	property name="sendemail" column="form_sendemail" ormtype="boolean" default="0" ;
	property name="emailto" column="form_emailto" sqltype="varchar(250)";
	property name="css_id" column="form_css_id" sqltype="varchar(150)";
	property name="css_class" column="form_css_class" sqltype="varchar(150)";
	property name="created" column="form_created" ormtype="timestamp";
	property name="updated" column="form_updated" ormtype="timestamp";
	property name="updatedby" column="form_updatedby" sqltype="varchar(150)";
	
	// one Form can have many fields 
	 property name="fields" fieldtype="one-to-many" cfc="FormField" lazy="extra" batchsize="25" 
		fkcolumn="form_id" type="array" singularname="field" orderby="sortorder asc" 
    	inverse="true"  cascade="all-delete-orphan"; 
    	
	// one Form can have many submissions 
	property name="submissions" fieldtype="one-to-many" cfc="FormSubmission" lazy="extra" batchsize="25" 
		fkcolumn="form_id" type="array" singularname="submission" orderby="submission_date desc" 
    	inverse="true"  cascade="all-delete-orphan"; 
	
	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
     * I initialise this component
	 */
	Form function init(){
		variables.slug = "";
		variables.name = "";
		variables.longname = "";
		variables.instructions = "";
		variables.submitmessage = "";
		variables.emailto = "";
		variables.ispublished = false;
		variables.sendEmail = false;
		variables.fields = []; 
		variables.submissions = []; 
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
     * I return 0/1 for the sendEmail property
	 */
	boolean function sendEmailVal(){
		return variables.sendEmail ? 1 : 0;
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
	  * Manages both sides of the Field relationship 
	  */ 
	  void function addField( required Field ) 
	  { 
	    if( !hasField( arguments.Field ) ) {	    	
		    ArrayAppend( variables.fields, arguments.Field ); 
		    arguments.Field.setForm( this ); 
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
	      arguments.Field.removeForm( this ); 
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
		   	Field.removeForm( this ); 
		 } 
		} 
		// loop through passed Fields 
		for ( Field in arguments.fields ) 
		{ 
		 	if ( !Field.hasForm( this ) )  
		 { 
		   	Field.addForm( this ); 
		 } 
		} 
		variables.fields = arguments.fields; 
	} 
	  
	 /**
     * How many fields are there for this form?
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
			maxSortOrder = ORMExecuteQuery( "select max(sortorder) as maxsort from FormField ff where ff.Form.formid=:formid", { formid=variables.formid }, true );
		} 
		return maxSortOrder;
	}

	/**
     * Checks if the form uses tabs
	 */		
	array function getTabs(){
		return ORMExecuteQuery( "from FormField ff where ff.Form.formid=:formid 
													AND ff.FieldType.typeid=:typeid
													ORDER BY sortorder ASC", { formid=variables.formid, typeid=7 } );
	}

	/**
     * Gets the first two textfields for the form, to display form submissions
	 */		
	array function getFirstFields(){
		return ORMExecuteQuery( "from FormField ff where ff.Form.formid=:formid 
													AND ff.FieldType.typeid=:typeid
													ORDER BY sortorder ASC", { formid=variables.formid, typeid=1 }, false, {maxresults=2} );
	}

	/** 
	  * Manages both sides of the relationship 
	  */ 
	void function addSubmission( required FormSubmission ) 
	  { 
	    if( !hasSubmission( arguments.FormSubmission ) ) {	    	
		    ArrayAppend( variables.submissions, arguments.FormSubmission ); 
		    arguments.FormSubmission.setForm( this ); 
	    }
	  }
	  
	  /** 
	  * I remove from both sides of the relationship 
	  */ 
	void function removeSubmission( required FormSubmission submission ) 
	  { 
	    if( hasSubmission( arguments.submission ) ) 
	    { 
	      ArrayDelete( variables.submissions, arguments.submission ); 
	      arguments.submission.removeForm( this ); 
	    } 
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