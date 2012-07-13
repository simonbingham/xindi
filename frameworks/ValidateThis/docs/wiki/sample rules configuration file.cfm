== Sample Rules Definition File ==

The following is an example of a rules definition file that demonstrates all of the elements and attributes that are available in the [[Rules Configuration File | xml schema]]. It also illustrates a number of validation types. The complete file is listed, followed by excerpts from the file with a more detailed description.

=== The Complete File ===
<source lang="xml">
<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="MustLikeSomething" 
			serverTest="getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0"
			clientTest="$(&quot;[name='LikeCheese']&quot;).getValue() == 0 &amp;&amp; $(&quot;[name='LikeChocolate']&quot;).getValue() == 0;" />
	</conditions>
	<contexts>
		<context name="Register" formName="frmRegister" />
		<context name="Profile" formName="frmProfile" />
	</contexts>
	<objectProperties>
		<property name="UserName" desc="Email Address">
			<rule type="required" contexts="*" />
			<rule type="email" contexts="*" failureMessage="Hey, buddy, you call that an Email Address?" />
		</property>
		<property name="Nickname">
			<rule type="custom" failureMessage="That Nickname is already taken.  Please try a different Nickname.">
				<param methodname="CheckDupNickname" />
				<param remoteURL="CheckDupNickname.cfm" />
			</rule>
		</property>
		<property name="UserPass" desc="Password">
			<rule type="required" contexts="*" />
			<rule type="rangelength" contexts="*">
				<param minlength="5" />
				<param maxlength="10" />
			</rule>
		</property>
		<property name="VerifyPassword" desc="Verify Password">
			<rule type="required" contexts="*" />
			<rule type="equalTo" contexts="*">
				<param ComparePropertyName="UserPass" />
			</rule>
		</property>
		<property name="UserGroup" desc="User Group" clientfieldname="UserGroupId">
			<rule type="required" contexts="*" />
		</property>
		<property name="Salutation">
			<rule type="required" contexts="Profile" />
			<rule type="regex" contexts="*"
				failureMessage="Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.">
				<param Regex="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$" />
			</rule>
		</property>
		<property name="FirstName" desc="First Name">
			<rule type="required" contexts="Profile" />
		</property>
		<property name="LastName" desc="Last Name">
			<rule type="required" contexts="Profile" />
			<rule type="required" contexts="Register">
				<param DependentPropertyName="FirstName" />
			</rule>
		</property>
		<property name="LikeOther" desc="What do you like?">
			<rule type="required" contexts="*" condition="MustLikeSomething"
				failureMessage="If you don't like Cheese and you don't like Chocolate, you must like something!">
			</rule>
		</property>
		<property name="HowMuch" desc="How much money would you like?">
			<rule type="numeric" contexts="*" />
		</property>
		<property name="AllowCommunication" desc="Allow Communication" />
		<property name="CommunicationMethod" desc="Communication Method">
			<rule type="required" contexts="*"
				failureMessage="If you are allowing communication, you must choose a communication method.">
				<param DependentPropertyName="AllowCommunication" />
				<param DependentPropertyValue="1" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
</source>

=== The conditions Element ===
<source lang="xml">
<conditions>
	<condition name="MustLikeSomething" 
		serverTest="getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0"
		clientTest="$(&quot;[name='LikeCheese']&quot;).getValue() == 0 &amp;&amp; $(&quot;[name='LikeChocolate']&quot;).getValue() == 0;" />
</conditions>
</source>

Here we are defining one condition, and giving it a unique name of ''MustLikeSomething''. We then specify how the condition is to be evaluated on both the server and the client.<br />
In the case of the server we are saying:<br />
"This condition is met when the value of ''getLikeCheese()'' is zero and the value of ''getLikeChocolate()'' is zero."<br />
While on the client we are saying:<br />
"This condition is met when the value of the html element with a name attribute of ''LikeCheese'' is zero and the value of the html element with a name attribute of ''LikeChocolate'' is zero."<br />
Note that because we are placing actual JavaScript code into an xml attribute we must escape the special characters.

This condition, ''MustLikeSomething'' will be used in a rule definition later in the file.

=== The contexts Element ===
<source lang="xml">
<contexts>
	<context name="Register" formName="frmRegister" />
	<context name="Profile" formName="frmProfile" />
</contexts>
</source>

Here we are defining two contexts and pointing them at particular forms. We are doing this because each form has a unique name, and specifying these here, in the configuration file, means that we won't have to specify the form name when asking the framework to generate client-side validations for us.<br />
If the forms had the same name, e.g., frmUser, there would be no reason to include this ''contexts'' element at all. It '''is not''' required to make use of contexts for validation rules, its sole purpose is to point a context at a particular form.

=== The objectProperties Element ===

We define all of the properties that the framework needs to know about in the ''objectProperties'' element. There are two reasons that a property might need to be defined to the framework:
<ol>
	<li>It requires that validation rules be defined for it.</li>
	<li>It needs a description recorded for it.  E.g., if it relates to another property with a rule (e.g., via an equalTo rule type).</li>
</ol>

Each property's rules is followed by a textual description of what the element implies.

