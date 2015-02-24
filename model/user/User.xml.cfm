<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="name" desc="name">
			<rule type="required" contexts="create,update" />
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="50" />
			</rule>
		</property>
		<property name="email" desc="email address">
			<rule type="required" contexts="create,update,login" />
			<rule type="email" contexts="create,update" />
			<rule type="custom" contexts="create,update" failureMessage="The email address is registered to an existing account.">
				<param name="methodname" value="isEmailUnique" />
			</rule>
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="150" />
			</rule>
		</property>
		<property name="password" desc="password">
			<rule type="required" contexts="create,login" />
			<rule type="minLength" contexts="create,update" failureMessage="The password must be a minimum of 8 characters in length.">
				<param name="minLength" value="8" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
