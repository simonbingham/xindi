<cfoutput>
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
	
	<form class="form-horizontal">
		<cfif arrayLen(rc.Form.getSections())>
			<cfif rc.Form.getSectionType().getTypeID() IS 1>
				<div class="tabbable">
				  <ul class="nav nav-tabs">
				  	<cfloop array="#rc.Form.getSections()#" index="local.Section">
				    <li <cfif local.Section.getSortOrder() IS 1>class="active"</cfif>><a href="##section#local.Section.getSectionID()#" data-toggle="tab">#local.Section.getName()#</a></li>
				    </cfloop>
				  </ul>
				  <div class="tab-content">
			</cfif> 	
				
			  	<cfloop array="#rc.Form.getSections()#" index="local.Section">
			    <div id="section#local.Section.getSectionID()#" class="tab-pane <cfif local.Section.getSortOrder() IS 1>active</cfif>">
					<fieldset>
					<cfif rc.Form.getSectionType().getTypeID() IS 2>
						<legend>#local.Section.getName()#</legend>
					</cfif>
					<!-- Form Name -->				
					<cfloop array="#local.Section.getFields()#" index="field" >
						<div class="control-group">
						<cfif field.getFieldType().getTypeID() LT 6>
						 	<label class="control-label col-lg-4">#field.getPrompt()#</label>
						</cfif>
						  <div class="controls">
						  	<cfswitch expression="#field.getFieldType().getTypeID()#" >
							  	<cfcase value="1" >
								  <input id="textinput#field.getFieldID()#" name="textinput#field.getFieldID()#" type="text" placeholder="help text" class="#(len(field.getCSS_Class())?field.getCSS_Class():'input-xlarge')#" required="Sample text is required">
						   		</cfcase>
							  	<cfcase value="2" >
								  	<textarea name="textinput#field.getFieldID()#" placeholder="prompt" class="#(len(field.getCSS_Class())?field.getCSS_Class():'field span6')#" rows="3"></textarea>
	   								<!---<p class="help-block">extra help</p>--->
								</cfcase>
								<cfcase value="3">
									<cfloop array="#field.getOptions()#" index="option" >
									<label class="#(len(field.getCSS_Class())?field.getCSS_Class():'radio')#">
								      <input type="radio" name="radios#field.getFieldID()#" value="#option.getOptionID()#" <cfif option.getSortOrder() IS 1>checked="checked"</cfif>>
								     #option.getPrompt()#
								    </label>
									</cfloop>
								</cfcase>
								<cfcase value="4">
									<cfloop array="#field.getOptions()#" index="option" >
									<label class="#(len(field.getCSS_Class())?field.getCSS_Class():'checkbox')#">
								      <input type="checkbox" name="check#field.getFieldID()#" value="#option.getOptionID()#" checked="checked">
								     #option.getPrompt()#
								    </label>
									</cfloop>
								</cfcase>
								<cfcase value="5">
									<select id="selectbasic#field.getFieldID()#" name="selectbasic#field.getFieldID()#" class="#(len(field.getCSS_Class())?field.getCSS_Class():'input-xlarge')#">
								      <cfloop array="#field.getOptions()#" index="option" >
									<option value="#option.getOptionID()#">#option.getPrompt()#</option>
									</cfloop>
								    </select>
								</cfcase>
								<cfcase value="6">
									<div>#field.getPrompt()#</div>
								</cfcase>
							</cfswitch>
						   </div>
						</div>
					</cfloop>
						<!-- Button -->
						<cfif rc.Form.getSectionType().getTypeID() IS 1>
							<div class="control-group">
							  <label class="control-label"></label>
							  <div class="controls">
							    <button id="singlebutton" name="singlebutton" class="btn btn-primary">Save &amp; Continue</button>
							  </div>
							</div>
						</cfif>
						
						</fieldset>
	
				    </div>
					</cfloop>
			<cfif rc.Form.getSectionType().getTypeID() IS 1>
			  		</div><!-- /.tab-content -->
				</div><!-- /.tabbable -->
			<!-- Button -->
			<cfelse>
				<div class="control-group">
				  <label class="control-label"></label>
				  <div class="controls">
				    <button id="singlebutton" name="singlebutton" class="btn btn-primary">Save &amp; Continue</button>
				  </div>
				</div>
			</cfif>
		</form>
	</cfif>
	

</cfoutput>