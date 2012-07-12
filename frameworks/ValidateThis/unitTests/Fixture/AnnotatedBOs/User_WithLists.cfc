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
	
	property name="userName" vtDesc="Email Address" vtRules='[
		{"type":"required","contexts":"*"},
		{"type":"email","failureMessage":"Hey, buddy, you call that an Email Address?"}
		]';

	property name="userPass" displayName="Password" vtRules='[
			{"type":"required"},
			{"type":"rangelength",
				"params" : [
					{"name":"minlength","value":"5"},
					{"name":"maxlength","value":"10"}
				]
			}
		]';
	
	property name="nickname" vtRules='[
			{"type":"custom","failureMessage":"That Nickname is already taken. Please try a different Nickname.",
				"params":[
					{"name":"methodName","value":"CheckDupNickname"},
					{"name":"remoteURL","value":"CheckDupNickname.cfm"}
				]}
		]';
	
	property name="salutation" vtRules='[
			{"type":"required","contexts":"Profile"},
			{"type":"regex","failureMessage":"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.",
				"params" : [
					{"name":"Regex","value":"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\\.)?$"}
				]
			}
		]';
	
	property name="firstName" vtRules='[
			{"type":"required","contexts":"Profile"}
		]';

	property name="lastName" vtRules='[
			{"type":"required","contexts":"Profile"},
			{"type":"required","contexts":"Register",
				"params" : [
					{"name":"DependentPropertyName","value":"FirstName"}
				]
			}
		]';

	property name="likeCheese" ormtype="int" default="0";

	property name="likeChocolate" ormtype="int" default="0";

	property name="likeOther" displayName="What do you like?" vtRules='[
			{"type":"required","condition":"mustLikeSomething","failureMessage":"If you don''t like cheese and you don''t like chocolate, you must like something!"}
		]';

	property name="allowCommunication" ormtype="int";

	property name="communicationMethod" vtRules='[
			{"type":"required","failureMessage":"If you are allowing communication, you must choose a communication method.",
				"params" : [
					{"name":"DependentPropertyName","value":"AllowCommunication"},
					{"name":"DependentPropertyValue","value":"1"}
				]
			}
		]';

	property name="howMuch" displayName="How much money would you like?" ormtype="double" default="0" vtRules='[
			{"type":"numeric"}
		]';

	property name="userGroup" fieldtype="many-to-one" cfc="UserGroup" fkcolumn="UserGroupId" vtClientFieldName="userGroupId" vtRules='[
			{"type":"required"}
		]';
	
	property name="LastUpdateTimestamp" ormtype="timestamp";
	
	property name="verifyPassword" persistent="false" vtRules='[
			{"type":"required"},
			{"type":"equalTo",
				"params" : [
					{"name":"ComparePropertyName","value":"UserPass"}
				]
			}
		]';
	
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

