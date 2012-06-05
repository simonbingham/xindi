<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="firstname" desc="first name">
			<rule type="required" failuremessage="Enter your first name." />
		</property>
		<property name="lastname" desc="last name">
			<rule type="required" failuremessage="Enter your last name."  />
		</property>
		<property name="email" desc="email address">
			<rule type="required" failuremessage="Enter your email address."  />
			<rule type="email" failuremessage="Enter a valid email address." />
		</property>		
		<property name="message" desc="message">
			<rule type="required" failuremessage="Enter a message." />
		</property>	
	</objectProperties>
</validateThis>