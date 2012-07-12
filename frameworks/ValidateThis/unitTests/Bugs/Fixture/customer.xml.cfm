<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="registerInterest" formName="registerInterestForm" />
		<context name="order" formName="orderForm" />
		<context name="signIn" formName="signinForm" />
	</contexts>

	<objectProperties>
		<property name="title" desc="Title">
			<rule type="required" contexts="registerInterest" failuremessage="Your title is required." />
		</property>

		<property name="firstName" desc="First name">
			<rule type="required" contexts="registerInterest" failuremessage="Your first name is required." />
		</property>

		<property name="lastName" desc="Last name">
			<rule type="required" contexts="registerInterest" failuremessage="Your last name is required." />
		</property>

		<property name="serviceTelephone" desc="Service telephone number">
			<rule type="required" contexts="registerInterest" failuremessage="Your service telephone number is required." />
		</property>

		<property name="daytimeTelephone" desc="Daytime telephone number">
			<rule type="required" contexts="order" failuremessage="Your daytime telephone number is required." />
		</property>

		<property name="emailAddress" desc="chosen email address">
			<rule type="required" contexts="registerInterest" failuremessage="Your current email address is required." />
			<rule type="email" contexts="registerInterest" failureMessage="Your email address must be in the correct format." />
		</property>

		<property name="confirmEmailAddress" desc="confirmation email address">
			<rule type="required" contexts="registerInterest" failuremessage="You must confirm your current email address." />
			<rule type="email" contexts="registerInterest" failureMessage="Your email address must be in the correct format. "/>

			<rule type="equalTo" contexts="registerInterest">
				<param name="ComparePropertyName" value="emailAddress" />
			</rule>
		</property>

		<property name="dateOfBirth" desc="Confirm date of birth">
			<rule type="required" contexts="order" failuremessage="Your date of birth is required for credit card security." />
		</property>

		<property name="serviceAddress" desc="Confirm address">
			<rule type="required" contexts="registerInterest" failuremessage="Your address is required." />
		</property>

		<property name="serviceAddress1" desc="Confirm address">
			<rule type="required" contexts="order" failuremessage="Your address is required." />
		</property>

		<property name="serviceTown" desc="Confirm town">
			<rule type="required" contexts="order" failuremessage="Your town is required." />
		</property>

		<property name="serviceCounty" desc="Confirm county">
			<rule type="required" contexts="order" failuremessage="Your county is required." />
		</property>

		<property name="servicePostcode" desc="Confirm postcode">
			<rule type="required" contexts="registerInterest" failuremessage="Your postcode is required." />
		</property>

		<property name="username" desc="Confirm username">
			<rule type="required" contexts="registerInterest,signIn" failuremessage="Your chosen username is required." />

			<rule type="custom" contexts="registerInterest">
				<param methodname="isUsernameAvailable" />
			</rule>
		</property>

		<property name="password" desc="chosen password">
			<rule type="required" contexts="registerInterest,signIn" failuremessage="Your chosen password is required." />

			<rule type="rangelength" contexts="registerInterest,signIn" failuremessage="Your chosen password must be 6 or more characters long.">
				<param minlength="6" />
				<param maxlength="255" />
			</rule>
		</property>

		<property name="confirmPassword" desc="confirmation password">
			<rule type="required" contexts="registerInterest" failuremessage="You must confirm your chosen password." />

			<rule type="rangelength" contexts="registerInterest" failuremessage="Your chosen password must be 6 or more characters long.">
				<param minlength="6" />
				<param maxlength="255" />
			</rule>

			<rule type="equalTo" contexts="registerInterest">
				<param ComparePropertyName="password" />
			</rule>
		</property>
	</objectProperties>
</validateThis>