<source lang="xml">
<property name="UserName" desc="Email Address">
	<rule type="required" contexts="*" />
	<rule type="email" contexts="*" failureMessage="Hey, buddy, you call that an Email Address?" />
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''Email Address''.</li>
	<li>The UserName property is required, and must be a valid email address.</li>
	<li>Both rules apply to all contexts (because the context="*").</li>
	<li>If the UserName does not contain a valid email address, the message "''Hey, buddy, you call that an Email Address?''" should be returned.</li>
</ul>

<source lang="xml">
<property name="Nickname">
	<rule type="custom" failureMessage="That Nickname is already taken.  Please try a different Nickname."> <!-- Specifying no context is the same as specifying a context of "*" -->
		<param methodname="CheckDupNickname" />
		<param remoteURL="CheckDupNickname.cfm" />
	</rule>
</property>
</source>
<ul>
	<li>The Nickname property will be tested on both the client and the server. On the server the method ''CheckDupNickname()'', which resides in the User Business Object, will be evaluated. On the client, an ajax call will be made to the url ''CheckDupNickname.cfm'', with the result being evaluated by the jQuery plugin.</li>
	<li>The custom rule applies to all contexts (because the context attribute is missing).</li>
	<li>If the custom validation fails, the message "''That Nickname is already taken.  Please try a different Nickname.''" should be returned.</li>
</ul>

<source lang="xml">
<property name="UserPass" desc="Password">
	<rule type="required" contexts="*" />
	<rule type="rangelength" contexts="*">
		<param minlength="5" />
		<param maxlength="10" />
	</rule>
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''Password''.</li>
	<li>The UserPass property is required, and must be between 5 and 10 characters long.</li>
</ul>

<source lang="xml">
<property name="VerifyPassword" desc="Verify Password">
	<rule type="required" contexts="*" />
	<rule type="equalTo" contexts="*">
		<param ComparePropertyName="UserPass" />
	</rule>
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''Verify Password''.</li>
	<li>The VerifyPassword property is required, and must be the same as the UserPass property.</li>
</ul>

<source lang="xml">
<property name="UserGroup" desc="User Group" clientfieldname="UserGroupId">
	<rule type="required" contexts="*" />
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''User Group''.</li>
	<li>The id of the form field which will contain the value to be evaluated is ''UserGroupId''.</li>
	<li>The UserGroup property is required.</li>
</ul>

<source lang="xml">
<property name="Salutation">
	<rule type="required" contexts="Profile" />
	<rule type="regex" contexts="*"
		failureMessage="Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.">
		<param Regex="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$" />
	</rule>
</property>
</source>
<ul>
	<li>The Salutation property is required, and must conform to a regular expression.</li>
	<li>The Salutation property is only required in the context of ''Profile''.</li>
	<li>If the Salutation does not conform to the regular expression, the message "''Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.''" should be returned.</li>
</ul>

<source lang="xml">
<property name="FirstName" desc="First Name">
	<rule type="required" contexts="Profile" />
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''First Name''.</li>
	<li>The FirstName property is required, but only in the context of ''Profile''.</li>
</ul>

<source lang="xml">
<property name="LastName" desc="Last Name">
	<rule type="required" contexts="Profile" />
	<rule type="required" contexts="Register">
		<param DependentPropertyName="FirstName" />
	</rule>
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''Last Name''.</li>
	<li>The LastName property is always required in the context of ''Profile'', and is also required in the context of ''Register'', but only if a FirstName has also been specified.</li>
</ul>

<source lang="xml">
<property name="LikeOther" desc="What do you like?">
	<rule type="required" contexts="*" condition="MustLikeSomething"
		failureMessage="If you don't like Cheese and you don't like Chocolate, you must like something!">
	</rule>
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''What do you like?''.</li>
	<li>The LikeOther property is required in all contexts, but only if the condition ''MustLikeSomething'' evaluates to ''true''. Note that that condition was defined in the ''conditions'' element described above.</li>
	<li>If the LikeOther is not provided, the message "''If you don't like Cheese and you don't like Chocolate, you must like something!''" should be returned.</li>
</ul>

<source lang="xml">
<property name="HowMuch" desc="How much money would you like?">
	<rule type="numeric" contexts="*" />
</property>
</source>
<ul>
	<li>The descriptive name of the property is ''How much money would you like?''.</li>
	<li>The HowMuch property must contain a numeric value.</li>
</ul>

<source lang="xml">
<property name="AllowCommunication" desc="Allow Communication" />
<property name="CommunicationMethod" desc="Communication Method">
	<rule type="required" contexts="*"
		failureMessage="If you are allowing communication, you must choose a communication method.">
		<param DependentPropertyName="AllowCommunication" />
		<param DependentPropertyValue="1" />
	</rule>
</property>
</source>
<ul>
	<li>The descriptive name of the AllowCommunication property is ''Allow Communication''. Note that this property does not have any rules assigned to it, but is being defined to that the rule that makes use of it (defined on the ''CommunicationMethod'' property) can generate a friendly validation failure message.</li>
	<li>The descriptive name of the CommunicationMethod property is ''Communication Method''.</li>
	<li>The CommunicationMethod property is required in all contexts, but only if the AllowCommunication property has been assigned a value of 1.</li>
	<li>If the CommunicationMethod is not provided, the message "''If you are allowing communication, you must choose a communication method.''" should be returned.</li>
</ul>
