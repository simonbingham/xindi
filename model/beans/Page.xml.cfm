<!--
   Copyright 2012, Simon Bingham

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="title" desc="title">
			<rule type="required" />
			<rule type="maxLength">
				<param name="maxLength" value="150" />
			</rule>				
		</property>
		<property name="navigationtitle" desc="navigation title">
			<rule type="required" />
			<rule type="maxLength">
				<param name="maxLength" value="150" />
			</rule>				
		</property>		
		<property name="content" desc="content">
			<rule type="required" />
		</property>	
		<property name="metatitle" desc="meta title">
			<rule type="maxLength">
				<param name="maxLength" value="100" />
			</rule>				
		</property>
		<property name="metadescription" desc="meta description">
			<rule type="maxLength">
				<param name="maxLength" value="200" />
			</rule>				
		</property>
		<property name="metakeywords" desc="meta keywords">
			<rule type="maxLength">
				<param name="maxLength" value="200" />
			</rule>				
		</property>					
	</objectProperties>
</validateThis>