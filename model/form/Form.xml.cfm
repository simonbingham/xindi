<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="name" desc="name">
			<rule type="required" />
			<rule type="maxLength">
				<param name="maxLength" value="150" />
			</rule>				
		</property>		
		<property name="longname" desc="long name">
			<rule type="required" />
			<rule type="maxLength">
				<param name="maxLength" value="250" />
			</rule>	
		</property>	
		<property name="instructions" desc="instructions">
			<rule type="maxLength">
				<param name="maxLength" value="2000" />
			</rule>				
		</property>		
		<property name="ispublished" desc="published ">
			<rule type="required" />
		</property>	
		<property name="submitmessage" desc="submitmessage">
			<rule type="maxLength">
				<param name="maxLength" value="2000" />
			</rule>				
		</property>		
		<property name="emailto" desc="emailto ">
			<rule type="email" />
				<rule type="maxLength">
				<param name="maxLength" value="250" />
			</rule>	
		</property>	
		<property name="css_id" desc="CSS ID">
			<rule type="maxLength">
				<param name="maxLength" value="150" />
			</rule>				
		</property>		
		<property name="css_class" desc="CSS Class">
			<rule type="maxLength">
				<param name="maxLength" value="150" />
			</rule>				
		</property>		
	</objectProperties>
</validateThis>