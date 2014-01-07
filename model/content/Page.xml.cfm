<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="title" desc="title">
			<rule type="required" contexts="create,update" />
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="150" />
			</rule>
		</property>
		<property name="content" desc="content">
			<rule type="required" contexts="create,update" />
		</property>
		<property name="metatitle" desc="meta title">
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="100" />
			</rule>
		</property>
		<property name="metadescription" desc="meta description">
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="200" />
			</rule>
		</property>
		<property name="metakeywords" desc="meta keywords">
			<rule type="maxLength" contexts="create,update">
				<param name="maxLength" value="200" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
