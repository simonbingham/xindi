== Rules Definition File ==

Each business object will have its own corresponding rules definition file, in which all of the validation rules for the object are described. Currently this file can be in either XML or JSON format.

There is an ''xml schema document'' (xsd) which comes with the framework, located at /ValidateThis/core/validateThis.xsd. There is also an online version available at [http://www.validatethis.org/validateThis.xsd]. If you will be using XML files, it is '''highly recommended''' that you validate your files against this xml schema.

Annotated examples of both an XML and a JSON Rules Definition File are available on the [[Sample Rules Definition File]] page.

The following section describes all of the metadata that can be specified to describe your validation rules. It describes the metadata in terms of xml elements and attributes, but the conversion to JSON is straightforward. Please refer to the [[Sample Rules Definition File]] page for an example of the JSON format.

Items in ''italics'' denote an element attribute.

=== Elements ===

<ul>
	<li>
		<span id="validateThis"></span>
		'''validateThis'''<br/>
		Top level element for the xml file.
		<ul>
			<li>
				<span id="conditions"></span>
				'''conditions''' (optional)<br/>
				Specify any conditions that are to be assigned to rules below.
				<ul>
					<li>
						'''condition'''<br/>
						A condition that will be used in one or more rule.<br/>
						''name'' A unique name for the condition.<br/>
						''serverTest'' A ColdFusion expression that will evaluate to either true or false in the context of a Business Object.<br/>
						''clientTest (optional)'' A JavaScript expression that will evaluate to either true or false in the context of a form.<br/>
						''desc (optional)'' A description of the condition, used to generate validation failure messages.
					</li>					
				</ul>
			</li>
			<li>
				<span id="contexts"></span>
				'''contexts''' (optional)<br/>
				Specify any contexts for which you wish to define formNames.  These are used to target a particular form when generating client-side validations.<br />
				Note that you '''do not''' have to specify contexts here in order to use contexts in your rules. The only purpose of this element is to allow contexts to be assigned form names.
				<ul>
					<li>
					'''context'''<br/>
					A context that is targeted at a specific form.<br/>
					''name'' A unique name for the context.<br/>
					''formName'' The name of the form that corresponds to the context.  Used to support generating client-side validations for multiple forms on a single page.<br/>
					</li>					
				</ul>
			</li>
			<li>
				<span id="objectProperties"></span>
				'''objectProperties'''<br/>
				This is a container for all of the properties of the Business Object which need to be defined to the framework.
				<ul>
					<li>
						'''property'''<br/>
						A property element must be included for any property that either:
						<ol>
							<li>Has any rules defined for it.</li>
							<li>Needs a description recorded for it.  E.g., if it relates to another property with a rule (e.g., via an equalTo rule type).</li>
						</ol>
						''name'' The name of the property in your Business Object. The Business Object must have a corresponding getter, either explicitly or implicity.<br/>
						''desc (optional)'' A descriptive name for the property, used to generate validation failure messages. Defaults to the value of @name.<br/>
						''clientfieldname (optional)'' The fieldname (id, in fact) on a form that corresponds to the property. Defaults to the value of @name.<br />
						Note that ''clientfieldname'' need only be used if the name of your property differs from the form fieldname.
						For example, a User Object has a UserGroup, and therefore has a UserGroup property, but because UserGroup contains an object,
						we need to tell the framework the form fieldname (probably UserGroupId) in order to allow client-side validations to be generated for the field.<br/>
						<ul>
							<li>
					            <span id="rule"></span>
								'''rule'''<br/>
								A property may have any number of rules defined, including zero.<br />
								Note that defining multiple rules '''of the same type''' for the same property may cause problems for certain client-side validation routines.<br/>
								''type'' The type of validation to perform (e.g., required, email, custom, etc.).<br/>
								''contexts (optional)'' A comma delimited list of contexts in which the validation should be performed.<br />
								E.g., a User object might have a Register context, a PasswordChange context and an AddressChange context.<br />
								Note that either leaving the contexts attribute missing, or specifying a value of "" or "*" will cause the rule to be added to all contexts.<br />
								Note also that contexts are not required at all. A simple object might not need any contexts.<br />
								''failureMessage (optional)'' A message to display to the user when a validation failure occrus.  If none is specified the framework will generate a failure message.<br />
								''condition (optional)'' A condition that must evaluate to ''true'' in order for this validation rule to be applied.<br />
								Note that the value of the ''condition'' attribute must be the name of a condition that has been defined in the conditions element above.<br />
								<ul>
									<li>
							            <span id="param"></span>
										'''param'''<br/>
										A rule may have any number of params defined, including zero.<br />
										Certain rule types require that certain params be defined.  E.g., the MaxLength rule type requires a MaxLength param.<br />
										''name'' The name of the parameter (e.g., minLength, maxLength, methodName, etc.).<br/>
										''value'' The value of the parameter.<br />
										''type (optional)'' The type of the parameter. This can be one of either value, expression or property.<br />
										 Value is the default, which simply uses the parameter value as is.<br />
										 Expression means that ColdFusion is to evaluate the value of the parameter. For example, specifying a type of 'expression' and a value of 'Now()' will cause the actual value of the paremeter to be the current date/time.<br />
										 Property means that the actual value of the parameter should be the contents of a property of the object. For example, specifying a type of 'property' and a value of 'firstName' will cause the actual value of the parameter to be the contents of the firstName property.<br />
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>				
			</li>
		</ul>
	</li>
</ul>


[[Category:Configuration]]
