= Validation Types Supported By ValidateThis =

ValidateThis comes bundled with a number of validation types, and you can also add your own validation types. This page describes all of the built-in validation types.
<br/>
== Default Failure Messages ==
Each validation type generates a default message when it fails, which generally includes the name of the property for which the failure occurred, as well as the values of the parameters defined for the rule. The default failure message for each rule type is documented below.

Note that by default each failure message is prepended with the word "The ", followed by the property description, for example "The Email Address is required." You can change the text that is prepended to the default validation failure message using the ''defaultFailureMessagePrefix'' key of the [[ValidateThisConfig Struct]]. For example, if you set defaultFailureMessagePrefix="", the example message above would be generated as "Email Address is required".

== Built-In Validation Types ==

=== Required ===
The ''Required'' type ensures that the contents of a property is not empty.

''' Parameters:'''
None

''' Default Failure Message: '''
The ''propertyDescription'' is required.

''' Metadata Example: '''
<source lang="xml">
<rule type="required" />
</source>

<br/>
=== Boolean ===
The ''Boolean'' type ensures that the contents of a property is a valid ColdFusion boolean value.

''' Parameters:'''
None

''' Default Failure Message: '''
The ''propertyDescription'' must be a valid boolean.

''' Metadata Example: '''
<source lang="xml">
<rule type="boolean" />
</source>

<br />
=== Date ===
The ''Date'' type ensures that the contents of a property is a valid date value.

''' Parameters:'''
None

''' Default Failure Message: '''
The ''propertyDescription'' must be a valid date.

''' Metadata Example: '''
<source lang="xml">
<rule type="date" />
</source>

<br />
=== Integer ===
The ''Integer'' type ensures that the contents of a property is a valid integer value.

''' Parameters:'''
None

''' Default Failure Message: '''
The ''propertyDescription'' must be an integer.

''' Metadata Example: '''
<source lang="xml">
<rule type="integer" />
</source>

<br />
=== Numeric ===
The ''Numeric'' type ensures that the contents of a property is a valid numeric value.

''' Parameters:'''
None

''' Default Failure Message: '''
The ''propertyDescription'' must be a number.

''' Metadata Example: '''
<source lang="xml">
<rule type="numeric" />
</source>

<br />
=== Email ===
The ''Email'' type ensures that the contents of a property is a valid email address.

''' Parameters:'''
None

''' Default Failure Message: '''
The ''propertyDescription'' must be a valid email address.

''' Metadata Example: '''
<source lang="xml">
<rule type="email" />
</source>

Note that the test on the client-side uses the jQuery Validation plugin's built-in email validator and the test on the server-side uses ColdFusion's isValid(), so the results are not always identical. It is possible to have an email address that passes on the client and not on the server.

<br />
=== Min ===
The ''Min'' type ensures that the contents of a property contains a minimum value.

''' Parameters:'''
* ''min'' - a number

''' Default Failure Message: '''
The ''propertyDescription'' must be at least ''min''.

''' Metadata Example: '''
<source lang="xml">
<rule type="min">
	<param min="5" />
</rule>
</source>

This will ensure that the property has a value of ''5'' or more.

<br />
=== Max ===
The ''Max'' type ensures that the contents of a property contains a maximum value.

''' Parameters:'''
* ''max'' - a number

''' Default Failure Message: '''
The ''propertyDescription'' must be no more than ''max''.

''' Metadata Example: '''
<source lang="xml">
<rule type="max">
	<param max="5" />
</rule>
</source>

This will ensure that the property has a value of ''5'' or less.

<br />
=== Range ===
The ''Range'' type ensures that the contents of a property contains a value between two numbers.

''' Parameters:'''
* ''min'' - a number
* ''max'' - a number

''' Default Failure Message: '''
The ''propertyDescription'' must be between ''min'' and ''max''.

''' Metadata Example: '''
<source lang="xml">
<rule type="range">
	<param min="5" />
	<param max="10" />
</rule>
</source>

This will ensure that the property has a value between ''5'' and ''10''.

<br />
=== MinLength ===
The ''MinLength'' type ensures that the length of the contents of a property is at least a certain number of characters.

''' Parameters:'''
* ''minLength'' - a number

