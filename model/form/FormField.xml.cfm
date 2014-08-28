<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="required" desc="required ">
			<rule type="required" />
		</property>		
		<property name="name" desc="name">
			<rule type="required" />
			<rule type="maxLength">
				<param name="maxLength" value="250" />
			</rule>	
		</property>		
		<!--<property name="label" desc="label">
			<rule type="required" />
			<rule type="maxLength">
				<param name="maxLength" value="750" />
			</rule>				
		</property>	-->
		<property name="maxlength" desc="max length ">
			<rule type="integer" />
		</property>				
		<property name="css_class" desc="CSS Class">
			<rule type="maxLength">
				<param name="maxLength" value="150" />
			</rule>				
		</property>		
	</objectProperties>
</validateThis>