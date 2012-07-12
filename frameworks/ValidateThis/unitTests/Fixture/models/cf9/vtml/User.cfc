/*	
	Copyright 2010, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
*/
component accessors="true" vtContexts='' vtConditions='' {
	
	property name="userId" type="numeric" fieldtype="id" generator="native";
	
	property name="userName" vtDesc="Email Address" 
		vtRules='
			required()[*];
			email() "Hey, buddy, you call that an Email Address?";
		';

	property name="userPass" displayName="Password" 
		vtRules='
			required();
			rangelength(minlength=5|maxLength=10);
		';
	
	property name="nickname" 
		vtRules='
			custom(methodName=CheckDupNickname|remoteURL=CheckDupNickName.cfm) "That Nickname is already taken. Please try a different Nickname.";
		';
		
	property name="salutation" 
		vtRules='
			required()[Profile];
			regex(regex=^(Dr|Prof|Mr|Mrs|Ms|Miss)(\\.)?$) "Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.";
		';
		
	property name="firstName" 
		vtRules='
			required()[Profile];
		';

	property name="lastName" 
		vtRules='
			required()[Profile];
			required(DependentPropertyName="FirstName")[Register];
		';

	property name="likeCheese" ormtype="int" default="0";

	property name="likeChocolate" ormtype="int" default="0";

	property name="likeOther" displayName="What do you like?" 
		vtRules='
			required() {mustLikeSomething} "If you don''t like cheese and you don''t like chocolate, you must like something!";
		';

	property name="allowCommunication" ormtype="int";

	property name="communicationMethod" 
		vtRules='
			required(DependentPropertyName=AllowCommunication|DependentPropertyValue=1) "If you are allowing communication, you must choose a communication method.";
		';
		
	property name="howMuch" displayName="How much money would you like?" ormtype="double" default="0" 
		vtRules='
			numeric();
		';

	property name="userGroup" 
	    vtClientFieldName="userGroupId" 
		vtRules='
			required();
			isValidObject();
		';
	
	property name="LastUpdateTimestamp" ormtype="timestamp";
	
	property name="verifyPassword" persistent="false" 
		vtRules='
			required();
			equalTo(ComparePropertyName=UserPass);
		';
	
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
