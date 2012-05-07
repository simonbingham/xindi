<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="firstname" desc="first name">
			<rule type="required" contexts="create,update" />
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="50" />
			</rule>	
		</property>
		<property name="lastname" desc="last name">
			<rule type="required" contexts="create,update" />
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="50" />
			</rule>	
		</property>
		<property name="email" desc="email address">
			<rule type="required" contexts="create,update" />
			<rule type="email" contexts="create,update" />
			<rule type="custom" contexts="create,update" failureMessage="The email address is registered to an existing account.">
        		<param name="methodname" value="isEmailUnique" />
		    </rule>
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="150" />
			</rule>	
		</property>
		<property name="username" desc="username">
			<rule type="required" contexts="create,update,login" />
			<rule type="custom" contexts="create,update" failureMessage="The username is registered to an existing account.">
        		<param name="methodname" value="isUsernameUnique" />
		    </rule>
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="50" />
			</rule>	
		</property>
		<property name="password" desc="password">
			<rule type="required" contexts="create,login" />
		</property>
	</objectProperties>
</validateThis>