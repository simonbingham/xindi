<!---
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false">
	
	<cfproperty name="userId" />
	<cfproperty name="userName" displayname="Email Address" vtRules='<rules><rule type="required" contexts="*" />
			<rule type="email" contexts="*" failureMessage="Hey, buddy, you call that an Email Address?" /></rules>' />

	<cffunction name="init" access="public" returntype="any">
		<cfargument name="userId" default="" />
		<cfargument name="userName" default="" />
		<cfargument name="userPass" default="" />
		<cfargument name="nickname" default="" />
		<cfargument name="salutation" default="" />
		<cfargument name="firstName" default="" />
		<cfargument name="lastName" default="" />
		<cfargument name="likeCheese" default="0" />
		<cfargument name="likeChocolate" default="0" />
		<cfargument name="likeOther" default="" />
		<cfargument name="allowCommunication" default="0" />
		<cfargument name="communicationMethod" default="" />
		<cfargument name="howMuch" default="" />
		<cfargument name="userGroup" />
		<cfset variables.userId = arguments.userId />
		<cfset variables.userName = arguments.userName />
		<cfset variables.userPass = arguments.userPass />
		<cfset variables.nickname = arguments.nickname />
		<cfset variables.salutation = arguments.salutation />
		<cfset variables.firstName = arguments.firstName />
		<cfset variables.lastName = arguments.lastName />
		<cfset variables.likeCheese = arguments.likeCheese />
		<cfset variables.likeChocolate = arguments.likeChocolate />
		<cfset variables.likeOther = arguments.likeOther />
		<cfset variables.lastUpdateTimestamp = now() />
		<cfset variables.allowCommunication = arguments.allowCommunication />
		<cfset variables.communicationMethod = arguments.communicationMethod />
		<cfset variables.howMuch = arguments.howMuch />
		<cfif structKeyExists(arguments,"userGroup")>
			<cfset variables.userGroup = arguments.userGroup />
		</cfif>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="CheckDupNickname" access="public" output="false" returntype="any" hint="Checks for a duplicate UserName.">

		<!--- This is just a "mock" method to test out the custom validation type --->
		<cfset var ReturnStruct = StructNew() />
		<cfset ReturnStruct.IsSuccess = false />
		<cfset ReturnStruct.FailureMessage = "That Nickname has already been used. Try to be more original!" />
		<cfif getNickname() NEQ "BobRules">
			<cfset ReturnStruct = StructNew() />
			<cfset ReturnStruct.IsSuccess = true />
		</cfif>
		<cfreturn ReturnStruct />		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

	<cffunction name="setUserId" access="public" returntype="any">
		<cfargument name="userId" />
		<cfset variables.userId = arguments.userId />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserId" access="public" returntype="any">
		<cfreturn variables.userId />
	</cffunction>

	<cffunction name="setUserName" access="public" returntype="any">
		<cfargument name="userName" />
		<cfset variables.userName = arguments.userName />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserName" access="public" returntype="any">
		<cfreturn variables.userName />
	</cffunction>

	<cffunction name="setUserPass" access="public" returntype="any">
		<cfargument name="userPass" />
		<cfset variables.userPass = arguments.userPass />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserPass" access="public" returntype="any">
		<cfreturn variables.userPass />
	</cffunction>

	<cffunction name="setNickname" access="public" returntype="any">
		<cfargument name="nickname" />
		<cfset variables.nickname = arguments.nickname />
		<cfreturn this />
	</cffunction>
	<cffunction name="getNickname" access="public" returntype="any">
		<cfreturn variables.nickname />
	</cffunction>

	<cffunction name="setSalutation" access="public" returntype="any">
		<cfargument name="salutation" />
		<cfset variables.salutation = arguments.salutation />
		<cfreturn this />
	</cffunction>
	<cffunction name="getSalutation" access="public" returntype="any">
		<cfreturn variables.salutation />
	</cffunction>

	<cffunction name="setFirstName" access="public" returntype="any">
		<cfargument name="firstName" />
		<cfset variables.firstName = arguments.firstName />
		<cfreturn this />
	</cffunction>
	<cffunction name="getFirstName" access="public" returntype="any">
		<cfreturn variables.firstName />
	</cffunction>
	
	<cffunction name="setLastName" access="public" returntype="any">
		<cfargument name="lastName" />
		<cfset variables.lastName = arguments.lastName />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLastName" access="public" returntype="any">
		<cfreturn variables.lastName />
	</cffunction>
	
	<cffunction name="setLikeCheese" access="public" returntype="any">
		<cfargument name="likeCheese" />
		<cfset variables.likeCheese = arguments.likeCheese />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLikeCheese" access="public" returntype="any">
		<cfreturn variables.likeCheese />
	</cffunction>
	
	<cffunction name="setLikeChocolate" access="public" returntype="any">
		<cfargument name="likeChocolate" />
		<cfset variables.likeChocolate = arguments.likeChocolate />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLikeChocolate" access="public" returntype="any">
		<cfreturn variables.likeChocolate />
	</cffunction>

	<cffunction name="setLikeOther" access="public" returntype="any">
		<cfargument name="likeOther" />
		<cfset variables.likeOther = arguments.likeOther />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLikeOther" access="public" returntype="any">
		<cfreturn variables.likeOther />
	</cffunction>

	<cffunction name="setAllowCommunication" access="public" returntype="any">
		<cfargument name="allowCommunication" />
		<cfset variables.allowCommunication = arguments.allowCommunication />
		<cfreturn this />
	</cffunction>
	<cffunction name="getAllowCommunication" access="public" returntype="any">
		<cfreturn variables.allowCommunication />
	</cffunction>

	<cffunction name="setCommunicationMethod" access="public" returntype="any">
		<cfargument name="communicationMethod" />
		<cfset variables.communicationMethod = arguments.communicationMethod />
		<cfreturn this />
	</cffunction>
	<cffunction name="getCommunicationMethod" access="public" returntype="any">
		<cfreturn variables.communicationMethod />
	</cffunction>

	<cffunction name="setHowMuch" access="public" returntype="any">
		<cfargument name="howMuch" />
		<cfset variables.howMuch = arguments.howMuch />
		<cfreturn this />
	</cffunction>
	<cffunction name="getHowMuch" access="public" returntype="any">
		<cfreturn variables.howMuch />
	</cffunction>

	<cffunction name="setUserGroup" access="public" returntype="any">
		<cfargument name="userGroup" />
		<cfset variables.userGroup = arguments.userGroup />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserGroup" access="public" returntype="any">
		<cfreturn variables.userGroup />
	</cffunction>

	<cffunction name="setVerifyPassword" returntype="void" access="public" output="false">
		<cfargument name="VerifyPassword" type="any" required="true" />
		<cfset variables.VerifyPassword = arguments.VerifyPassword />
	</cffunction>
	<cffunction name="getVerifyPassword" access="public" output="false" returntype="any">
		<cfreturn variables.VerifyPassword />
	</cffunction>

</cfcomponent>


