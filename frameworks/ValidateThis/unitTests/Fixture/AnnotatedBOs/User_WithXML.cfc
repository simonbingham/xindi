/*
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
*/

component persistent="true" table="tblUser_A" vtContexts="Register|frmRegister,Profile|frmProfile"
	vtConditions="mustLikeSomething|getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0|$(""[name='likeCheese']"").getValue() == 0 && $(""[name='likeChocolate']"").getValue() == 0;" {
	
	property name="userId" type="numeric" fieldtype="id" generator="native";
	
	property name="userName" vtDesc="Email Address" vtRules='<rules>
			<rule type="required" />
			<rule type="email" contexts="*" failureMessage="Hey, buddy, you call that an Email Address?" />
		</rules>';

	property name="userPass" displayName="Password" vtRules='<rules>
			<rule type="required" />
			<rule type="rangelength">
				<param name="minlength" value="5" />
				<param name="maxlength" value="10" />
			</rule>
		</rules>';
	
	property name="nickname" vtRules='<rules>
			<rule type="custom" failureMessage="That Nickname is already taken.  Please try a different Nickname."> <!-- Specifying no context is the same as specifying a context of "*" -->
				<param name="methodname" value="CheckDupNickname" />
				<param name="remoteURL" value="CheckDupNickname.cfm" />
			</rule>
		</rules>';
	
	property name="salutation" vtRules='<rules>
			<rule type="required" contexts="Profile" />
			<rule type="regex"
				failureMessage="Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.">
				<param name="Regex" value="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$" />
			</rule>
		</rules>';
	
	property name="firstName" vtRules='<rules>
			<rule type="required" contexts="Profile" />
		</rules>';

	property name="lastName" vtRules='<rules>
			<rule type="required" contexts="Profile" />
			<rule type="required" contexts="Register">
				<param name="DependentPropertyName" value="FirstName" />
			</rule>
		</rules>';

	property name="likeCheese" ormtype="int" default="0";

	property name="likeChocolate" ormtype="int" default="0";

	property name="likeOther" displayName="What do you like?" vtRules='<rules>
			<rule type="required" condition="mustLikeSomething"
				failureMessage="If you don''t like Cheese and you don''t like Chocolate, you must like something!">
			</rule>
		</rules>';

	property name="allowCommunication" ormtype="int";

	property name="communicationMethod" vtRules='<rules>
			<rule type="required"
				failureMessage="If you are allowing communication, you must choose a communication method.">
				<param name="DependentPropertyName" value="AllowCommunication" />
				<param name="DependentPropertyValue" value="1" />
			</rule>
		</rules>';

	property name="howMuch" displayName="How much money would you like?" ormtype="double" default="0" vtRules='<rules>
			<rule type="numeric" />
		</rules>';

	property name="userGroup" fieldtype="many-to-one" cfc="UserGroup" fkcolumn="UserGroupId" vtClientFieldName="userGroupId" vtRules='<rules>
			<rule type="required" />
		</rules>';
	
	property name="LastUpdateTimestamp" ormtype="timestamp";
	
	property name="verifyPassword" persistent="false" vtRules='<rules>
			<rule type="required" />
			<rule type="equalTo">
				<param name="ComparePropertyName" value="UserPass" />
			</rule>
		</rules>';
	
	public struct function checkDupNickname() {
		// This is just a "mock" method to test out the custom validation type
		var returnStruct = {isSuccess = false, failureMessage = "That Nickname has already been used. Try to be more original!"};
		if (getNickname() NEQ "BobRules") {
			returnStruct = {isSuccess = true};
		}
		return returnStruct;		
	}
	
	public void function setUserGroupId(userGroupId) hint="used to populate the UserGroup from the form" {
		var userGroup = entityLoadByPK("UserGroup",val(arguments.userGroupId));
		if (not isNull(userGroup)) {
			variables.UserGroup = userGroup;
		}
	}
	
	public boolean function testCondition(string condition) {
		return evaluate(arguments.condition);
	}

}

