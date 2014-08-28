
<cfoutput>
	<script>
	$(document).ready(function() {		
		<cfloop index="x" from="2" to="#arrayLen(rc.Form.getTabs())#" >
			$('##nextTab-#rc.Form.getTabs()[x].getFieldID()#').on("click", function(event) { 
				event.preventDefault();
		    	$('##tabs li:eq(#x-1#) a').tab('show');
		    	$('html,body').animate({scrollTop:0},0);
		    	return false;
			});
		</cfloop>  
	});
	</script>

	<ul class="breadcrumb">
		<li><a href="#rc.basehref#">Home</a> <span class="divider">/</span></li>
		<li><a href="#buildURL( action='forms' )#">Forms</a> <span class="divider">/</span></li>
		<li class="active">#rc.Form.getName()#</li>
	</ul>

	<cfif len(rc.Form.getLongName())>
		<h2>#rc.Form.getLongName()#</h2>
	<cfelse>
		<h2>#rc.Form.getName()#</h2>
	</cfif>
	<cfif len(rc.Form.getInstructions())>
		<p>#rc.Form.getInstructions()#</p>
	</cfif>
	<form id="customForm" class="form-horizontal" action="#buildURL('forms.submit')#" method="post">
		<input type="hidden" name="formid" value="#rc.Form.getFormId()#">
		<cfif arrayLen(rc.Form.getTabs())>
			<div id="tabs" class="tabbable">
			  <ul class="nav nav-tabs">
			  	<cfloop array="#rc.Form.getTabs()#" index="local.Tab">
			    <li <cfif local.Tab.getSortOrder() IS 1>class="active"</cfif>><a href="##tab#local.Tab.getFieldID()#" data-toggle="tab">#local.Tab.getLabel()#</a></li>
			    </cfloop>
			  </ul>
			  <div class="tab-content">
		</cfif>
				
			 <!--- 	<cfloop array="#rc.Form.getSections()#" index="local.Section">
			    <div id="section#local.Section.getSectionID()#" class="tab-pane <cfif local.Section.getSortOrder() IS 1>active</cfif>">
					<fieldset>
					<cfif rc.Form.getSectionType().getTypeID() IS 2>
						<legend>#local.Section.getName()#</legend>
					</cfif>--->			
					<cfloop from="1" to="#rc.Form.countFields()#" index="count" >
						<cfset field = rc.Form.getFields()[count] />
						<cfset fieldTypeID = field.getFieldType().getTypeID() />
						<cfset fieldName = 'field' & field.getSortOrder() & '~' & field.getFieldID() />
						<cfset fieldLabel = len(field.getLabel()) ? field.getLabel() : field.getName() />		

						<cfif fieldTypeID LT 6>
							<div class="control-group">
						 	<label class="control-label col-lg-4">#fieldLabel#</label>
						 	<div class="controls">
						</cfif>
						
					  	<cfswitch expression="#fieldTypeID#" >
						  	<cfcase value="1" >
							  <input id="field#field.getFieldID()#" name="#fieldName#" type="text" placeholder="#field.getHelpText()#" class="#(len(field.getCSS_Class())?field.getCSS_Class():'input-xlarge')#" >
					   		</cfcase>
						  	<cfcase value="2" >
							  	<textarea id="field#field.getFieldID()#" name="#fieldName#" placeholder="#field.getHelpText()#" class="#(len(field.getCSS_Class())?field.getCSS_Class():'field span6')#" rows="3"></textarea>
   								<!---<p class="help-block">extra help</p>--->
							</cfcase>
							<cfcase value="3">
								<cfloop array="#field.getOptions()#" index="option" >
								<label class="#(len(field.getCSS_Class())?field.getCSS_Class():'radio')#">
							      <input type="radio" id="field#field.getFieldID()#opt#option.getOptionID()#" name="#fieldName#" value="#len(option.getValue())?option.getValue():option.getLabel()#" <cfif option.getIsSelected() IS 1>checked="checked"</cfif>>#option.getLabel()#
							    </label>
								</cfloop>
								<cfif field.getAddOther()>
									<label class="#(len(field.getCSS_Class())?field.getCSS_Class():'radio')#">
							      <input type="radio" id="field#field.getFieldID()#optOther" name="#fieldName#" value="Other" <cfif option.getIsSelected() IS 1>checked="checked"</cfif>>Other: &nbsp;
							      <span><input id="field#field.getFieldID()#OtherDetail" name="#fieldName#_Other_Detail" type="text" class="input-large"></span>
							    </label>
								</cfif>
							</cfcase>
							<cfcase value="4">
								<cfloop array="#field.getOptions()#" index="option" >
								<label class="#(len(field.getCSS_Class())?field.getCSS_Class():'checkbox')#">
							      <input type="checkbox" id="field#field.getFieldID()#opt#option.getOptionID()#" name="#fieldName#" value="#len(option.getValue())?option.getValue():option.getLabel()#" <cfif option.getIsSelected() IS 1>checked="checked"</cfif>>
							     #option.getLabel()#
							    </label>
								</cfloop>
								<cfif field.getAddOther()>
									<label class="#(len(field.getCSS_Class())?field.getCSS_Class():'checkbox')#">
							      <input type="checkbox" id="field#field.getFieldID()#optOther" name="#fieldName#" value="Other" <cfif option.getIsSelected() IS 1>checked="checked"</cfif>>Other: &nbsp;
							      <span><input id="field#field.getFieldID()#OtherDetail" name="#fieldName#_Other_Detail" type="text" class="input-large"></span>
							    </label>
								</cfif>
							</cfcase>
							<cfcase value="5">
								<select id="field#field.getFieldID()#" name="#fieldName#" class="#(len(field.getCSS_Class())?field.getCSS_Class():'input-xlarge')#">
							      <cfloop array="#field.getOptions()#" index="option" >
								<option value="#len(option.getValue())?option.getValue():option.getLabel()#" <cfif option.getIsSelected() IS 1>selected="selected"</cfif>>#option.getLabel()#</option>
								</cfloop>
							    </select>
							</cfcase>
							<cfcase value="6">
								<div>#field.getHelpText()#</div>
							</cfcase>
							<cfcase value="7">
								<!--- field type is a new tab --->
								<div id="tab#field.getFieldID()#" class="tab-pane fade <cfif field.getSortOrder() IS 1>in active</cfif>">
							</cfcase>
							<cfcase value="8">
								<!--- field type is a group start --->
								<fieldset>  
								<legend>#fieldLabel#</legend>  
							</cfcase>
							<cfcase value="9">
								<!--- field type is a group end --->
								</fieldset>  
							</cfcase>
						</cfswitch>
						<cfif fieldTypeID LT 6>
							   </div>
							</div>
						</cfif>


						<!--- check if the next item is another tab, if so add the button and close the tab --->
						<cfif count is NOT rc.Form.countFields()>
							<cfset nextCount = count + 1>
							<cfset nextfield = rc.Form.getFields()[nextCount] />
							<cfif nextfield.getFieldType().getTypeID() IS 7>
									<div class="control-group">
									  <label class="control-label"></label>
									  <div class="controls">
									    <button id="nextTab-#nextfield.getFieldID()#" name="singlebutton" class="btn btn-primary">Save &amp; Continue</button>
									  </div>
									</div>
								 </div>
							</cfif>
						</cfif>

					</cfloop>
						<!-- Button -->
					<div class="control-group">
					  <label class="control-label"></label>
					  <div class="controls">
					    <button id="submit-form" name="singlebutton" class="btn btn-primary">Submit Your Answers</button>
					  </div>
					</div>

			<cfif arrayLen(rc.Form.getTabs())>
			  		</div><!-- /.tab-content -->
				</div><!-- /.tabbable -->
			</cfif>

		</form>
	<!---</cfif>--->	

</cfoutput>