''' Default Failure Message: '''
The ''propertyDescription'' must be at least ''minLength'' characters long.

''' Metadata Example: '''
<source lang="xml">
<rule type="minLength">
	<param minLength="5" />
</rule>
</source>

This will ensure that the contents of the property is at least ''5'' characters long.

<br />
=== MaxLength ===
The ''MaxLength'' type ensures that the length of the contents of a property is no more than a certain number of characters.

''' Parameters:'''
* ''maxLength'' - a number

''' Default Failure Message: '''
The ''propertyDescription'' must be no more than ''maxLength'' characters long.

''' Metadata Example: '''
<source lang="xml">
<rule type="maxLength">
	<param maxLength="5" />
</rule>
</source>

This will ensure that the contents of the property is no more than ''5'' characters long.

<br />
=== RangeLength ===
The ''RangeLength'' type ensures that the length of the contents of a property is between two numbers.

''' Parameters:'''
* ''minLength'' - a number
* ''maxLength'' - a number

''' Default Failure Message: '''
The ''propertyDescription'' must be between ''minLength'' and ''maxLength'' characters long.

''' Metadata Example: '''
<source lang="xml">
<rule type="rangeLength">
	<param minLength="5" />
	<param maxLength="10" />
</rule>
</source>

This will ensure that the contents of the property is between ''5'' and ''10'' characters long.

<br />
=== EqualTo ===
The ''EqualTo'' type ensures that the contents of one property is the same as the contents of another property.

''' Parameters:'''
* ''comparePropertyName'' - the name of another property

''' Default Failure Message: '''
The ''propertyDescription'' must be the same as the ''comparePropertyDescription'.

''' Metadata Example: '''
<source lang="xml">
<rule type="equalTo">
	<param comparePropertyName="anotherProperty" />
</rule>
</source>

This will ensure that the contents of the property is the same as the contents of the ''anotherProperty'' property.

<br />
=== Regex ===
The ''Regex'' type ensures that the contents of a property conforms to a regular expression.

''' Parameters:'''
* ''regex'' - a regular expression
* ''serverRegex (optional)'' - a regular expression

''' Default Failure Message: '''
The ''propertyDescription'' must match the specified pattern.

''' Metadata Example: '''
<source lang="xml">
<rule type="regex">
	<param regex="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$" />
</rule>
</source>

This will ensure that the contents of the property matches the expression. Note that you can provide a CFML-only regex using the ''serverRegex'' parameter, otherwise the same regex will be used on the client and the server.

<br />
=== Custom ===
The ''Custom'' type allows you to create a validation which uses any arbitrary CFML code. You do so by specifying the name of a method in your object that will perform the validation.

''' Parameters:'''
* ''methodName'' - the name of the method in your object that determines whether the validation passes or not
* ''remoteURL (optional)'' - a url that can be called via AJAX which will run code to determine whether the validation passes or not, and returns a message to the client

''' Default Failure Message: '''
A custom validator failed.
Note that this should be overridden using either the ''failureMessage'' attribute of the rule or via the data returned from the method called, although the former will not return a meaningful message for client-side validations.

''' Metadata Example: '''
<source lang="xml">
<rule type="custom">
	<param methodName="checkDuplicateNickname" />
	<param remoteURL="checkDuplicateNickname.cfm" />
</rule>
</source>

The method defined in your object, which would be ''checkDuplicateNickname'' in the above example, should return a structure with at least one key: ''isSuccess'', which should be set to ''true'' if the validation passed and to ''false'' if the validation failed. The structure can also contain a ''failureMessage'' key, which would contain the message to display upon failure.
The process that is reached via the ''remoteURL'' parameter must return a simple text string, which should which should be ''true'' if the validation passed and ''false'' if the validation failed.

<br />
<br />

== Server Only Validation Types ==

=== Expression ===
The ''Expression'' type ensures that a cfml expression evaluates to true.

''' Parameters:'''
* ''expression'' - the cfml expression to evaluate on the object.

''' Default Failure Message: '''
[NONE]

''' Metadata Example: '''
<source lang="xml">
<rule type="expression" failureMessage="Foo is not equal to Bar">
	<param name="expression" value="getFoo() eq getBar()" />
</rule>
</source>
