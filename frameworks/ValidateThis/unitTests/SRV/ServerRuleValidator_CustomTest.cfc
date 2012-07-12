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
<cfcomponent extends="validatethis.unitTests.SRV.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("Custom");
			defaultMethod = "myMethod";
			parameters = {MethodName=defaultMethod};
			hasMethod = true;
			hasRemote = false;
			proxied = false;
			// create dynamically so doesn't need to run from webserver root
			defaultRemoteURL = ReReplace( CGI.SCRIPT_NAME, "unitTests(.)+", "" ) & "samples/remotedemo/remoteproxy.cfc";
		</cfscript>
	</cffunction>
	
	<cffunction name="configureValidationMock" access="private">
		<cfscript>
			super.configureValidationMock();
			validation.hasParameter("methodName").returns(hasMethod);
			validation.hasParameter("remoteURL").returns(hasRemote);
			validation.getParameterValue("methodName").returns(defaultMethod);
			validation.getParameterValue("remoteURL").returns(defaultRemoteURL);
			validation.getParameterValue("proxied","false").returns(proxied);
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidRemoteURLCall" access="public" returntype="void">
		<cfscript>
			defaultMethod = "isIndeedValid";
			
			debug( defaultRemoteURL );
			
			hasMethod = true;
			hasRemote = true;
			proxied = true;
			objectValue="";
			
			parameters = {remoteURL=defaultRemoteURL};

			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}");
		</cfscript>
	</cffunction>

	<cffunction name="validateReturnsFalseForInvalidRemoteURLCall" access="public" returntype="void">
		<cfscript>
			defaultMethod = "isInvalid";
			parameters = {remoteURL=defaultRemoteURL};
			hasMethod = true;
			hasRemote = true;
			proxied = true;
			objectValue="";
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>
	</cffunction>

	<cffunction name="validateReturnsFalseWhenMethodReturnsFailure" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			theObject.myMethod().returns(customResult);
			objectValue="";
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueWhenMethodReturnsSuccess" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=true,FailureMessage=""};
			theObject.myMethod().returns(customResult);
			objectValue="";            
			
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenMethodReturnsFalse" access="public" returntype="void">
		<cfscript>
			customResult = false;
			theObject.myMethod().returns(customResult);
			objectValue="";
			failureMessage = "A custom validator failed.";
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueWhenMethodReturnsTrue" access="public" returntype="void">
		<cfscript>
			customResult = true;
			theObject.myMethod().returns(customResult);
			objectValue = "";
			
			configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(0).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateGeneratesProperErrorMessageWhenOverriddenInXML" access="public" returntype="void">
		<cfscript>
			SRV = getSRV("Custom","");
			customResult = false;
			theObject.myMethod().returns(customResult);
			objectValue = "";
			failureMessage = "A custom failure message.";
            
            configureValidationMock();
			
			executeValidate(validation);
			validation.verifyTimes(1).fail(failureMessage); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			theObject.myMethod().returns(customResult);
			objectValue = "";
			isRequired = false;
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			theObject.myMethod().returns(customResult);
			objectValue = "";
            isRequired = true;
            
            configureValidationMock();
            
			executeValidate(validation);
			validation.verifyTimes(1).fail("{*}"); 
		</cfscript>  
	</cffunction>

</cfcomponent>
