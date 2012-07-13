<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->

<cfcomponent displayname="user" output="false">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="userId" required="true" type="any" />
		
		<cfset var i = "">
		
		<cfif arguments.userId neq 1>
			<cfloop collection="#this#" item="i">
				<cfif left(i,3) eq "set">
					<cfset variables[right(i,len(i)-3)] = "" />
				</cfif>
			</cfloop>
			<cfset variables.userGroup = createObject("component","userGroup").init() />
		<cfelse>
			<cfloop collection="#this#" item="i">
				<cfif left(i,3) eq "set">
					<cfset variables[right(i,len(i)-3)] = randrange(100000,999999) />
				</cfif>
			</cfloop>
			<cfset variables.userGroup = createObject("component","userGroup").init(1) />
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="populate" access="public" output="false" returntype="any" hint="Populates the object with values from the argumemnts">
		<cfargument name="data" type="any" required="yes" />

        <cfset var i = 0 />
		
		<cfloop collection="#arguments.data#" item="i">
			<cfif structKeyExists(this,"set" & i)>
				<cfset variables[i] = trim(arguments.data[i]) />
			</cfif>
		</cfloop>
		
    </cffunction>

	<cffunction name="getMemento" access="public" output="false" returntype="any">
		<cfreturn variables />
    </cffunction>

	<cffunction name="save" access="public" output="false" returntype="void" hint="An empty method as this is just a demo">
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

	<cffunction name="setVerifyPassword" returntype="void" access="public" output="false">
		<cfargument name="VerifyPassword" type="any" required="true" />
		<cfif arguments.VerifyPassword eq "structok">
			<cfset variables.VerifyPassword = {a=1,b=2,c=3} />
		<cfelseif arguments.verifypassword eq "structbad">
			<cfset variables.VerifyPassword = {a=1} />
		<cfelseif arguments.verifypassword eq "arrayok">
			<cfset variables.VerifyPassword = [1,2,3] />
		<cfelseif arguments.verifypassword eq "arraybad">
			<cfset variables.VerifyPassword = [1] />
		<cfelse>
			<cfset variables.VerifyPassword = arguments.VerifyPassword />
		</cfif>
	</cffunction>
	<cffunction name="getVerifyPassword" access="public" output="false" returntype="any">
		<cfreturn variables.VerifyPassword />
	</cffunction>

	<!--- property getters and setters --->	
	<cffunction name="setUserId" access="public" returntype="any" output="false">
		<cfargument name="userId" />
		<cfset variables.userId = arguments.userId />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserId" access="public" returntype="any" output="false">
		<cfreturn variables.userId />
	</cffunction>
	<cffunction name="setNickname" access="public" returntype="any" output="false">
		<cfargument name="nickname" />
		<cfset variables.nickname = arguments.nickname />
		<cfreturn this />
	</cffunction>
	<cffunction name="getNickname" access="public" returntype="any" output="false">
		<cfreturn variables.nickname />
	</cffunction>
	<cffunction name="setUserName" access="public" returntype="any" output="false">
		<cfargument name="userName" />
		<cfset variables.userName = arguments.userName />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserName" access="public" returntype="any" output="false">
		<cfreturn variables.userName />
	</cffunction>
	<cffunction name="setUserPass" access="public" returntype="any" output="false">
		<cfargument name="userPass" />
		<cfset variables.userPass = arguments.userPass />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserPass" access="public" returntype="any" output="false">
		<cfreturn variables.userPass />
	</cffunction>
	<cffunction name="setUserGroup" access="public" returntype="any" output="false">
		<cfargument name="userGroup" />
		<cfset variables.userGroup = arguments.userGroup />
		<cfreturn this />
	</cffunction>
	<cffunction name="getUserGroup" access="public" returntype="any" output="false">
		<cfreturn variables.userGroup />
	</cffunction>
	<cffunction name="setSalutation" access="public" returntype="any" output="false">
		<cfargument name="salutation" />
		<cfset variables.salutation = arguments.salutation />
		<cfreturn this />
	</cffunction>
	<cffunction name="getSalutation" access="public" returntype="any" output="false">
		<cfreturn variables.salutation />
	</cffunction>
	<cffunction name="setFirstName" access="public" returntype="any" output="false">
		<cfargument name="firstName" />
		<cfset variables.firstName = arguments.firstName />
		<cfreturn this />
	</cffunction>
	<cffunction name="getFirstName" access="public" returntype="any" output="false">
		<cfreturn variables.firstName />
	</cffunction>
	<cffunction name="setLastName" access="public" returntype="any" output="false">
		<cfargument name="lastName" />
		<cfset variables.lastName = arguments.lastName />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLastName" access="public" returntype="any" output="false">
		<cfreturn variables.lastName />
	</cffunction>
	<cffunction name="setLikeOther" access="public" returntype="any" output="false">
		<cfargument name="likeOther" />
		<cfset variables.likeOther = arguments.likeOther />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLikeOther" access="public" returntype="any" output="false">
		<cfreturn variables.likeOther />
	</cffunction>
	<cffunction name="setHowMuch" access="public" returntype="any" output="false">
		<cfargument name="howMuch" />
		<cfset variables.howMuch = arguments.howMuch />
		<cfreturn this />
	</cffunction>
	<cffunction name="getHowMuch" access="public" returntype="any" output="false">
		<cfreturn variables.howMuch />
	</cffunction>
	<cffunction name="setLikeChocolate" access="public" returntype="any" output="false">
		<cfargument name="likeChocolate" />
		<cfset variables.likeChocolate = arguments.likeChocolate />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLikeChocolate" access="public" returntype="any" output="false">
		<cfreturn variables.likeChocolate />
	</cffunction>
	<cffunction name="setLikeCheese" access="public" returntype="any" output="false">
		<cfargument name="likeCheese" />
		<cfset variables.likeCheese = arguments.likeCheese />
		<cfreturn this />
	</cffunction>
	<cffunction name="getLikeCheese" access="public" returntype="any" output="false">
		<cfreturn variables.likeCheese />
	</cffunction>
	<cffunction name="setAllowCommunication" access="public" returntype="any" output="false">
		<cfargument name="allowCommunication" />
		<cfset variables.allowCommunication = arguments.allowCommunication />
		<cfreturn this />
	</cffunction>
	<cffunction name="getAllowCommunication" access="public" returntype="any" output="false">
		<cfreturn variables.allowCommunication />
	</cffunction>
	<cffunction name="setCommunicationMethod" access="public" returntype="any" output="false">
		<cfargument name="communicationMethod" />
		<cfset variables.communicationMethod = arguments.communicationMethod />
		<cfreturn this />
	</cffunction>
	<cffunction name="getCommunicationMethod" access="public" returntype="any" output="false">
		<cfreturn variables.communicationMethod />
	</cffunction>

</cfcomponent>

