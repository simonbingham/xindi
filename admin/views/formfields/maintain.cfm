<cfoutput>
	<div class="page-header clear">	
		<cfif rc.Field.isPersisted()><h2>Edit Field</h2><cfelse><h2>Add Field</h2></cfif>	
		<h2>#rc.Section.getForm().getName()#:</h2>
		<h3>#rc.Section.getName()#</h3>
	</div>

	<div class="btn-group pull-right append-bottom" data-toggle="buttons-checkbox">
		<a href="#buildURL( action='formfields.default', querystring='sectionid/#rc.Section.getSectionID()#' )#" class="btn"><i class="icon-arrow-left"></i> Back to Field List</a>
		<cfif rc.Field.isPersisted()><a href="#buildURL( 'formfields.delete' )#/fieldid/#rc.Field.getFieldID()#" title="Delete" class="btn btn-danger"><i class="icon-trash icon-white"></i> Delete</a></cfif>
	</div>

	<div class="clear"></div>

	#view( "helpers/messages" )#
	
	<form action="#buildURL( 'formfields.save' )#" method="post" class="form-horizontal" id="form-field">
		<fieldset>
			<legend>Form Field Information</legend>	
			
			<div class="control-group <cfif rc.result.hasErrors( 'typeid' )>error</cfif>">
				<label class="control-label" for="typeid">Field Type <cfif rc.Validator.propertyIsRequired( "typeid" )>*</cfif></label>
				<div class="controls">
					<select id="typeid" name="typeid" class="input-xlarge">
				      <cfloop array="#rc.fieldtypes#" index="fieldtype" >
					<option value="#fieldtype.getTypeID()#" <cfif rc.Field.isPersisted() AND fieldtype.getTypeID() IS rc.typeid>selected="selected"</cfif> > #fieldtype.getName()#</option>
					</cfloop>
				    </select>
					#view( "helpers/failures", { property="typeid" })#
				</div>
			</div>
	
			<div class="control-group <cfif rc.result.hasErrors( 'name' )>error</cfif>">
				<label class="control-label" for="name">Short Name <cfif rc.Validator.propertyIsRequired( "shortname" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="name" id="name" value="#HtmlEditFormat( rc.Field.getName() )#" maxlength="250" placeholder"Short Name for this Field">
					#view( "helpers/failures", { property="shortname" })#
				</div>
			</div>
			
			<div class="control-group <cfif rc.result.hasErrors( 'name' )>error</cfif>">
				<label class="control-label" for="css_class">CSS Class <cfif rc.Validator.propertyIsRequired( "css_class" )>*</cfif></label>
				<div class="controls">
					<input class="input-xlarge" type="text" name="css_class" id="css_class" value="#HtmlEditFormat( rc.Field.getCSS_Class() )#" maxlength="150" placeholder"CSS Class (override default)">
					#view( "helpers/failures", { property="css_class" })#
				</div>
			</div>
			
			<div class="control-group <cfif rc.result.hasErrors( 'prompt' )>error</cfif>">
				<label class="control-label" for="prompt">Prompt <cfif rc.Validator.propertyIsRequired( "prompt" )>*</cfif></label>
				<div class="controls">
					<textarea class="field span6 ckeditor" rows="3" name="prompt" id="prompt">#HtmlEditFormat( rc.Field.getPrompt() )#</textarea>
					#view( "helpers/failures", { property="prompt" })#
				</div>
			</div>
			
		</fieldset>    
		
		<div>
			<fieldset id="fieldOptionsDiv" style="display:none">
				<legend>Form Field Options</legend>	
					<div class="control-group">
						<div class="controls">
						  <!-- List group -->
						  <ol id="optionList" class="list">
						  	<cfloop index="local.option"  array="#rc.Field.getOptions()#">
							  	<li id="li_#local.option.getOptionID()#" class="list-group-item">
							  		<div class="input-group">
							  			<input class="input-xlarge" type="text" name="option#local.option.getOptionID()#" id="option#local.option.getOptionID()#" value="#local.option.getPrompt()#" maxlength="250" >
										<span id="remove_option#local.option.getOptionID()#" class="input-group-addon icon-remove"></span>
									</div>
								</li>
							</cfloop>
							<cfif NOT arrayLen( rc.Field.getOptions() )> 
								<li id="li_New1" class="list-group-item">
							  		<div class="input-group">
							  			<input class="input-xlarge" type="text" name="optionNew1" id="optionNew1" value="Option 1" maxlength="250" >
										<span id="remove_optionNew1" class="input-group-addon icon-remove"></span>
									</div>
								</li>
							</cfif>
							
							<cfif NOT arrayLen( rc.Field.getOptions() )> 
								<cfset nextOption = 2>
							<cfelse>
								<cfset nextOption = arrayLen( rc.Field.getOptions() ) + 1>
							</cfif>
							<li id="li_New#nextOption#" class="list-group-item">
								<div class="input-group">
									<input class="input-xlarge" type="text" name="optionNew#nextOption#" id="optionNew#nextOption#" placeholder="Click to add option" maxlength="250" >
									<cfif NOT rc.Field.getAddOther()><span id="addOther">or <a href="javascript:addOther()">Add "Other"</a></span></cfif>
								</div>
							</li>
							<cfif rc.Field.getAddOther()>
							<li id="li_addOther" class="list-group-item">
								<div class="input-group">
									Other: <input class="input-large" style="width: 225px;" type="text" name="optionAddOther" id="optionAddOther" placeholder="Their Answer" disabled="disabled" >
									<span id="remove_addother" class="input-group-addon icon-remove"></span>
								</div>
							</li>
							</cfif>
					    </ol>
					</div>
				</div>			
			</fieldset>      
		</div>                    
		
		<div class="form-actions">
			<input type="submit" name="submit" value="Save &amp; continue" class="btn btn-primary">
			<input type="submit" name="submit" id="submit" value="Save &amp; exit" class="btn btn-primary">
			<a href="#buildURL( action='formfields.default', querystring='sectionid/#rc.Section.getSectionID()#' )#" class="btn cancel">Cancel</a>
		</div>
		
		<input type="hidden" name="sectionid" id="sectionid" value="#HtmlEditFormat( rc.Section.getSectionID() )#">
		<input type="hidden" name="fieldid" id="fieldid" value="#HtmlEditFormat( rc.fieldid )#">
		<input type="hidden" name="addother" id="addother" value="#HtmlEditFormat( rc.Field.getAddOther() )#">
		<input type="hidden" name="num_newoptions" id="num_newoptions" value="0">
		<input type="hidden" name="delete_list" id="delete_list" value="">
	</form>
	
	<p>* this field is required</p>
	
	#rc.Validator.getInitializationScript()#

	#rc.Validator.getValidationScript( formName="form-field" )#	
</cfoutput>

<script>
var arrayDelete = [];
CKEDITOR.replace( 'prompt', {
    height: 150
});
jQuery(function($){
	if ( $('#typeid').val() > 2 && $('#typeid').val() < 6  ) {
		$('#fieldOptionsDiv').show();
	}
	$("#typeid").change(function(){
		if ( $('#typeid').val() <= 2 || $('#typeid').val() > 5 ) {
			$('#fieldOptionsDiv').hide();
		} else {
			$('#fieldOptionsDiv').show();
		}
		if ($('#typeid').val() > 5) {
		
		}
	});
	<cfif arrayLen( rc.Field.getOptions() ) IS 0>
		$("#remove_optionNew1").css( 'cursor', 'pointer' );
		$("#remove_optionNew1").on("click", { optionNum: 1, optionType: 'New' }, removeOption);
	</cfif>
	<cfif rc.Field.getAddOther()>
		$("#remove_addother").css( 'cursor', 'pointer' );
		$("#remove_addother").on("click", removeOther );
	</cfif>
	<cfoutput>
	<cfloop index="local.option" array="#rc.Field.getOptions()#">
		<cfset optID = local.option.getOptionID()>
		$("##remove_option#optID#").css( 'cursor', 'pointer' );
		$("##remove_option#optID#").on("click", { optionNum: #optID#, optionType: '' }, removeOption);
	</cfloop>
	var optionNum = #nextOption#;
	</cfoutput>
	$("#optionNew" + optionNum).one("click", { optionNum: optionNum }, addOption);
	if ($("#optionList li").length == 2){
		$("#optionList li:first span").hide();
	}
	
});

function addOption(event) {
		var $target = $(event.target);
		var $other = $('#addOther');
		var $otherOpt = $('#li_addOther');
		var optCount = $("#optionList li").length;
		if ($otherOpt.length) optCount--;
		if (optCount == 2) $("#optionList li:first span").show();
		if ($other.length) $other.remove();
		$target.val("Option " + optCount);
		$target.after( ' <span id="remove_optionNew' + event.data.optionNum + '" class="input-group-addon icon-remove"></span>' );
		var newOptNum = parseInt(event.data.optionNum) + 1;
		var newOption = '<li class="list-group-item" id="li_New' + newOptNum + '"><div class="input-group"><input class="input-xlarge" type="text" ';
		newOption += 'name="optionNew' + newOptNum + '" id="optionNew' + newOptNum + '" ';
		newOption += 'placeholder="Click to add option" maxlength="250" >';
		if ( $('#addother').val() == 'NO' ) {
			newOption += '<span id="addOther">or <a href="javascript:addOther()">Add "Other"</a></span>';
		}
		newOption += '</div></li>';
		if ($otherOpt.length) {
			$otherOpt.before(newOption);
		} else {
			$("#optionList").append(newOption);			
		}
		$("#optionNew" + newOptNum).one("click", { optionNum: newOptNum }, addOption);
		$("#remove_optionNew" + event.data.optionNum).css( 'cursor', 'pointer' );
		$("#remove_optionNew" + event.data.optionNum).on("click", { optionNum: event.data.optionNum, optionType: 'New' }, removeOption);
		$("#num_newoptions").val(newOptNum);
		$target.rules('add', {
            required: true,
            messages: {
                required: "A value is required for the option"
            }
        });
	}
	
	function removeOption(event){
		var $target = $(event.target);
		//var message = "Delete option " + event.data.optionNum;
		var liToRemove = "#li_" + event.data.optionType + event.data.optionNum;
		//alert(liToRemove);
		$(liToRemove).remove();
		//if this is a current option, add to the delete list
		if (event.data.optionType.length == 0) {
			arrayDelete.push(event.data.optionNum);
			$('#delete_list').val( arrayDelete.join() );
		}
		//see if we only have one active option left
		var $otherOpt = $('#li_addOther');
		var optCount = $("#optionList li").length;
		if ($otherOpt.length) optCount--;
		if (optCount == 2) $("#optionList li:first span").hide();
	}
	
	function addOther() {
		var $other = $('#addOther');
		if ($other.length) $other.hide();
		var otherOpt = '<li id="li_addOther" class="list-group-item"><div class="input-group">';
		otherOpt += 'Other: <input class="input-large" style="width: 225px;" type="text" id="optionAddOther" placeholder="Their Answer" disabled="disabled" >';
		otherOpt += '<span id="remove_addother" class="input-group-addon icon-remove"></span>';
		otherOpt += '</div></li>';
		$("#optionList").append(otherOpt);
		$('#addother').val('YES');
		$("#remove_addother").css( 'cursor', 'pointer' );
		$("#remove_addother").on("click", removeOther );
	}
	
	function removeOther() {
		var $other = $('#li_addOther');
		if ($other.length) $other.remove();
		var addOther = '<span id="addOther">or <a href="javascript:addOther()">Add "Other"</a></span>';
		$("#optionList li:last div").append(addOther);
		$('#addother').val('NO');
	}
</script>
