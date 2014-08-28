<cfcomponent accessors="true" output="false" extends="model.abstract.BaseGateway">
	<cfscript>

	// ------------------------ PUBLIC METHODS FOR FORMS ------------------------ //

	/**
	 * I delete a form
	 */	
	void function deleteForm( required Form theForm ){
		delete( arguments.theForm );
	}

	/**
	 * I return a form matching an id
	 */	
	Form function getForm( required numeric formid ){
		return get( "Form", arguments.formid );
	}
		
	/**
	 * I return a form matching a unique id
	 */				
	Form function getFormBySlug( required string slug ){
		var Form = ORMExecuteQuery( "from Form where slug=:slug and ispublished=1", { slug=arguments.slug }, true );
		if( IsNull( Form ) ) Form = new( "Form" );
		return Form;
	}
		
	/**
	 * I return the count of forms
	 */				
	numeric function getFormCount(){
		return ORMExecuteQuery( "select count( * ) from Form", [], true );
	}

	/**
	 * I return a new form
	 */		
	Form function newForm(){
		return new( "Form" );
	}
	
	/**
	 * I save a form
	 */		
	Form function saveForm( required Form theForm ){
		if( !arguments.theForm.isPersisted() ){
      		arguments.theForm.setSortOrder( theForm.getMaxSortOrder() + 1 );      		
			var slug = ReReplace(LCase(arguments.theForm.getName()), "[^a-z0-9]{1,}", "-", "all");
			while (!isSlugUnique(slug)) slug &= "-";
			arguments.theForm.setSlug(slug);
		}
		return save( arguments.theForm );		
	}

	/**
	 * I save a form sort
	 */		
	Form function saveFormSort( required Form theForm ) {
		return save( arguments.theForm );
	}
	
		
	// ------------------------ PUBLIC METHODS FOR FORM FIELDS ------------------------ //

	/**
	 * I delete a form field
	 */	
	void function deleteField( required FormField theField ){
		delete( arguments.theField );
	}

	/**
	 * I return a form field matching an id
	 */	
	FormField function getField( required numeric fieldid ){
		return get( "FormField", arguments.fieldid );
	}

	/**
	 * I return a new form field
	 */		
	FormField function newField(){
		return new( "FormField" );
	}
	
	/**
	 * I save a form field
	 */		
	FormField function saveField( required FormField theField, numeric formid=0, numeric typeid=0, array arrOptions, string delete_list ){
      	if( !arguments.theField.isPersisted() ){
      		var theForm = get( "Form", arguments.formid );
			var theType = get( "FormFieldType", arguments.typeid );
			arguments.theField.setSortOrder( theForm.getMaxSortOrder() + 1 );
			theForm.addField( theField );
			theType.addField( theField );
			arguments.theField = save( arguments.theField );
		}else if( arguments.theField.isPersisted() ){
			var theForm = theField.getForm();
			var theType = theField.getFieldType();
			if (typeid GT 0 AND typeid IS NOT theType.getTypeID()) {
				theType.removeField( theField );
				var newType = get( "FormFieldType", arguments.typeid );
				newType.addField( theField );
			}
			arguments.theField = save( arguments.theField );
		}
		
		//now save the associated options
		var numOptions = arrayLen( arrOptions );
		for (local.i = 1; local.i <= numOptions ; local.i++ ) {
			local.opt = arrOptions[local.i];
			saveOption( local.opt, arguments.theField.getFieldID() );
		}
		//delete any options being removed
		var numRemove = ListLen( arguments.delete_list );
		for (local.i = 1; local.i <= numRemove ; local.i++ ) {
			local.optID = ListGetAt(arguments.delete_list, local.i);
			local.option = getOption( local.optID );
			arguments.theField.removeOption( local.option );
			deleteOption( local.option );
		}
		return arguments.theField;
	}	
	
	/**
	 * I save a form field sort
	 */		
	FormField function saveFieldSort( required FormField theField ) {
		return save( arguments.theField );
	}

	/**
	 * I return a form field matching its id
	 */				
	FormField function getFieldById( required numeric fieldid ){
		var Field = ORMExecuteQuery( "from FormField where fieldid=:fieldid", { fieldid=arguments.fieldid }, true );
		if( IsNull( Field ) ) Field = new( "FormField" );
		return Field;
	}
	
	// ------------------------ PUBLIC METHODS FOR FORM FIELD OPTIONS ------------------------ //

	/**
	 * I delete a field option
	 */	
	void function deleteOption( required FormFieldOption theOption ){
		delete( arguments.theOption );
	}

	/**
	 * I return a field option matching an id
	 */	
	FormFieldOption function getOption( required numeric optionid ){
		return get( "FormFieldOption", arguments.optionid );
	}

	/**
	 * I return a new form field option
	 */		
	FormFieldOption function newOption(){
		return new( "FormFieldOption" );
	}
	
	/**
	 * I save a form field option
	 */		
	FormFieldOption function saveOption( required FormFieldOption theOption, numeric fieldid ){
       if( !arguments.theOption.isPersisted() ){
			var theField = get( "FormField", arguments.fieldid );
			arguments.theOption.setSortOrder( theField.countOptions() + 1 );
			theField.addOption( theOption );
			return save( arguments.theOption );
		}else if( arguments.theOption.isPersisted() ){
			return save( arguments.theOption );
		}
	}
	
	// ------------------------ PUBLIC METHODS FOR FORM FIELD TYPES ------------------------ //
	/**
	 * I return an array of form field types
	 */	
	array function getFieldTypes(){
		return EntityLoad( "FormFieldType", {}, "sortorder asc" );
	}
	
	/**
	 * I return a form field type matching an id
	 */	
	FormFieldType function getFieldType( required numeric typeid ){
		return get( "FormFieldType", arguments.typeid );
	}
	
	// ------------------------ PUBLIC METHODS FOR FORM SUBMISSIONS ------------------------ //

	/**
	 * I delete a submission
	 */	
	 void function deleteSubmission( required FormSubmission theSubmission ){
		delete( arguments.theSubmission );
	}	

	/**
	 * I return a submission matching an id
	 */	
	FormSubmission function getSubmission( required numeric submissionid ){
		return get( "FormSubmission", arguments.submissionid );
	}	

	/**
	 * I return a new form submission object
	 */		
	FormSubmission function newSubmission(){
		return new( "FormSubmission" );
	}	
	
	/**
	 * I save a submission object
	 */		
	FormSubmission function saveSubmission( required FormSubmission theSubmission, numeric formid ){
       if( !arguments.theSubmission.isPersisted() ){
			var theForm = get( "Form", arguments.formid );
			theForm.addSubmission( theSubmission );
			return save( arguments.theSubmission );
		}else if( arguments.theSubmission.isPersisted() ){
			return save( arguments.theSubmission );
		}
	}

	// ------------------------ PRIVATE METHODS ------------------------ //
	private boolean function isSlugUnique(required string slug) {
			var matches = ORMExecuteQuery("from Form where slug=:slug", {slug=arguments.slug});
			return !ArrayLen(matches);
		}

	</cfscript>
	
	<cffunction name="getForms" output="false" returntype="Array" hint="I return an array of forms">
		<cfargument name="ispublished" type="boolean" required="false" default="false">
		<cfargument name="maxresults" type="numeric" required="false" default="0">
		<cfargument name="offset" type="numeric" required="false" default="0">
		<cfset var qForms = "">
		<cfset var ormoptions = {}>
		<cfif arguments.maxresults>
			<cfset ormoptions.maxresults = arguments.maxresults>
		</cfif>
		<cfif arguments.offset>
			<cfset ormoptions.offset = arguments.offset>
		</cfif>
		<cfquery name="qForms" dbtype="hql" ormoptions="#ormoptions#">
			from Form
			where 1=1
			<cfif arguments.ispublished>
				and ispublished = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			</cfif>
			order by sortorder
		</cfquery>
		<cfreturn qForms>
	</cffunction> 
	
</cfcomponent>