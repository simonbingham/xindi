== Defining Business Rules ==

There are currently two means of defining the business rules for your objects.

=== Rules Configuration File ===

My preferred method is to define all of the validation rules for a specific Business Object in an xml file. Among the reasons that I prefer this are:
<ul>
	<li>The definitions of the business rules are kept separate from the code of the object itself.<br />
		This provides a couple of benefits:
		<ul>
			<li>One can change business rules without having to open up the object code, which removes the chance of bugs being introduced into the code.</li>
			<li>One can change one's approach to validations for an object (by switching to a different validation framework, for example) without having to make any changes to the object's code.</li>
		</ul>
	</li>
	<li>The xml schema provides a very concise way of describing the validation rules for an object. There is absolutely no duplication of information required.</li>
</ul>

Details of the xml schema for the rules configuration file can be found in the [[Rules Configuration File]] reference.
A sample rules configuration file can be found at [[Sample Rules Configuration File]].

=== The addRule() Method ===

There are times when rules must be added dynamically, and I also understand that some people are xml-averse. For those reasons the framework provides an ''addRule()'' method which enables a developer to define validation rules using CFML code.

The ''addRule()'' method accepts the following arguments:
<ul>
	<li></li>
</ul> 

It should also be possible to create an unlimited number of client-side validation implementations, and a new implementation can be created without having to touch any of the existing framework code.  An implementation is a way of converting the business rules into JavaScript code.
The framework currently ships with a single JavaScript implementation:
<ul>
	<li>jQuery Validation Plugin</li>
</ul>

=== Code Generation ===

A developer should be able to define the validation rules in a simple manner in a single location, and the framework will generate all server-side and client-side validation code automatically.
Examples of validation rules are:
<ul>
	<li>UserName is required</li>
	<li>UserName must be between 5 and 10 characters long</li>
	<li>UserName must be unique</li>
	<li>Password must be equal to VerifyPassword</li>
	<li>If ShippingType is "Express", a ShippingMethod must be selected</li>
</ul>

The framework should be able to generate generic, but specific, validation failure messages, any of which can be overridden by an application developer.
Examples of generic failure messages corresponding to the example rules above are:
<ul>
	<li>The User Name is required.</li>
	<li>The User Name must be between 5 and 10 characters long.</li>
	<li>The User Name must be unique.</li>
	<li>The Password must be the same as the Verify Password.</li>
	<li>The Shipping Method is required when selecting a Shipping Type of "Express".</li>
</ul>

=== Flexible Feedback ===

The framework should return flexible metadata back to the calling application which will allow for customization of how the validation failures will appear to the end user.  This metadata will include more than just the failure messages generated.  The framework will not dictate in any way how the view will communicate validation failures to the user.

Any invalid values supplied by a user should be returned by the Business Object when requested.  For example, if one has a Product Business Object with a Price property that can only accept numeric data, if a user provides the value "Bob" in the Price property of a form, when the Product object is returned to the view, calling getPrice() will return the value "Bob".
'''Note:''' A technique for achieving this is demonstrated in a sample application that ships with the framework, but the framework itself is not involved in "saving" this invalid data.

=== Persistence Layer Agnostic ===

It should be possible to implement the framework, without making any modifications, into a model that uses any ORM or no ORM at all. The only requirement is that the model makes use of Business Objects.
Note: The framework has been successfully implemented into applications using with Transfer, Reactor and ColdFusion 9's ORM features.

=== MVC Framework Agnostic ===

It should be possible to implement the framework in any application using any MVC framework.  That would include Fusebox, Model-Glue, Mach-II, ColdBox, FW/1 and any homegrown MVC framework.  This kind of goes without saying, as the framework is specific to the model layer of your application.
Note: A Coldbox plugin has been developed which makes integration of the framework into Coldbox even simpler.

