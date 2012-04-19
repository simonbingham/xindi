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
		<property name="firstname" desc="first name">
			<rule type="required" contexts="create,update" />
		</property>
		<property name="lastname" desc="last name">
			<rule type="required" contexts="create,update" />
		</property>
		<property name="email" desc="email address">
			<rule type="required" contexts="create,update" />
			<rule type="email" contexts="create,update" />
			<rule type="custom" contexts="create,update" failureMessage="The email address is registered to an existing account.">
        		<param name="methodname" value="isEmailUnique" />
		    </rule>
		</property>
		<property name="username" desc="username">
			<rule type="required" contexts="create,update,login" />
			<rule type="custom" contexts="create,update" failureMessage="The username is registered to an existing account.">
        		<param name="methodname" value="isUsernameUnique" />
		    </rule>
		</property>
		<property name="password" desc="password">
			<rule type="required" contexts="create,login" />
		</property>
	</objectProperties>
</validateThis>