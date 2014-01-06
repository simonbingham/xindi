<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="name" desc="name">
			<rule type="required" failuremessage="Enter your name." />
			<rule type="maxLength">
				<param name="maxLength" value="50" />
			</rule>
		</property>
		<property name="email" desc="email address">
			<rule type="required" failuremessage="Enter your email address." />
			<rule type="email" failuremessage="Enter a valid email address." />
			<rule type="maxLength">
				<param name="maxLength" value="150" />
			</rule>
		</property>
		<property name="message" desc="message">
			<rule type="required" failuremessage="Enter a message." />
		</property>
	</objectProperties>
</validateThis>
