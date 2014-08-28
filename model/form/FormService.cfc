component accessors="true" extends="model.abstract.BaseService"{

	// ------------------------ DEPENDENCY INJECTION ------------------------ //
	
	property name="FormGateway" getter="false";
	property name="SecurityService" getter="false";
	property name="NotificationService" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS FOR FORMS ------------------------ //

	/**
	 * I delete a form
	 */	
	struct function deleteForm( required formid ){
		transaction{
			var Form = variables.FormGateway.getForm( Val( arguments.formid ) );
			var result = variables.Validator.newResult();
			if( Form.isPersisted() ){ 
				variables.FormGateway.deleteForm( Form );
				result.setSuccessMessage( "The form &quot;#Form.getName()#&quot; has been deleted." );
			}else{
				result.setErrorMessage( "The form could not be deleted." );
			}
		}
		return result;
	}

	/**
	 * I return an array of forms
	 */		
	array function getForms( boolean ispublished=false, numeric maxresults=0, numeric offset=0 ){
		arguments.maxresults = Val( arguments.maxresults );
		arguments.offset = Val( arguments.offset );
		return variables.FormGateway.getForms( argumentCollection=arguments );
	}	

	/**
	 * I return a form matching an id
	 */	
	Form function getForm( required formid ){
		return variables.FormGateway.getForm( Val( arguments.formid ) );
	}
	
	/**
	 * I return a form matching a unique id
	 */		
	Form function getFormBySlug( required string slug ){
		return variables.FormGateway.getFormBySlug( argumentCollection=arguments );
	}
	
	/**
	 * I return the count of forms
	 */		
	numeric function getFormCount(){
		return variables.FormGateway.getFormCount();
	}
	
	/**
	 * I return a new form
	 */		
	Form function newForm(){
		return variables.FormGateway.newForm();
	}
	
	/**
	 * I validate and save a form
	 */		
	struct function saveForm( required struct properties ){
		transaction{
			param name="arguments.properties.formid" default="0";
			var Form = variables.FormGateway.getForm( Val( arguments.properties.formid ) );
			var User = variables.SecurityService.getCurrentUser();
			if( !IsNull( User ) ) arguments.properties.updatedby = User.getName();
			populate( Form, arguments.properties );
			var result = variables.Validator.validate( theObject=Form );
			if( !result.hasErrors() ){
				variables.FormGateway.saveForm( Form );
				result.setSuccessMessage( "The form &quot;#Form.getName()#&quot; has been saved." );
			}else{
				writedump(result.getErrors());
				writedump(result.getFailureMessges());
				abort;
				result.setErrorMessage( "Your form could not be saved. Please correct the highlighted fields." );
			}
		}
		return result;
	}

	// accepts an array of structs
	boolean function saveFormSortOrder( required array forms ) {
		var newSortOrder = 0;
		var sorted = [];
		for ( var form in arguments.forms ){
			var theForm = getForm( form.formid );
			if ( IsNull( theForm ) || !theForm.isPersisted() ) return false;
			transaction{
				theForm.setSortOrder(form.sortorder);
				variables.FormGateway.saveForm( theForm );
			}
		}
		return true;
	}

	struct function submitForm( required struct properties ) {
		//TODO: set field submissions to the default value if they come in blank.
		transaction{
			param name="arguments.properties.formid" default="0";
			var Form = variables.FormGateway.getForm( Val( arguments.properties.formid ) );
			var Submission = newSubmission();
			var strFormIDs = {};
			var strFormData = {};
			for (var field IN arguments.properties) {
				if ( ListLen( field, "~") IS 2 ) {
					var sortOrder = ReplaceNoCase( ListGetAt( field, 1, "~"), "field", "" );
					var fieldID = ListGetAt( field, 2, "~");
					var fieldData = arguments.properties[ field ];
					//Check for an Other option
					if ( structKeyExists(arguments.properties, "field" & sortOrder & "~" & fieldID & "_Other_Detail" ) AND ListFind(fieldData, "Other")) {
						fieldData = ListDeleteAt(fieldData, ListFind(fieldData, "Other"));
						var otherDetail = "Other: " & arguments.properties["field" & sortOrder & "~" & fieldID & "_Other_Detail"];
						fieldData = ListAppend(fieldData, otherDetail);
					}
					//skip this field if it is Other Details
					if ( NOT FindNoCase( "_Other_Detail", fieldID) ) {
						strFormIDs[ fieldID ] = sortOrder;
						strFormData[ fieldID ] = fieldData;
					}
				}
			}		
			var arrSortedForm = structSort(strFormIDs, "numeric");
			var arrSortedData = arrayNew(1);
			for (var item IN arrSortedForm) {
				var objField = getFieldById(item);
				var newStruct = { id=item, name=objField.getName(), data=strFormData[item] };
				arrayAppend(arrSortedData, newStruct);		
			}
			Submission.setData(serializeJSON(arrSortedData));
			Submission.setSubmission_IP(cgi.REMOTE_ADDR);
			Submission.setSubmission_Date(now());
			var result = variables.Validator.validate( theObject=Submission );
			if( !result.hasErrors() ){
				variables.FormGateway.saveSubmission(Submission, arguments.properties.formid);
				result.setSuccessMessage( Form.getSubmitMessage() );
				if ( Form.getSendEmail() && len(Form.getEmailTo()) ) {
					sendSubmissionEmail( Submission, "../../public/views/forms/email.cfm");
				}
			}else{
				result.setErrorMessage( "Your form could not be saved. Please correct the highlighted fields." );
			}
			return result;	
		}	
	}


	// ------------------------ PUBLIC METHODS FOR FORM FIELDS ------------------------ //
	/**
	 * I delete a form field
	 */	
	struct function deleteField( required fieldid ){
		transaction{
			var Field = variables.FormGateway.getField( Val( arguments.fieldid ) );
			var result = variables.Validator.newResult();
			if( Field.isPersisted() ){ 
				variables.FormGateway.deleteField( Field );
				result.setSuccessMessage( "The form field has been deleted." );
			}else{
				result.setErrorMessage( "The form field could not be deleted." );
			}
		}
		return result;
	}

	/**
	 * I return a form field matching an id
	 */	
	FormField function getField( required fieldid ){
		return variables.FormGateway.getField( Val( arguments.fieldid ) );
	}
	
	/**
	 * I return a new form field
	 */		
	FormField function newField(){
		return variables.FormGateway.newField();
	}
	
	/**
	 * Add an option to the form field
	 */		
	FormField function addOptionToField(theField,optionText){
		return variables.FormGateway.addOptionToField(theField,optionText);
	}
	
	/**
	 * I return a form field cloned from another field
	 */	
	struct function cloneField( required fieldid ){
		var oldField = getField(fieldId);
		var theForm = oldField.getForm();
		var theType = oldField.getFieldType();
		var arrOptions = oldField.getOptions();
		var args = {
			fieldid = 0,
			formid = theForm.getFormID(),
			typeid = theType.getTypeID(),
			delete_list = 0,
			name = oldField.getName() & " Copy",
			label = oldField.getLabel(),
			helptext = oldField.getHelpText(),
			maxlength = oldField.getMaxLength(),
			css_class = oldField.getCss_Class(),
			sortorder = oldField.getSortOrder(),
			required = oldField.getRequired(),
			addother = oldField.getAddother(),
			num_newoptions = arrayLen( arrOptions) 
		};
		// add options
		for ( local.i = 1; local.i LTE arrayLen( arrOptions); local.i++ ) {
			args['optionnew' & local.i] = arrOptions[local.i].getLabel();
		}
		return saveField(args);
	}
	
	/**
	 * I validate and save a form field
	 */		
	struct function saveField( required struct properties ){
		transaction{
			param name="arguments.properties.fieldid" default="0";
			param name="arguments.properties.formid" default="0";
			param name="arguments.properties.typeid" default="0";
			param name="arguments.properties.delete_list" default="0";
			var Field = variables.FormGateway.getField( Val( arguments.properties.fieldid ) );
			var User = variables.SecurityService.getCurrentUser();
			if( !IsNull( User ) ) arguments.properties.updatedby = User.getName();
			populate( Field, arguments.properties );
			var arrOptions = populateOptions( Field, arguments.properties );
			var result = variables.Validator.validate( theObject=Field );
			if( !result.hasErrors() ){
				variables.FormGateway.saveField( Field, arguments.properties.formid, arguments.properties.typeid, arrOptions, arguments.properties.delete_list );
				result.setSuccessMessage( "The form field has been saved." );
			}else{
				result.setErrorMessage( "The form field could not be saved. Please correct the highlighted fields." );
			}
		}
		return result;
	}

	/**
	 * I return a form field matching its id
	 */		
	FormField function getFieldById( required numeric fieldid ){
		return variables.FormGateway.getFieldById( argumentCollection=arguments );
	}

	
	array function populateOptions( required FormField theField, required struct properties ) {
		param name="arguments.properties.num_newoptions" default="0";
		var arrOptions = [];
		//first process existing options
		var numOldOptions = arrayLen( theField.getOptions() );
		var sortOrder = 0;
		for (local.i = 1; local.i <= numOldOptions ; local.i++ ) {
			local.opt = theField.getOptions()[local.i];
			local.optID = local.opt.getOptionID();
			//check if this option ID is available in the request
			if ( StructKeyExists( arguments.properties, "option" & local.optID ) ) {
				sortOrder++;
				var local.label = arguments.properties[ "option" & local.optID ];
				if ( len( trim( local.label ) ) ) {
					local.opt.setLabel( local.label );
					local.opt.setSortOrder ( sortOrder );
					arrayAppend( arrOptions, local.opt );
				}
			} 
		}
		//now process new options
		var numNewOptions = arguments.properties.num_newoptions;
		for (local.i = numOldOptions+1; local.i <= numNewOptions ; local.i++ ) {
			if ( StructKeyExists( arguments.properties, "optionNew" & local.i ) ) {
				var local.label = arguments.properties[ "optionNew" & local.i ];
				if ( len( trim( local.label ) ) ) {
					sortOrder++;
					local.opt = newOption();
					local.opt.setLabel( local.label );
					local.opt.setSortOrder ( arrayLen( arrOptions ) + 1 );
					arrayAppend( arrOptions, local.opt );
				}
			}
		}
		return arrOptions;
	}
	
	// accepts an array of structs
	boolean function saveFieldSortOrder( required array fields ) {
		var newSortOrder = 0;
		var sorted = [];
		for ( var field in arguments.fields ){
			var theField = getField( field.fieldid );
			if ( IsNull( theField ) || !theField.isPersisted() ) return false;
			transaction{
				theField.setSortOrder(field.sortorder);
				variables.FormGateway.saveFieldSort( theField );
			}
		}
		return true;
	}
	
	// ------------------------ PUBLIC METHODS FOR FORM FIELD OPTIONS ------------------------ //
	/**
	 * I delete a form field option
	 */	
	struct function deleteOption( required optionid ){
		transaction{
			var Option = variables.FormGateway.getOption( Val( arguments.optionid ) );
			var result = variables.Validator.newResult();
			if( Option.isPersisted() ){ 
				variables.FormGateway.deleteOption( Option );
				result.setSuccessMessage( "The form field option has been deleted." );
			}else{
				result.setErrorMessage( "The form field option could not be deleted." );
			}
		}
		return result;
	}

	/**
	 * I return a form field option matching an id
	 */	
	FormFieldOption function getOption( required optionid ){
		return variables.FormGateway.getOption( Val( arguments.optionid ) );
	}
	
	/**
	 * I return a new form field option
	 */		
	FormFieldOption function newOption(){
		return variables.FormGateway.newOption();
	}
	
	/**
	 * I validate and save a form field option
	 */		
	struct function saveOption( required struct properties ){
		transaction{
			param name="arguments.properties.optionid" default="0";
			param name="arguments.properties.fieldid" default="0";
			var Option = variables.FormGateway.getOption( Val( arguments.properties.optionid ) );
			var User = variables.SecurityService.getCurrentUser();
			if( !IsNull( User ) ) arguments.properties.updatedby = User.getName();
			populate( Option, arguments.properties );
			var result = variables.Validator.validate( theObject=Option );
			if( !result.hasErrors() ){
				variables.FormGateway.saveOption( Option, arguments.properties.fieldid );
				result.setSuccessMessage( "The form field option has been saved." );
			}else{
				result.setErrorMessage( "The form field option could not be saved. Please correct the highlighted fields." );
			}
		}
		return result;
	}
	
	// accepts an array of structs
	boolean function saveOptionSortOrder( required array options ) {
		var newSortOrder = 0;
		var sorted = [];
		for ( var option in arguments.options ){
			var theOption = getOption( option.optionid );
			if ( IsNull( theOption ) || !theOption.isPersisted() ) return false;
			transaction{
				theOption.setSortOrder(option.sortorder);
				variables.FormGateway.saveOption( theOption );
			}
		}
		return true;
	}

	// ------------------------ PUBLIC METHODS FOR FORM SUBMISSIONS ------------------------ //
	/**
	 * I delete a form submission object
	 */	
	struct function deleteSubmission( required submissionid ){
		transaction{
			var theSubmission = variables.FormGateway.getSubmission( Val( arguments.submissionid ) );
			var result = variables.Validator.newResult();
			if( theSubmission.isPersisted() ){ 
				variables.FormGateway.deleteSubmission( theSubmission );
				result.setSuccessMessage( "The form submission has been deleted." );
			}else{
				result.setErrorMessage( "The form submission could not be deleted." );
			}
		}
		return result;
	}

	/**
	 * I return a form submission object matching an id
	 */	
	FormSubmission function getSubmission( required submissionid ){
		return variables.FormGateway.getSubmission( Val( arguments.submissionid ) );
	}
	
	/**
	 * I return a new form submission object
	 */		
	FormSubmission function newSubmission(){
		return variables.FormGateway.newSubmission();
	}
	
	/**
	 * I email a form submission
	 */
	struct function sendSubmissionEmail(required FormSubmission Submission, required string emailtemplatepath) {
		var result = { success = true };
		var Form = Submission.getForm();
		try {
			var outEmails = Form.getEmailTo();
			var subject = "New submission from the " & Form.getName() & " form.";
			var formData = deserializeJSON(Submission.getData());
			savecontent variable="emailtemplate" {include arguments.emailtemplatepath;}
			variables.NotificationService.send(subject, Form.getEmailTo(), 'maryjo@dogpatchsw.com', emailtemplate);
			result.successMessage = "The form submission has been sent.";
		} catch (e any) {
			result.errorMessage = "Your form could not be sent. Please correct the highlighted fields.";
			}
		return result;
	}
	
	
	// ------------------------ PUBLIC METHODS FOR FORM FIELD TYPES ------------------------ //
	/**
	 * I return an array of form field types
	 */	
	array function getFieldTypes(){
		return variables.FormGateway.getFieldTypes();
	}
	
	/**
	 * I return a form field type matching an id
	 */	
	FormFieldType function getFieldType( required numeric typeid ){
		return variables.FormGateway.getFieldType( arguments.typeid );
	}
	
}